import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Controller/GarmentController.dart';
import 'app_color.dart';

class BackgroundSelectionScreen extends StatefulWidget {
  final GarmentController garmentController;
  const BackgroundSelectionScreen({super.key, required this.garmentController});

  @override
  State<BackgroundSelectionScreen> createState() => _BackgroundSelectionScreenState();
}

class _BackgroundSelectionScreenState extends State<BackgroundSelectionScreen> {
  List<Map<String, dynamic>> backgrounds = [];
  String? selectedBackgroundId;
  bool isLoading = true;

  // Track loaded images to prevent showing loaders again
  final Map<String, bool> _loadedImages = {};

  @override
  void initState() {
    super.initState();
    fetchBackgrounds();
  }

  Future<void> fetchBackgrounds() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(Uri.parse('https://backendapp.stylic.ai/stylic/background-images'));
      if (response.statusCode == 200) {
        setState(() {
          backgrounds = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });

        // Preload images
        for (var background in backgrounds) {
          precacheImage(
              NetworkImage(background['background_image']),
              context
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load backgrounds')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching backgrounds: $e')),
      );
    }
  }

  void _openGalleryView(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BackgroundGalleryView(
          backgroundImages: backgrounds,
          initialIndex: initialIndex,
          onSelect: (id) {
            setState(() {
              selectedBackgroundId = id;
            });
            Navigator.pop(context);
          },
          loadedImages: _loadedImages,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : backgrounds.isEmpty
          ? const Center(child: Text('No backgrounds available'))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: backgrounds.length,
        itemBuilder: (context, index) {
          final background = backgrounds[index];
          final imageUrl = background['background_image'];
          final isSelected = background['id'].toString() == selectedBackgroundId;

          return GestureDetector(
            onTap: () {
              _openGalleryView(index);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      // Show loading indicator only if this image isn't already loaded
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          // Mark as loaded once complete
                          _loadedImages[imageUrl] = true;
                          return child;
                        }

                        // If already loaded before, don't show loading indicator
                        if (_loadedImages[imageUrl] == true) {
                          return child;
                        }

                        return Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColor.textColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: selectedBackgroundId != null
          ? Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.textColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            widget.garmentController.setBackgroundId(selectedBackgroundId!);

            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );

            // Submit all data
            bool success = await widget.garmentController.submitGarmentData();

            // Close loading indicator
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(

                backgroundColor: success ? Colors.green : Colors.red,
                content: Text(success
                    ? 'Submission successful!'
                    : 'Submission failed!'),
              ),
            );

            if (success) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
          child: const Text(
            'Confirm Selection',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      )
          : null,
    );
  }
}

class BackgroundGalleryView extends StatefulWidget {
  final List<Map<String, dynamic>> backgroundImages;
  final int initialIndex;
  final Function(String) onSelect;
  final Map<String, bool> loadedImages;

  const BackgroundGalleryView({
    Key? key,
    required this.backgroundImages,
    required this.initialIndex,
    required this.onSelect,
    required this.loadedImages,
  }) : super(key: key);

  @override
  State<BackgroundGalleryView> createState() => _BackgroundGalleryViewState();
}

class _BackgroundGalleryViewState extends State<BackgroundGalleryView> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Background ${_currentIndex + 1}/${widget.backgroundImages.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onSelect(widget.backgroundImages[_currentIndex]['id'].toString());
            },
            tooltip: 'Select this background',
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          final imageUrl = widget.backgroundImages[index]['background_image'];

          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrl),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes: PhotoViewHeroAttributes(tag: "bg_image_$index"),
          );
        },
        itemCount: widget.backgroundImages.length,
        // Show loading indicator only for images that haven't been loaded yet
        loadingBuilder: (context, event) {
          final imageUrl = widget.backgroundImages[_currentIndex]['background_image'];

          // Skip showing loader if image already loaded before
          if (widget.loadedImages[imageUrl] == true) {
            return Container(); // Return empty container if already loaded
          }

          return const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          );
        },
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        pageController: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
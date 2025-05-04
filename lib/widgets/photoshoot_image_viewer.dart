import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoshootImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const PhotoshootImageViewer({
    Key? key,
    required this.imageUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _PhotoshootImageViewerState createState() => _PhotoshootImageViewerState();
}

class _PhotoshootImageViewerState extends State<PhotoshootImageViewer> {
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
        backgroundColor: Colors.black.withOpacity(0.5),
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / ${widget.imageUrls.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing coming soon')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 4,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 60, color: Colors.white),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          // Navigation arrows
          if (widget.imageUrls.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.imageUrls.length; i++)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _currentIndex ? Colors.white : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
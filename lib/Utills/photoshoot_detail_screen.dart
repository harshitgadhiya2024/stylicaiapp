import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stylicai/Controller/upload_back_garment_controller.dart';
import 'package:stylicai/Utills/upload_back_photo_screen.dart';

import '../Model/photoshoot.dart';
import '../widgets/photoshoot_image_viewer.dart';
import 'app_color.dart';

class PhotoshootDetailScreen extends StatelessWidget {
  final Photoshoot photoshoot;

  const PhotoshootDetailScreen({Key? key, required this.photoshoot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainImage(),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 30, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBadge(),
                  const SizedBox(height: 14),
                  Divider(thickness: 1,),
                  const SizedBox(height: 24),
                  _buildSection('Photoshoot Details', Icons.photo_camera),
                  SizedBox(height: 10,),
                  _buildInfoRow('Photoshoot Type', photoshoot.photoshootType),
                  _buildInfoRow('Gender', photoshoot.gender),
                  _buildInfoRow('Age Group', photoshoot.ageGroup),

                  const SizedBox(height: 24),
                  _buildSection('Garment Information', Icons.checkroom),
                  SizedBox(height: 10,),
                  _buildInfoRow('Garment Type', photoshoot.garmentType),
                  if (photoshoot.colorType != 'nothing')
                    _buildInfoRow('Color Type', photoshoot.colorType),

                  // Add Photoshoots Gallery if available
                  if (photoshoot.photoshoots.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildSection('Generated Photoshoots', Icons.collections),
                    const SizedBox(height: 8),
                    _buildPhotoshootsGallery(),
                  ],

                  const SizedBox(height: 24),
                  _buildSection('Background', Icons.image),
                  const SizedBox(height: 8),
                  _buildBackgroundImage(),

                  if (photoshoot.garmentDescription != 'nothing') ...[
                    const SizedBox(height: 24),
                    _buildSection('Description', Icons.description),
                    const SizedBox(height: 8),
                    Text(photoshoot.garmentDescription),
                  ],

                  const SizedBox(height: 32),
                  if (photoshoot.photoshoots.isEmpty)
                    _buildActionButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainImage() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: CachedNetworkImage(
        imageUrl: photoshoot.garmentPhotoPath,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image, size: 60),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Row(
      children: [
        Text(photoshoot.garmentType, style: TextStyle(color: AppColor.textColor, fontSize: 20, fontWeight: FontWeight.bold),),
        Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: photoshoot.isCompleted ? AppColor.buttonColor : AppColor.textColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            photoshoot.isCompleted ? 'Completed' : 'In Progress',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColor.buttonColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: AppColor.buttonColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: photoshoot.backgroundImage,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.broken_image, size: 40),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhotoshootsGallery() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photoshoot.photoshoots.length,
        itemBuilder: (context, index) {
          final photoUrl = photoshoot.photoshoots[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                _showFullScreenImage(context, photoUrl, index);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 150,
                  child: CachedNetworkImage(
                    imageUrl: photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 40),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoshootImageViewer(
          imageUrls: photoshoot.photoshoots,
          initialIndex: index,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    // Button text depends on the status
    String buttonText;

    buttonText = 'Upload Back';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final UploadBackGarmentController uploadBackGarmentController = UploadBackGarmentController();
          uploadBackGarmentController.setphotoshootId(photoshoot.photoshootId.toString());
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UploadBackPhotoScreen(uploadBackGarmentController: uploadBackGarmentController,),
          ));
          },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColor.textColor,
          foregroundColor: Colors.white,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
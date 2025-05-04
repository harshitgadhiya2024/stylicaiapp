class Photoshoot {
  final String ageGroup;
  final String backgroundImage;
  final String colorType;
  final String garmentDescription;
  final String garmentPhotoPath;
  final String garmentType;
  final String gender;
  final bool isCompleted;
  final bool isMoney;
  final String photoshootType;
  final List<String> photoshoots;
  final String userId;
  final String photoshootId;

  Photoshoot({
    required this.ageGroup,
    required this.backgroundImage,
    required this.colorType,
    required this.garmentDescription,
    required this.garmentPhotoPath,
    required this.garmentType,
    required this.gender,
    required this.isCompleted,
    required this.isMoney,
    required this.photoshootType,
    required this.photoshoots,
    required this.userId,
    required this.photoshootId,
  });

  factory Photoshoot.fromJson(Map<String, dynamic> json) {
    // Parse photoshoots array - if it's null or not a list, use an empty list
    List<String> photoshoots = [];
    if (json['photoshoots'] != null && json['photoshoots'] is List) {
      photoshoots = List<String>.from(json['photoshoots']);
    }

    return Photoshoot(
      ageGroup: json['age_group'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      colorType: json['color_type'] ?? '',
      garmentDescription: json['garment_description'] ?? '',
      garmentPhotoPath: json['garment_photo_path'] ?? '',
      garmentType: json['garment_type'] ?? '',
      gender: json['gender'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      isMoney: json['is_money'] ?? false,
      photoshootType: json['photoshoot_type'] ?? '',
      photoshoots: photoshoots,
      userId: json['user_id'] ?? '',
      photoshootId: json['photoshoot_id'] ?? '',
    );
  }
}
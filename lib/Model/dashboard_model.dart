class DashboardResponse {
  final DashboardData data;
  final int status;
  final String timestamp;

  DashboardResponse({
    required this.data,
    required this.status,
    required this.timestamp,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      data: DashboardData.fromJson(json['data']),
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }
}

class DashboardData {
  final Map<String, int> cateBaasedMapping;
  final int completedPhotoshoot;
  final int pendingPhotoshoot;
  final int photoCredit;
  final int photoshootCredit;
  final int totalPhotoshoot;

  DashboardData({
    required this.cateBaasedMapping,
    required this.completedPhotoshoot,
    required this.pendingPhotoshoot,
    required this.photoCredit,
    required this.photoshootCredit,
    required this.totalPhotoshoot,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      cateBaasedMapping: Map<String, int>.from(json['cate_based_mapping']),
      completedPhotoshoot: json['completed_photoshoot'],
      pendingPhotoshoot: json['pending_photoshoot'],
      photoCredit: json['photo_credit'],
      photoshootCredit: json['photoshoot_credit'],
      totalPhotoshoot: json['total_photoshoot'],
    );
  }
}
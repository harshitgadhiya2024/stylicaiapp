class LocationData {
  final List<CityLocation> data;
  final int status;
  final String timestamp;

  LocationData({
    required this.data,
    required this.status,
    required this.timestamp,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      data: (json['data'] as List)
          .map((location) => CityLocation.fromJson(location))
          .toList(),
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }
}

class CityLocation {
  final String address;
  final String cityName;
  final double distanceFromStartKm;
  final List<double> location;

  CityLocation({
    required this.address,
    required this.cityName,
    required this.distanceFromStartKm,
    required this.location,
  });

  factory CityLocation.fromJson(Map<String, dynamic> json) {
    return CityLocation(
      address: json['address'],
      cityName: json['city_name'],
      distanceFromStartKm: json['distance_from_start_km'],
      location: (json['location'] as List).map((e) => e as double).toList(),
    );
  }

  double get latitude => location[0];
  double get longitude => location[1];
}
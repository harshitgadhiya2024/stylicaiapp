
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:google_place/google_place.dart';

class RouteController extends GetxController {
  Rx<LatLng?> pickupLatLng = Rx<LatLng?>(null);
  Rx<LatLng?> dropoffLatLng = Rx<LatLng?>(null);
  RxString pickupAddress = ''.obs;
  RxString dropoffAddress = ''.obs;
  var selectedLatLng = Rx<LatLng?>(null);
  var selectedAddress = Rx<String>('');
  RxString distance = ''.obs;
  RxString time = ''.obs;
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  RxBool isLoading = false.obs;

  // Add GooglePlace instance
  final GooglePlace googlePlace = GooglePlace("AIzaSyB-Z1yfO79TH2uuDT9-fu-0YmHCRL_B9IA");

  // Set pickup address and get coordinates
  Future<void> setPickupAddress(String address) async {
    isLoading.value = true;
    pickupAddress.value = address;
    print("Setting pickup address: $address");

    // Get coordinates from address
    await _getCoordinatesFromAddress(address, true);
    isLoading.value = false;
  }

  // Set dropoff address and get coordinates
  Future<void> setDropoffAddress(String address) async {
    isLoading.value = true;
    dropoffAddress.value = address;
    print("Setting dropoff address: $address");

    // Get coordinates from address
    await _getCoordinatesFromAddress(address, false);
    isLoading.value = false;
  }

  // Helper method to get coordinates from address
  Future<void> _getCoordinatesFromAddress(String address, bool isPickup) async {
    print("Getting coordinates for address: $address");
    try {
      // Use autocomplete to get place ID
      var result = await googlePlace.autocomplete.get(address);
      if (result != null && result.predictions != null && result.predictions!.isNotEmpty) {
        String? placeId = result.predictions![0].placeId;

        if (placeId != null) {
          // Get details using place ID
          var details = await googlePlace.details.get(placeId);
          if (details != null && details.result != null &&
              details.result!.geometry != null &&
              details.result!.geometry!.location != null) {

            double? lat = details.result!.geometry!.location!.lat;
            double? lng = details.result!.geometry!.location!.lng;

            if (lat != null && lng != null) {
              LatLng coordinates = LatLng(lat, lng);
              print("Got coordinates for $address: $lat, $lng");

              if (isPickup) {
                pickupLatLng.value = coordinates;
                print("Pickup LatLng set: ${pickupLatLng.value}");
              } else {
                dropoffLatLng.value = coordinates;
                print("Dropoff LatLng set: ${dropoffLatLng.value}");
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error getting coordinates: $e");
    }
  }

  Future<void> fetchRouteData() async {
    print("Fetching route data...");
    isLoading.value = true;

    // Verify we have both coordinates
    if (pickupLatLng.value == null || dropoffLatLng.value == null) {
      print("Cannot fetch route: coordinates are null");
      isLoading.value = false;
      return;
    }

    print("Making API request with coordinates: ${pickupLatLng.value!.latitude}, ${pickupLatLng.value!.longitude} to ${dropoffLatLng.value!.latitude}, ${dropoffLatLng.value!.longitude}");

    try {
      final response = await http.post(
        Uri.parse("https://stylicai.stylic.ai/stylicai/get-cities-for-location"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "pickup_lat": pickupLatLng.value!.latitude,
          "pickup_lng": pickupLatLng.value!.longitude,
          "drop_lat": dropoffLatLng.value!.latitude,
          "drop_lng": dropoffLatLng.value!.longitude,
        }),
      );

      print("API Response status: ${response.statusCode}");
      print("API Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if data structure is as expected
        if (data['data'] != null) {
          // Set distance and time values
          if (data['data']['distance'] != null) {
            distance.value = data['data']['distance'].toString();
            print("Distance set to: ${distance.value}");
          }

          if (data['data']['time'] != null) {
            time.value = data['data']['time'].toString();
            print("Time set to: ${time.value}");
          }

          // Handle polyline
          if (data['data']['polyline'] != null) {
            try {
              polylineCoordinates.value = decodePolyline(data['data']['polyline']);
              print("Decoded polyline with ${polylineCoordinates.length} points");
            } catch (e) {
              print("Error decoding polyline: $e");
              _createSimplePolyline();
            }
          } else {
            print("No polyline in response, creating simple line");
            _createSimplePolyline();
          }
        } else {
          print("Unexpected response format: $data");
          _createSimplePolyline();
        }
      } else {
        print("API Error: ${response.body}");
        _createSimplePolyline();
      }
    } catch (e) {
      print("Exception while fetching route: $e");
      _createSimplePolyline();
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to create a simple straight-line polyline
  void _createSimplePolyline() {
    if (pickupLatLng.value != null && dropoffLatLng.value != null) {
      polylineCoordinates.value = [
        pickupLatLng.value!,
        dropoffLatLng.value!
      ];
      print("Created simple polyline with 2 points");

      // Calculate approximate distance if API didn't provide it
      if (distance.value.isEmpty) {
        double distanceInMeters = calculateDistance(
            pickupLatLng.value!.latitude,
            pickupLatLng.value!.longitude,
            dropoffLatLng.value!.latitude,
            dropoffLatLng.value!.longitude
        );
        distance.value = "${(distanceInMeters / 1000).toStringAsFixed(2)} km";
        print("Calculated distance: ${distance.value}");
      }
    }
  }

  // Add a simple distance calculation method
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // meters
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
                sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    try {
      while (index < len) {
        int b, shift = 0, result = 0;
        do {
          b = encoded.codeUnitAt(index++) - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
        } while (b >= 0x20);
        int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lat += dlat;

        shift = 0;
        result = 0;
        do {
          b = encoded.codeUnitAt(index++) - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
        } while (b >= 0x20);
        int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
        lng += dlng;

        polyline.add(LatLng(lat / 1E5, lng / 1E5));
      }
    } catch (e) {
      print("Error decoding polyline: $e");
    }

    return polyline;
  }
}
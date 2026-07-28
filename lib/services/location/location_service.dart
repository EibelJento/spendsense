
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentPosition() async {
    // Check if location services are enabled
    if (!await Geolocator.isLocationServiceEnabled()) {
      return null;
    }

    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String?> getAddressFromCoordinates(
    double? latitude,
    double? longitude,
  ) async {
    if (latitude == null || longitude == null) {
      return null;
    }

    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return null;
      }

      final place = placemarks.first;

      return [
        place.name,
        place.street,
        place.locality,
        place.administrativeArea,
        place.country,
      ]
          .where((e) => e?.trim().isNotEmpty ?? false)
          .join(', ');
    } catch (e) {
      return null;
    }
  }
}
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    final result = await Permission.location.request();

    return result.isGranted;
  }

  Future<bool> hasLocationPermission() async {
    return await Permission.location.isGranted;
  }
}
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/device_details.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';

/// Profile document, photo update, and device details.
abstract class ProfileRepository {
  Future<AppUser> getProfile(String userId);

  Future<AppUser> updatePhoto({
    required String userId,
    required String filePath,
  });

  Future<DeviceDetails> getDeviceInfo();
}

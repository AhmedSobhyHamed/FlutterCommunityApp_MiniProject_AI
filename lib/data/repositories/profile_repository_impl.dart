import 'package:fluttercommunityapp_miniproject_ai/data/models/user_model.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/device_details.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/profile_repository.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/device_info_service.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/firestore_service.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/storage_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required FirestoreService firestoreService,
    required StorageService storageService,
    required DeviceInfoService deviceInfoService,
  }) : _firestoreService = firestoreService,
       _storageService = storageService,
       _deviceInfoService = deviceInfoService;

  final FirestoreService _firestoreService;
  final StorageService _storageService;
  final DeviceInfoService _deviceInfoService;

  @override
  Future<AppUser> getProfile(String userId) async {
    final snapshot = await _firestoreService.users.doc(userId).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return UserBuilder().setId(userId).build();
    }
    return UserModel.fromJson({...data, 'id': snapshot.id});
  }

  @override
  Future<AppUser> updatePhoto({
    required String userId,
    required String filePath,
  }) async {
    final downloadUrl = await _storageService.uploadProfilePhoto(
      userId: userId,
      filePath: filePath,
    );
    final current = await getProfile(userId);
    final updated = UserBuilder()
        .setId(current.id)
        .setFullName(current.fullName)
        .setEmail(current.email)
        .setPhotoUrl(downloadUrl)
        .build();
    await _firestoreService.users.doc(userId).set(updated.toJson());
    return updated;
  }

  @override
  Future<DeviceDetails> getDeviceInfo() => _deviceInfoService.read();
}

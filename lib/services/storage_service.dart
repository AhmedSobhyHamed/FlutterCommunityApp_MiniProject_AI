import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// Uploads the gallery file and returns a download URL stored on the user document.
class StorageService {
  StorageService({required FirebaseStorage storage}) : _storage = storage;

  final FirebaseStorage _storage;

  Future<String> uploadProfilePhoto({
    required String userId,
    required String filePath,
  }) async {
    final ref = _storage.ref().child('profile_photos/$userId.jpg');
    await ref.putFile(File(filePath));
    return ref.getDownloadURL();
  }
}

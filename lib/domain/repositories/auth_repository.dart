import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';

/// Email and password authentication plus the saved profile.
abstract class AuthRepository {
  Stream<AppUser?> watchAuthState();

  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> signOut();
}

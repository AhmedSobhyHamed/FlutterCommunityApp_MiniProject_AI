import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:fluttercommunityapp_miniproject_ai/data/models/user_model.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/auth_repository.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/auth_service.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/firestore_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
    required FirestoreService firestoreService,
  }) : _authService = authService,
       _firestoreService = firestoreService;

  final AuthService _authService;
  final FirestoreService _firestoreService;

  @override
  Stream<AppUser?> watchAuthState() {
    return _authService.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      return _loadProfile(firebaseUser);
    });
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signIn(
      email: email.trim(),
      password: password,
    );
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw fb.FirebaseAuthException(
        code: 'user-not-found',
        message: 'No account was returned.',
      );
    }
    return _loadProfile(firebaseUser);
  }

  @override
  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signUp(
      email: email.trim(),
      password: password,
    );
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw fb.FirebaseAuthException(
        code: 'user-not-found',
        message: 'The account could not be created.',
      );
    }
    await _authService.updateDisplayName(fullName.trim());

    // Builder — only id, name, and email come from the sign-up form.
    final user = UserBuilder()
        .setId(firebaseUser.uid)
        .setFullName(fullName.trim())
        .setEmail(email.trim())
        .build();

    await _firestoreService.users.doc(user.id).set(user.toJson());
    return user;
  }

  @override
  Future<void> signOut() => _authService.signOut();

  Future<AppUser> _loadProfile(fb.User firebaseUser) async {
    final snapshot = await _firestoreService.users.doc(firebaseUser.uid).get();
    final data = snapshot.data();
    if (snapshot.exists && data != null) {
      return UserModel.fromJson({...data, 'id': snapshot.id});
    }
    return UserBuilder()
        .setId(firebaseUser.uid)
        .setFullName(firebaseUser.displayName ?? '')
        .setEmail(firebaseUser.email ?? '')
        .build();
  }
}

import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication calls used by [AuthRepositoryImpl].
class AuthService {
  AuthService({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> updateDisplayName(String fullName) {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return Future.value();
    }
    return user.updateDisplayName(fullName);
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}

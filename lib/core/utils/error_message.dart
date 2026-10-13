import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';

/// Turns Firebase and network errors into a sentence the user can act on.
String friendlyError(Object error) {
  if (error is Failure) {
    return error.message;
  }
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'invalid-email' => 'That email address is not valid.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'Email or password is incorrect.',
      'email-already-in-use' => 'An account already exists for this email.',
      'weak-password' => 'Password must be at least 6 characters.',
      'operation-not-allowed' =>
        'Email and password sign-in is not enabled in Firebase.',
      'network-request-failed' =>
        'Check your internet connection and try again.',
      'too-many-requests' => 'Too many attempts. Wait a moment and try again.',
      _ => 'Sign-in failed. Please try again.',
    };
  }
  if (error is FirebaseException) {
    return switch (error.code) {
      'permission-denied' =>
        'Permission denied. Sign in, then check Firestore and Storage rules.',
      'unavailable' || 'network-request-failed' =>
        'Network problem. Check your connection and try again.',
      'unauthenticated' => 'Sign in again to continue.',
      _ => 'Something went wrong. Please try again.',
    };
  }
  return 'Something went wrong. Please try again.';
}

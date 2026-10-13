import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:local_auth/local_auth.dart';

/// Fingerprint gate used before the profile screen opens.
class BiometricService {
  BiometricService({LocalAuthentication? authentication})
    : _authentication = authentication ?? LocalAuthentication();

  final LocalAuthentication _authentication;

  Future<Result<bool>> authenticate() async {
    try {
      final supported = await _authentication.isDeviceSupported();
      final canCheck = await _authentication.canCheckBiometrics;
      if (!supported && !canCheck) {
        return const Err(
          Failure('This device has no fingerprint authentication.'),
        );
      }

      final granted = await _authentication.authenticate(
        localizedReason: 'Confirm your fingerprint to open your profile.',
        biometricOnly: true,
      );
      if (!granted) {
        return const Err(Failure('Fingerprint authentication was cancelled.'));
      }
      return const Success(true);
    } on LocalAuthException catch (error) {
      return Err(
        Failure(error.description ?? 'Fingerprint authentication failed.'),
      );
    } catch (_) {
      return const Err(Failure('Fingerprint authentication failed.'));
    }
  }
}

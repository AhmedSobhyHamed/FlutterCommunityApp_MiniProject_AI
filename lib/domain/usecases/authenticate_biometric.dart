import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/biometric_service.dart';

class AuthenticateBiometric {
  const AuthenticateBiometric(this._service);

  final BiometricService _service;

  Future<Result<bool>> call() => _service.authenticate();
}

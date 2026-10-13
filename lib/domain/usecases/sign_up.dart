import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/auth_repository.dart';

class SignUp {
  const SignUp(this._repository);

  final AuthRepository _repository;

  Future<Result<AppUser>> call({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _repository.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      return Success(user);
    } catch (error) {
      return Err(Failure(friendlyError(error)));
    }
  }
}

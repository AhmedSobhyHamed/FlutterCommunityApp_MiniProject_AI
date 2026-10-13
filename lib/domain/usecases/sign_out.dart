import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/auth_repository.dart';

class SignOut {
  const SignOut(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() async {
    try {
      await _repository.signOut();
      return const Success();
    } catch (error) {
      return Err(Failure(friendlyError(error)));
    }
  }
}

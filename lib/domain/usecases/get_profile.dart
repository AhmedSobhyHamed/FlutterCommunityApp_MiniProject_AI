import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/profile_repository.dart';

class GetProfile {
  const GetProfile(this._repository);

  final ProfileRepository _repository;

  Future<Result<AppUser>> call(String userId) async {
    try {
      final user = await _repository.getProfile(userId);
      return Success(user);
    } catch (error) {
      return Err(Failure(friendlyError(error)));
    }
  }
}

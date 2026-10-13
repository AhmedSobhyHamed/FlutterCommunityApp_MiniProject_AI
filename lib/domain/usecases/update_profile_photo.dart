import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/profile_repository.dart';

class UpdateProfilePhoto {
  const UpdateProfilePhoto(this._repository);

  final ProfileRepository _repository;

  Future<Result<AppUser>> call({
    required String userId,
    required String filePath,
  }) async {
    try {
      final user = await _repository.updatePhoto(
        userId: userId,
        filePath: filePath,
      );
      return Success(user);
    } catch (error) {
      return Err(Failure(friendlyError(error)));
    }
  }
}

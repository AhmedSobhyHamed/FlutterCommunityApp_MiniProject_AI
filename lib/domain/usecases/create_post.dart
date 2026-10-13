import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/validators.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/post_repository.dart';

class CreatePost {
  const CreatePost(this._repository);

  final PostRepository _repository;

  Future<Result<void>> call({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    final validation = validatePostContent(content);
    if (validation != null) {
      return Err(Failure(validation));
    }
    try {
      await _repository.createPost(
        authorId: authorId,
        authorName: authorName,
        content: content.trim(),
      );
      return const Success();
    } catch (error) {
      return Err(Failure(friendlyError(error)));
    }
  }
}

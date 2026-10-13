import 'package:fluttercommunityapp_miniproject_ai/domain/entities/post.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/post_repository.dart';

class GetPosts {
  const GetPosts(this._repository);

  final PostRepository _repository;

  Stream<List<Post>> call() => _repository.watchPosts();
}

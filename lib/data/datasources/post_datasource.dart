import 'package:fluttercommunityapp_miniproject_ai/domain/entities/post.dart';

/// Remote Firestore feed or the in-memory cache. The factory picks one.
abstract class PostDataSource {
  Stream<List<Post>> watchPosts();

  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  });

  Future<void> cachePosts(List<Post> posts);

  Future<List<Post>> readCache();
}

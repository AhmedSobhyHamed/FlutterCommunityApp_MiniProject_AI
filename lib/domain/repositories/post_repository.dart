import 'package:fluttercommunityapp_miniproject_ai/domain/entities/post.dart';

/// Feed contract. The data layer chooses Firestore or the local cache.
abstract class PostRepository {
  Stream<List<Post>> watchPosts();

  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  });
}

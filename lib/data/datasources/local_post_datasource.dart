import 'package:fluttercommunityapp_miniproject_ai/data/datasources/post_datasource.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/models/post_model.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/post.dart';

/// In-memory copy of the last successful feed, used when Firestore is unreachable.
class LocalPostDataSource implements PostDataSource {
  List<Post> _posts = const [];

  @override
  Stream<List<Post>> watchPosts() async* {
    yield List<Post>.unmodifiable(_posts);
  }

  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    final post = PostModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: DateTime.now(),
    );
    _posts = [post, ..._posts];
  }

  @override
  Future<void> cachePosts(List<Post> posts) async {
    _posts = List<Post>.from(posts);
  }

  @override
  Future<List<Post>> readCache() async => List<Post>.unmodifiable(_posts);
}

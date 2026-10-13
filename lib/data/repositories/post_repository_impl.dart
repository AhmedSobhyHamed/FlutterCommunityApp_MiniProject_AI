import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/datasources/post_datasource_factory.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/datasources/post_datasource.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/post.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({required PostDataSourceFactory factory})
    : _remote = factory.create(PostSourceKind.remote),
      _local = factory.create(PostSourceKind.local);

  final PostDataSource _remote;
  final PostDataSource _local;

  @override
  Stream<List<Post>> watchPosts() async* {
    try {
      await for (final posts in _remote.watchPosts()) {
        await _local.cachePosts(posts);
        yield posts;
      }
    } catch (error) {
      final cached = await _local.readCache();
      if (cached.isNotEmpty) {
        yield cached;
        return;
      }
      throw Failure(friendlyError(error));
    }
  }

  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) {
    return _remote.createPost(
      authorId: authorId,
      authorName: authorName,
      content: content,
    );
  }
}

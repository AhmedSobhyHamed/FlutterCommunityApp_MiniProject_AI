import 'package:fluttercommunityapp_miniproject_ai/data/datasources/firestore_post_datasource.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/datasources/local_post_datasource.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/datasources/post_datasource.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/firestore_service.dart';

enum PostSourceKind { remote, local }

/// Factory — [PostRepositoryImpl] asks this class for a data source
/// instead of constructing Firestore or the cache itself.
class PostDataSourceFactory {
  PostDataSourceFactory(this._firestoreService);

  final FirestoreService _firestoreService;
  LocalPostDataSource? _local;

  PostDataSource create(PostSourceKind kind) {
    switch (kind) {
      case PostSourceKind.remote:
        return FirestorePostDataSource(_firestoreService);
      case PostSourceKind.local:
        return _local ??= LocalPostDataSource();
    }
  }
}

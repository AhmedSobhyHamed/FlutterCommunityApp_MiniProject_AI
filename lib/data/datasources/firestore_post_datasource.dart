import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/models/post_model.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/datasources/post_datasource.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/post.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/firestore_service.dart';

class FirestorePostDataSource implements PostDataSource {
  FirestorePostDataSource(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Stream<List<Post>> watchPosts() {
    return _firestoreService.posts
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => PostModel.fromJson(doc.id, doc.data()))
              .toList();
        });
  }

  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) {
    return _firestoreService.posts.add({
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> cachePosts(List<Post> posts) async {}

  @override
  Future<List<Post>> readCache() async => const [];
}

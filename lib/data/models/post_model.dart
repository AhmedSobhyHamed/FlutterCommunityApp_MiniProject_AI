import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.content,
    required super.createdAt,
  });

  factory PostModel.fromJson(String id, Map<String, dynamic> json) {
    return PostModel(
      id: id,
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: _readDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime _readDate(Object? raw) {
    if (raw is Timestamp) {
      return raw.toDate();
    }
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    return DateTime.now();
  }
}

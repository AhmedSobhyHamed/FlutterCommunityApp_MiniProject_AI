import 'package:equatable/equatable.dart';

/// One community post shown on the home feed.
class Post extends Equatable {
  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, authorId, authorName, content, createdAt];
}

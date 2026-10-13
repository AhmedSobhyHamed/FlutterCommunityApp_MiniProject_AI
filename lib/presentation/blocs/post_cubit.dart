import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/post.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/create_post.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/get_posts.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {
  const PostInitial();
}

class PostLoading extends PostState {
  const PostLoading();
}

class PostLoaded extends PostState {
  const PostLoaded(this.posts, {this.errorMessage});

  final List<Post> posts;
  final String? errorMessage;

  @override
  List<Object?> get props => [posts, errorMessage];
}

class PostError extends PostState {
  const PostError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class PostCubit extends Cubit<PostState> {
  PostCubit({required GetPosts getPosts, required CreatePost createPost})
    : _getPosts = getPosts,
      _createPost = createPost,
      super(const PostInitial());

  final GetPosts _getPosts;
  final CreatePost _createPost;
  StreamSubscription<List<Post>>? _subscription;

  void watch() {
    emit(const PostLoading());
    _subscription?.cancel();
    _subscription = _getPosts().listen(
      (posts) => emit(PostLoaded(posts)),
      onError: (Object error) => emit(PostError(friendlyError(error))),
    );
  }

  Future<bool> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    final result = await _createPost(
      authorId: authorId,
      authorName: authorName,
      content: content,
    );
    if (result case Err(:final failure)) {
      final current = state;
      if (current is PostLoaded) {
        emit(PostLoaded(current.posts, errorMessage: failure.message));
      } else {
        emit(PostError(failure.message));
      }
      return false;
    }
    return true;
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

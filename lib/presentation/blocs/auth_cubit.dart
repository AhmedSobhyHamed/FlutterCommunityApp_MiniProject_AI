import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/sign_in.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/sign_out.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/sign_up.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/watch_auth_state.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  const Authenticated(this.user);

  final AppUser user;

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthFailure extends AuthState {
  const AuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required SignIn signIn,
    required SignUp signUp,
    required SignOut signOut,
    required WatchAuthState watchAuthState,
  }) : _signIn = signIn,
       _signUp = signUp,
       _signOut = signOut,
       super(const AuthInitial()) {
    _subscription = watchAuthState().listen((user) {
      if (user != null) {
        final current = state;
        if (current is Authenticated &&
            current.user.id == user.id &&
            current.user.fullName.isNotEmpty &&
            user.fullName.isEmpty) {
          return;
        }
        emit(Authenticated(user));
        return;
      }
      if (state is! AuthLoading && state is! AuthFailure) {
        emit(const Unauthenticated());
      }
    }, onError: (Object error) => emit(AuthFailure(friendlyError(error))));
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  late final StreamSubscription<AppUser?> _subscription;

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await _signIn(email: email, password: password);
    _emitAuthResult(result);
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _signUp(
      fullName: fullName,
      email: email,
      password: password,
    );
    _emitAuthResult(result);
  }

  Future<void> signOut() async {
    final result = await _signOut();
    if (result case Err(:final failure)) {
      emit(AuthFailure(failure.message));
      return;
    }
    emit(const Unauthenticated());
  }

  void _emitAuthResult(Result<AppUser> result) {
    switch (result) {
      case Success(:final value):
        if (value != null) {
          emit(Authenticated(value));
        }
      case Err(:final failure):
        emit(AuthFailure(failure.message));
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}

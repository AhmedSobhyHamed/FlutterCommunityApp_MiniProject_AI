import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/auth_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/screens/home_screen.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/screens/login_screen.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/screens/splash_screen.dart';

/// Keeps the signed-in user on the home feed across app restarts.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => _phase(previous) != _phase(current),
      builder: (context, state) {
        return switch (_phase(state)) {
          _AuthPhase.splash => const SplashScreen(),
          _AuthPhase.session => Navigator(
            key: const ValueKey('session'),
            onGenerateRoute: (_) =>
                MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
          ),
          _AuthPhase.signedOut => Navigator(
            key: const ValueKey('signed-out'),
            onGenerateRoute: (_) =>
                MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
          ),
        };
      },
    );
  }

  _AuthPhase _phase(AuthState state) {
    if (state is AuthInitial) {
      return _AuthPhase.splash;
    }
    if (state is Authenticated) {
      return _AuthPhase.session;
    }
    return _AuthPhase.signedOut;
  }
}

enum _AuthPhase { splash, session, signedOut }

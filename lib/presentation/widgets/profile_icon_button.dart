import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/authenticate_biometric.dart';
import 'package:fluttercommunityapp_miniproject_ai/injection.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/auth_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/screens/profile_screen.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';

/// Opens the profile only after a successful fingerprint check.
class ProfileIconButton extends StatelessWidget {
  const ProfileIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Profile',
      onPressed: () => _openProfile(context),
      icon: const Icon(Icons.person_outline),
    );
  }

  Future<void> _openProfile(BuildContext context) async {
    final result = await getIt<AuthenticateBiometric>()();
    if (!context.mounted) {
      return;
    }
    switch (result) {
      case Err(:final failure):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      case Success():
        final authState = context.read<AuthCubit>().state;
        if (authState is! Authenticated) {
          return;
        }
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ProfileScreen(userId: authState.user.id),
          ),
        );
    }
  }
}

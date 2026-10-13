import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/themes/app_colors.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/responsive.dart';
import 'package:fluttercommunityapp_miniproject_ai/injection.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/auth_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/profile_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/donation_sheet.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..load(userId),
      child: _ProfileView(userId: userId),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({required this.userId});

  final String userId;

  Future<void> _pickPhoto(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
      );
      if (image == null || !context.mounted) {
        return;
      }
      await context.read<ProfileCubit>().updatePhoto(
        userId: userId,
        filePath: image.path,
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the gallery.')),
      );
    }
  }

  void _openDonation(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: DonationSheet(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = horizontalPadding(context);
    final avatarSize = (MediaQuery.sizeOf(context).width * 0.28).clamp(
      96.0,
      140.0,
    );

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) {
        return current is ProfileReady && current.message != null;
      },
      listener: (context, state) {
        if (state is ProfileReady && state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return switch (state) {
              ProfileLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              ProfileError(:final message) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () =>
                            context.read<ProfileCubit>().load(userId),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
              ProfileReady(
                :final user,
                :final device,
                :final isUpdatingPhoto,
              ) =>
                ListView(
                  padding: EdgeInsets.fromLTRB(padding, 24, padding, 24),
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: avatarSize / 2,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.15,
                            ),
                            backgroundImage: user.photoUrl == null
                                ? null
                                : NetworkImage(user.photoUrl!),
                            child: user.photoUrl == null
                                ? Text(
                                    user.fullName.isEmpty
                                        ? '?'
                                        : user.fullName[0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: avatarSize * 0.28,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : null,
                          ),
                          if (isUpdatingPhoto)
                            Positioned.fill(
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.fullName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: isUpdatingPhoto
                          ? null
                          : () => _pickPhoto(context),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Update profile photo'),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: AppColors.card,
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _InfoRow(label: 'Device', value: device.model),
                            const Divider(),
                            _InfoRow(label: 'OS', value: device.osVersion),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => _openDonation(context),
                      icon: const Icon(Icons.volunteer_activism_outlined),
                      label: const Text('Donate'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.read<AuthCubit>().signOut(),
                      child: const Text('Sign out'),
                    ),
                  ],
                ),
            };
          },
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

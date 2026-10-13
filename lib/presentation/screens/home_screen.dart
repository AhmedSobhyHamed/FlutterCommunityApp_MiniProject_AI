import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/themes/app_colors.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/responsive.dart';
import 'package:fluttercommunityapp_miniproject_ai/injection.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/auth_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/post_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/screens/map_screen.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/app_bottom_nav.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/create_post_sheet.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/post_card.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/profile_icon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PostCubit>()..watch(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  void _openComposer(BuildContext context) {
    final postCubit = context.read<PostCubit>();
    final authCubit = context.read<AuthCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: postCubit),
          BlocProvider.value(value: authCubit),
        ],
        child: const CreatePostSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostState>(
      listenWhen: (previous, current) {
        return current is PostLoaded && current.errorMessage != null;
      },
      listener: (context, state) {
        if (state is PostLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ConnectMe'),
          actions: const [ProfileIconButton()],
        ),
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            return switch (state) {
              PostInitial() ||
              PostLoading() => const Center(child: CircularProgressIndicator()),
              PostError(:final message) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding(context),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => context.read<PostCubit>().watch(),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
              PostLoaded(:final posts) =>
                posts.isEmpty
                    ? const Center(
                        child: Text(
                          'No posts yet. Be the first to share something.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding(context),
                          12,
                          horizontalPadding(context),
                          88,
                        ),
                        itemCount: posts.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            PostCard(post: posts[index]),
                      ),
            };
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openComposer(context),
          tooltip: 'Create post',
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: AppBottomNav(
          index: 0,
          onSelected: (index) {
            if (index == 1) {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const MapScreen()),
              );
            }
          },
        ),
      ),
    );
  }
}

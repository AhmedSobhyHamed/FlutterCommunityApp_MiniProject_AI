import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/responsive.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/validators.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/auth_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/post_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/primary_button.dart';

class CreatePostSheet extends StatefulWidget {
  const CreatePostSheet({super.key});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  var _isSaving = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final authState = context.read<AuthCubit>().state;
    if (authState is! Authenticated) {
      return;
    }
    setState(() => _isSaving = true);
    final saved = await context.read<PostCubit>().createPost(
      authorId: authState.user.id,
      authorName: authState.user.fullName,
      content: _contentController.text,
    );
    if (!mounted) {
      return;
    }
    setState(() => _isSaving = false);
    if (saved) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding(context),
        16,
        horizontalPadding(context),
        bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New post',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contentController,
              minLines: 3,
              maxLines: 6,
              validator: validatePostContent,
              decoration: const InputDecoration(
                labelText: 'What is happening?',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Post',
              isLoading: _isSaving,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

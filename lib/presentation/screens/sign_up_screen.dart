import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/themes/app_colors.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/responsive.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/validators.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/auth_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/auth_text_field.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    context.read<AuthCubit>().signUp(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final errorMessage = state is AuthFailure ? state.message : null;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding(context),
              12,
              horizontalPadding(context),
              24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Join ConnectMe',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Use your name, email, and a password of at least 6 characters.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  AuthTextField(
                    controller: _nameController,
                    label: 'Full name',
                    icon: Icons.badge_outlined,
                    textInputAction: TextInputAction.next,
                    validator: validateFullName,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 14),
                  AuthTextField(
                    controller: _confirmController,
                    label: 'Confirm password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) => validateConfirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      errorMessage,
                      style: const TextStyle(color: AppColors.accent),
                    ),
                  ],
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Sign up',
                    isLoading: isLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

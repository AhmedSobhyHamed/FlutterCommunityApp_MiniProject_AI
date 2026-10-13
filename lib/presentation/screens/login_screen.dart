import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/themes/app_colors.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/responsive.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/validators.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/blocs/auth_cubit.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/screens/sign_up_screen.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/auth_text_field.dart';
import 'package:fluttercommunityapp_miniproject_ai/presentation/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    context.read<AuthCubit>().signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.sizeOf(context).height * 0.28;

    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final errorMessage = state is AuthFailure ? state.message : null;

          return Column(
            children: [
              Container(
                height: headerHeight.clamp(180, 280),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.groups_rounded,
                        color: Colors.white,
                        size: 56,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ConnectMe',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding(context),
                    28,
                    horizontalPadding(context),
                    24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Sign in to see the community feed.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 24),
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
                          textInputAction: TextInputAction.done,
                          validator: validatePassword,
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
                          label: 'Log in',
                          isLoading: isLoading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) => const SignUpScreen(),
                                      ),
                                    );
                                  },
                            child: const Text('New here? Create an account'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

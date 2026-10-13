import 'package:flutter/material.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/themes/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).shortestSide * 0.22;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_rounded,
              size: size.clamp(72, 120),
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'ConnectMe',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

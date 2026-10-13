import 'package:flutter/material.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/themes/app_colors.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/post.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final avatarSize = (width * 0.12).clamp(40.0, 56.0);
    final timestamp = DateFormat(
      'MMM d, y • h:mm a',
    ).format(post.createdAt.toLocal());

    return Card(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all((width * 0.04).clamp(12.0, 20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: avatarSize / 2,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(
                    _initial(post.authorName),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timestamp,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.content,
              style: const TextStyle(
                color: AppColors.textPrimary,
                height: 1.4,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initial(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed[0].toUpperCase();
  }
}

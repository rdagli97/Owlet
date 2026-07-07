import 'package:flutter/material.dart';
import 'package:owlet/core/constants/app_sizes.dart';
import 'package:owlet/core/theme/app_colors.dart';
import 'package:owlet/core/theme/app_text_styles.dart';
import 'package:owlet/models/hoot.dart';

class HootCard extends StatelessWidget {
  final Hoot hoot;
  final String currentUserId;
  final VoidCallback onLike;
  final VoidCallback onRetweet;
  final VoidCallback onReply;

  const HootCard({
    super.key,
    required this.hoot,
    required this.currentUserId,
    required this.onLike,
    required this.onRetweet,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = hoot.isLikedBy(currentUserId);
    final isRetweeted = hoot.isRetweetedBy(currentUserId);
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          _Avatar(email: hoot.authorEmail),
          const SizedBox(width: AppSizes.md),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username + time
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _userNameFromEmail(hoot.authorEmail),
                        style: AppTextStyles.username,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Text(
                      _formatTime(hoot.createdAt),
                      style: AppTextStyles.handle,
                    ),
                  ],
                ),
                const SizedBox(width: AppSizes.xs),
                // Hoot text
                Text(hoot.text, style: AppTextStyles.body),
                const SizedBox(width: AppSizes.sm),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ActionButton(
                      icon: Icons.chat_bubble_outline,
                      count: hoot.replyCount,
                      onTap: onReply,
                    ),
                    _ActionButton(
                      icon: Icons.repeat,
                      count: hoot.retweetCount,
                      color: isRetweeted ? AppColors.retweet : null,
                      onTap: onRetweet,
                    ),
                    _ActionButton(
                      icon: isLiked? Icons.favorite : Icons.favorite_border,
                      count: hoot.likeCount,
                      color: isLiked ? AppColors.like : null,
                      onTap: onLike,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _userNameFromEmail(String email) {
  return email.split('@').first;
}

String _formatTime(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'now';
  if (diff.inHours < 1) return '${diff.inMinutes}m';
  if (diff.inDays < 1) return '${diff.inHours}h';
  return '${diff.inDays}d';
}

class _Avatar extends StatelessWidget {
  final String email;
  const _Avatar({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.avatarMd,
      height: AppSizes.avatarMd,
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        email.isNotEmpty ? email[0].toUpperCase() : '?',
        style: AppTextStyles.title.copyWith(color: AppColors.primary),
      ),
    );
  }
}

// Like/Retweet/Comment buttons (icon + count)
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.count,
    required this.onTap,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xs),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppSizes.iconSm,
              color: color ?? AppColors.textSecondary,
            ),
            if (count > 0) ... [
              const SizedBox(width: AppSizes.xs),
              Text(
                '$count',
                style: AppTextStyles.caption.copyWith(
                  color: color ?? AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
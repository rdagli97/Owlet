import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owlet/core/constants/app_sizes.dart';
import 'package:owlet/core/constants/app_strings.dart';
import 'package:owlet/core/theme/app_colors.dart';
import 'package:owlet/core/theme/app_text_styles.dart';
import 'package:owlet/providers/auth_provider.dart';
import 'package:owlet/providers/hoot_provider.dart';
import 'package:owlet/screens/hoot_details_screen.dart';
import 'package:owlet/widgets/hoot_card.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;
  final String userEmail;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authServiceProvider).currentUser?.uid ?? '';
    final hootsAsync = ref.watch(userHootsStreamProvider(userId));

    return Scaffold(
      appBar: AppBar(title: Text(_username(userEmail))),
      body: Column(
        children: [
          _ProfileHeader(
            email: userEmail,
            hootCount: hootsAsync.value?.length ?? 0,
          ),
          const Divider(height: 1, color: AppColors.divider),
          Expanded(
            child: hootsAsync.when(
              data: (hoots) {
                if (hoots.isEmpty) {
                  return Center(
                    child: Text(
                      AppStrings.noHootsYet,
                      style: AppTextStyles.caption,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: hoots.length,
                  itemBuilder: (context, index) {
                    final hoot = hoots[index];
                    return HootCard(
                      hoot: hoot,
                      currentUserId: currentUserId,
                      onLike: () => ref
                          .read(hootActionsProvider)
                          .toggleLike(hoot.id, hoot.isLikedBy(currentUserId)),
                      onRetweet: () => ref
                          .read(hootActionsProvider)
                          .toggleRetweet(
                              hoot.id, hoot.isRetweetedBy(currentUserId)),
                      onReply: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HootDetailsScreen(hoot: hoot),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (err, _) => Center(
                child: Text('${AppStrings.somethingWentWrong}: $err'),
              )
            ),
          ),
        ],
      ),
    );
  }
  String _username(String email) => email.split('@').first;
}

class _ProfileHeader extends StatelessWidget {
  final String email;
  final int hootCount;

  const _ProfileHeader({required this.email, required this.hootCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: AppSizes.avatarLg,
            height: AppSizes.avatarLg,
            decoration: const BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              email.isNotEmpty ? email[0].toUpperCase() : '?',
              style: AppTextStyles.heading.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(email.split('@').first, style: AppTextStyles.heading),
          Text('@${email.split('@').first}', style: AppTextStyles.handle),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Text('$hootCount', style: AppTextStyles.username),
              const SizedBox(width: AppSizes.xs),
              Text(AppStrings.hoots, style: AppTextStyles.handle),
            ],
          ),
        ],
      ),
    );
  }
}
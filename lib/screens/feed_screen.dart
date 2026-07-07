import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owlet/core/constants/app_strings.dart';
import 'package:owlet/core/theme/app_colors.dart';
import 'package:owlet/core/theme/app_text_styles.dart';
import 'package:owlet/providers/auth_provider.dart';
import 'package:owlet/providers/hoot_provider.dart';
import 'package:owlet/screens/compose_hoot_screen.dart';
import 'package:owlet/widgets/hoot_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hootsAsync = ref.watch(hootsStreamProvider);
    final currentUser = ref.watch(authServiceProvider).currentUser;
    final currentUserId = currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: hootsAsync.when(
        data: (hoots) {
          if (hoots.isEmpty) {
            return Center(
              child: Text(AppStrings.noHootsYet, style: AppTextStyles.caption),
            );
          }
          return ListView.builder(
            itemCount: hoots.length,
            itemBuilder: (context, index) {
              final hoot = hoots[index];
              return HootCard(
                hoot: hoot,
                currentUserId: currentUserId,
                onLike: () {
                  //
                },
                onRetweet: () {
                  //
                },
                onReply: () {
                  //
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(child: Text('${AppStrings.somethingWentWrong}: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ComposeHootScreen()),
        ),
        child: const Icon(Icons.add, color: AppColors.background),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owlet/core/constants/app_sizes.dart';
import 'package:owlet/core/constants/app_strings.dart';
import 'package:owlet/core/theme/app_colors.dart';
import 'package:owlet/core/theme/app_text_styles.dart';
import 'package:owlet/models/hoot.dart';
import 'package:owlet/providers/auth_provider.dart';
import 'package:owlet/providers/hoot_provider.dart';
import 'package:owlet/widgets/hoot_card.dart';
import 'package:owlet/widgets/owlet_text_field.dart';

class HootDetailsScreen extends ConsumerStatefulWidget {
  final Hoot hoot;
  const HootDetailsScreen({super.key, required this.hoot});

  @override
  ConsumerState<HootDetailsScreen> createState() => _HootDetailScreenState();
}

class _HootDetailScreenState extends ConsumerState<HootDetailsScreen> {
  final TextEditingController _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _sendReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    final success = await ref
        .read(replyComposerProvider)
        .postReply(widget.hoot.id, text);
    if (success) {
      _replyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(authServiceProvider).currentUser?.uid ?? '';
    final repliesAsync = ref.watch(repliesStreamProvider(widget.hoot.id));

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.hoot)),
      body: Column(
        children: [
          // Hoot + replies
          Expanded(
            child: ListView(
              children: [
                HootCard(
                  hoot: widget.hoot,
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
                ),
                // Replies Title
                Padding(
                  padding: EdgeInsets.all(AppSizes.md),
                  child: Text(AppStrings.replies, style: AppTextStyles.caption),
                ),
                // List of Reply
                repliesAsync.when(
                  data: (replies) => Column(
                    children: replies
                        .map(
                          (reply) => HootCard(
                            hoot: reply,
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
                          ),
                        )
                        .toList(),
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSizes.lg),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: Text('${AppStrings.somethingWentWrong}: $err'),
                  ),
                ),
              ],
            ),
          ),
          // Write reply
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OwletTextField(
                    controller: _replyController,
                    hint: AppStrings.tweetYourReply,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: _sendReply,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

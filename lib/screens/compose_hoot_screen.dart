import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owlet/core/constants/app_sizes.dart';
import 'package:owlet/core/constants/app_strings.dart';
import 'package:owlet/providers/hoot_provider.dart';
import 'package:owlet/widgets/owlet_button.dart';
import 'package:owlet/widgets/owlet_text_field.dart';

class ComposeHootScreen extends ConsumerStatefulWidget {
  const ComposeHootScreen({super.key});

  @override
  ConsumerState<ComposeHootScreen> createState() => _ComposeHootScreenState();
}

class _ComposeHootScreenState extends ConsumerState<ComposeHootScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final success = await ref
        .read(hootComposerProvider.notifier)
        .postHoot(text);

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hootComposerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.hoot)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OwletTextField(
              controller: _controller,
              hint: AppStrings.whatsOnYourMind,
            ),
            const SizedBox(height: AppSizes.md),
            OwletButton(
              label: AppStrings.hoot,
              isLoading: state.isSubmitting,
              onPressed: _post,
            ),
          ],
        ),
      ),
    );
  }
}

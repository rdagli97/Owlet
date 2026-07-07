import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owlet/core/constants/app_strings.dart';
import 'package:owlet/models/hoot.dart';
import 'package:owlet/providers/auth_provider.dart';
import 'package:owlet/services/hoot_service.dart';

final hootServiceProvider = Provider<HootService>((ref) {
  return HootService();
});

// Provider that provides all hoots in real time (source of the feed)
final hootsStreamProvider = StreamProvider<List<Hoot>>((ref) {
  return ref.watch(hootServiceProvider).watchHoots();
});

// Status of the hooting operation
class HootComposerState {
  final bool isSubmitting;
  final String? errorMessage;

  const HootComposerState({this.isSubmitting = false, this.errorMessage});

  HootComposerState copyWith({bool? isSubmitting, String? errorMessage}) {
    return HootComposerState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class HootComposer extends Notifier<HootComposerState> {
  @override
  HootComposerState build() => const HootComposerState();

  Future<bool> postHoot(String text) async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);
    try {
      final hoot = Hoot(
        id: '',
        text: text,
        authorId: user.uid,
        authorEmail: user.email ?? 'unknown',
        createdAt: DateTime.now(),
      );
      await ref.read(hootServiceProvider).createHoot(hoot);
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: AppStrings.failedToPost);
      return false;
    }
  }
}

final hootComposerProvider = 
    NotifierProvider<HootComposer, HootComposerState>(HootComposer.new);

class HootActions {
  final Ref ref;
  HootActions(this.ref);

  Future<void> toggleLike(String hootId, bool isCurrentlyLiked) async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return;

    await ref.read(hootServiceProvider).toggleLike(hootId, user.uid, isCurrentlyLiked);
  }

  Future<void> toggleRetweet(String hootId, bool isCurrentlyRetweeted) async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user == null) return;

    await ref.read(hootServiceProvider).toggleRetweet(hootId, user.uid, isCurrentlyRetweeted);
  }
}

final hootActionsProvider = Provider<HootActions>((ref) {
  return HootActions(ref);
},);

import 'package:cloud_firestore/cloud_firestore.dart';

class Hoot {
  final String id;
  final String text;
  final String authorId;
  final String authorEmail;
  final DateTime createdAt;
  final List<String> likedBy;
  final List<String> retweetedBy;
  final int replyCount;

  const Hoot({
    required this.id,
    required this.text,
    required this.authorId,
    required this.authorEmail,
    required this.createdAt,
    this.likedBy = const [],
    this.retweetedBy = const [],
    this.replyCount = 0,
  });

  // Derived values ​​(getters) — they are calculated, not stored.
  int get likeCount => likedBy.length;
  int get retweetCount => retweetedBy.length;

  bool isLikedBy(String userId) => likedBy.contains(userId);
  bool isRetweetedBy(String userId) => retweetedBy.contains(userId);

  Map<String, dynamic> toMap() {
    return {
      'text' : text,
      'authorId' : authorId,
      'authorEmail' : authorEmail,
      'createdAt' : Timestamp.fromDate(createdAt),
      'likedBy' : likedBy,
      'retweetedBy' : retweetedBy,
      'replyCount' : replyCount,
    };
  }

  factory Hoot.fromMap(String id, Map<String, dynamic> map) {
    return Hoot(
      id: id, 
      text: map['text'] ?? '', 
      authorId: map['authorId'] ?? '', 
      authorEmail: map['authorEmail'] ?? '', 
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likedBy: List<String>.from(map['likedBy'] ?? []),
      retweetedBy: List<String>.from(map['retweetedBy'] ?? []),
      replyCount: map['replyCount'] ?? 0,
    );
  }
}
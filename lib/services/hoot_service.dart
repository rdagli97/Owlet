import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owlet/models/hoot.dart';

class HootService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ref collection of 'hoots'
  CollectionReference<Map<String, dynamic>> get _hoots =>
      _firestore.collection('hoots');

  // create new hoot
  Future<void> createHoot(Hoot hoot) async {
    await _hoots.add(hoot.toMap());
  }

  // watch live hoots
  Stream<List<Hoot>> watchHoots() {
    return _hoots
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Hoot.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  // Like/unlike toggle
  Future<void> toggleLike(String hootId, String userId, bool isCurrentlyLiked) async {
    final docRef = _hoots.doc(hootId);
    if (isCurrentlyLiked) {
      await docRef.update({
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      await docRef.update({
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  // retweet add/remove toggle
  Future<void> toggleRetweet(String hootId, String userId, bool isCurrentlyRetweeted) async {
    final docRef = _hoots.doc(hootId);

    if (isCurrentlyRetweeted) {
      await docRef.update({
        'retweetedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      await docRef.update({
        'retweetedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  /// *********************************** REPLY SECTION ******************************************

  // ref of hoot->replies subcollection
  CollectionReference<Map<String, dynamic>> _replies(String hootId) =>
    _hoots.doc(hootId).collection('replies');

  // add a reply to a hoot
  Future<void> addReply(String hootId, Hoot reply) async {
    // add reply to subcollection
    await _replies(hootId).add(reply.toMap());
    // increase hoot reply count
    await _hoots.doc(hootId).update({
      'replyCount': FieldValue.increment(1), // yine length almak daha mantikli olmaz miydi?
    });
  }

  // watch replies live
  Stream<List<Hoot>> watchReplies(String hootId) {
    return _replies(hootId)
        .orderBy('createdAt',descending: false)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => Hoot.fromMap(doc.id, doc.data()))
            .toList());
  }



}



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
}

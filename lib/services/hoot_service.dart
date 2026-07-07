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
}

  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, dynamic>?> getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final QuerySnapshot cardsSnapshot = await FirebaseFirestore.instance
        .collection('cards')
        .where('userID', isEqualTo: user.uid)
        .get();

    final List<Map<String, dynamic>> cards = cardsSnapshot.docs
        .map((doc) {print(doc.id); return doc.data() as Map<String, dynamic>;})
        .toList();

    return {'userData': userDoc.data(), 'cards': cards};
  }
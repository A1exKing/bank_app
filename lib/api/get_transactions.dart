import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_bank/controllers/user_controller.dart';
import 'package:my_bank/models/transactions.dart';

Stream<List<Transactions>> getTransactionsStream() {
 String userId = Get.find<UserController>().userId;
  return FirebaseFirestore.instance
      .collection('transactions')
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Transactions.fromMap(doc.data()))
          .where((transaction) =>
              transaction.fromUserId == userId ||
              transaction.toUserId == userId)
          .toList());
}



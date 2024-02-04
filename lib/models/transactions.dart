import 'package:cloud_firestore/cloud_firestore.dart';

class Transactions {

  num amount;
  String fromUserId;
  String toUserId;
  String toUserName;
  String fromUserName;
  String fromCardId;
  String toCardId;
  String description;
  DateTime date;
 
  Transactions({ required this.amount, required this.fromUserId, required this.toUserId, required this.description, required this.fromCardId, required this.toUserName,  required this.fromUserName, required this.toCardId, required this.date});

  // Визначає, чи це вхідна транзакція для даного користувача
  bool isIncoming(String userId) {
    return toUserId == userId;
  }

  // Визначає, чи це вихідна транзакція для даного користувача
  bool isOutgoing(String userId) {
    return fromUserId == userId;
  }
   factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      toUserName: map['toUserName'],
      fromUserName: map['fromUserName'],
      fromCardId: map['fromCardId'],
      toCardId: map['toCardId'],
      amount: map['amount'],
      description: map['description'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}

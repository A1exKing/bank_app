// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_bank/pages/history/details_page.dart';
import 'package:my_bank/pages/history/history_page.dart';
import 'package:my_bank/pages/home_page.dart/home_page.dart';
import 'package:intl/intl.dart';

// class TransactionItem {
//   final String icon;
//   final String title;
//   final String data;
//   final double sum;
//   TransactionItem({
//     required this.icon,
//     required this.title,
//     required this.data,
//     required this.sum,
//   });

//   TransactionItem copyWith({
//     String? icon,
//     String? title,
//     String? data,
//     double? sum,
//   }) {
//     return TransactionItem(
//       icon: icon ?? this.icon,
//       title: title ?? this.title,
//       data: data ?? this.data,
//       sum: sum ?? this.sum,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'icon': icon,
//       'title': title,
//       'data': data,
//       'sum': sum,
//     };
//   }

//   factory TransactionItem.fromMap(Map<String, dynamic> map) {
//     return TransactionItem(
//       icon: map['icon'] as String,
//       title: map['title'] as String,
//       data: map['data'] as String,
//       sum: map['sum'] as double,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory TransactionItem.fromJson(String source) => TransactionItem.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'TransactionItem(icon: $icon, title: $title, data: $data, sum: $sum)';
//   }

//   @override
//   bool operator ==(covariant TransactionItem other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.icon == icon &&
//       other.title == title &&
//       other.data == data &&
//       other.sum == sum;
//   }

//   @override
//   int get hashCode {
//     return icon.hashCode ^
//       title.hashCode ^
//       data.hashCode ^
//       sum.hashCode;
//   }
// }
class Transactions {

  double amount;
  String fromUserId;
  String toUserId;
  String toUserName;
  String fromUserName;
  String fromCardId;
  String toCardId;
  String description;
  DateTime date;
  // Інші поля...

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

 Stream<List<Transactions>> getTransactionsStream(userId) {
 // print(userId);
  return FirebaseFirestore.instance
      .collection('transactions')
      
      .orderBy('date', descending: true)
      .snapshots()
      .map((snapshot) => 
    snapshot.docs
      .map((doc) => Transactions.fromMap(doc.data()))
      .where((transaction) =>  transaction.fromUserId == userId || transaction.toUserId == userId)
      .toList()
  );
}
//Віджет де відображено список останніх транзакцій
class LastTransactionWidget extends StatefulWidget {
 

  LastTransactionWidget(this.userId, {super.key});
late String userId;
  @override
  State<LastTransactionWidget> createState() => _LastTransactionWidgetState();
}

class _LastTransactionWidgetState extends State<LastTransactionWidget> {
  
  // List lastTransaction = [
  //   TransactionItem(icon : "", title : "Restaurant", data: "June 10, 21:32", sum: -122.00),
  //   TransactionItem(icon : "", title : "Restaurant", data: "June 10, 21:32", sum: -140.00),
  //   TransactionItem(icon : "", title : "Restaurant", data: "June 10, 21:32", sum:  200.00),
  // ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,//розтягуэ елементи по краях
            crossAxisAlignment: CrossAxisAlignment.end,//прижимає до нижнього краю
            children: [
              Text("Last Transaction", style: TextStyle(color: Color(0xff242424), fontWeight: FontWeight.w500, fontSize: 16),),
              GestureDetector(
                onTap: (){},
                child: Text("See All >", style: TextStyle(color: Color(0xff242424), fontSize: 14, fontWeight: FontWeight.w400),),
              )
            ],
          ),
StreamBuilder<List<Transactions>>(
  stream: getTransactionsStream(widget.userId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    if (snapshot.hasData) {
      print(snapshot.data);
      if(snapshot.data!.isNotEmpty){
        print(widget.userId);
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(color: Color(0xfffF1F1F1),),
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.only(top: 12),
            shrinkWrap: true,
            itemBuilder: (context, index) {
             
              Transactions transaction = snapshot.data![index];
            DateFormat outputFormat = DateFormat("MMMM dd, yyyy HH:mm:ss");
String formattedDate = outputFormat.format(transaction.date);
              //final TransactionItem item = lastTransaction[index];
              return  InkWell(
              onTap: () {
                 String userName = getUserName(transaction, widget.userId);
                 print("USER NAME TO $userName");
                Navigator.push(context, MaterialPageRoute(builder:(context) => DetailsTransaction(transaction,userName, transaction.isIncoming(getCurrentUserUid())? "Sender" : "Recipient"),));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: transaction.isIncoming(widget.userId) ?Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                        child: transaction.isIncoming(widget.userId) ?  Icon(Icons.arrow_downward, color: Colors.green,) : Icon(Icons.arrow_upward, color: Colors.redAccent,),
                      ),
                      SizedBox(width: 12,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transaction.isIncoming(widget.userId)? "From: ${transaction.fromCardId}" : "To: ${transaction.toCardId}",  style: TextStyle(color: Color(0xff242424), fontSize: 14, fontWeight: FontWeight.w500),),
                          Text(formattedDate.toString(), style: TextStyle(color: Color(0xff747474), fontSize: 12, fontWeight: FontWeight.w400),)
                        ],
                      ),
                      Spacer(),//Займає вільний простір
                      Text(transaction.isIncoming(widget.userId) ? "\$${ transaction.amount.toStringAsFixed(2)}" : "- \$${ transaction.amount.toStringAsFixed(2)}", style: TextStyle(color: Color(0xff242424), fontSize: 18, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
              );
            },
          
      );}else{
return Text('There are no transactions');
      }

    }
return Text('There are no transactions');
    
  },
)
/**
 * ListView.separated(
            
 */






          
        ],
      ),
    );
  }
}
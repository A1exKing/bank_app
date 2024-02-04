import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/models/transactions.dart';
import 'package:my_bank/pages/history/details_page.dart';
import 'package:my_bank/pages/history/history_page.dart';
import 'package:intl/intl.dart';
import 'package:my_bank/pages/login/sign_in_page.dart';






Stream<List<Transactions>> getTransactionsStream(userId) {
  // print(userId);
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



class LastTransactionWidget extends StatefulWidget {
  final String userId;

  const LastTransactionWidget(this.userId, {Key? key}) : super(key: key);

  @override
  State<LastTransactionWidget> createState() => _LastTransactionWidgetState();
}

class _LastTransactionWidgetState extends State<LastTransactionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min  ,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildTransactionList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Last Transaction",
          style: TextStyle(
              color: Color(0xff242424),
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder:(context) => HistoryPage(),));
          },
          child: const Text(
            "See All >",
            style: TextStyle(
                color: Color(0xff242424),
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return StreamBuilder<List<Transactions>>(
      stream: getTransactionsStream(widget.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return TransactionsListWidget(transactions: snapshot.data!,);
        } else {
          return const Text('There are no transactions');
        }
      },
    );
  }


}

class TransactionsListWidget extends StatelessWidget {
   TransactionsListWidget({
    super.key,
    required this.transactions,
   
  });

  final List<Transactions>  transactions;
   String userId = Get.find<UserController>().userId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            const Divider(color: Color(0xffF1F1F1)),
        itemCount: transactions.length,
        //padding: const EdgeInsets.only(top: 2),
        shrinkWrap: true,
         physics:   const NeverScrollableScrollPhysics(), // Вимкнення прокрутки у вкладеному списку
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final formattedDate =
              DateFormat("MMMM dd, yyyy HH:mm:ss").format(transaction.date);
          return ListTile(
      
            contentPadding: EdgeInsets.all(0),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailsTransaction(
                        transaction,
                        transaction.isIncoming(userId)
                            ? "Sender"
                            :  "Recipient"))),
            leading: CircleAvatar(
              backgroundColor: transaction.isIncoming(userId)
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              child: Icon(
                  transaction.isIncoming(userId)
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color: transaction.isIncoming(userId)
                      ? Colors.green
                      : Colors.redAccent),
            ),
            title: Text(
                transaction.isIncoming(userId)
                    ? "From: ${transaction.fromCardId}"
                    : "To: ${transaction.toCardId}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            subtitle: Text(formattedDate,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
            trailing: Text(
                transaction.isIncoming(userId)
                    ? "+ \$${transaction.amount.toStringAsFixed(2)}"
                    : "- \$${transaction.amount.toStringAsFixed(2)}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          );
        },
      ),
    );
  }
}

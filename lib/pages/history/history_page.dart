
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_bank/models/transactions.dart';
import 'package:my_bank/pages/history/details_page.dart';
import 'package:my_bank/pages/home.dart/last_transaction.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final String userId = getCurrentUserUid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.chevron_left, color: Colors.black),
        ),
        title: Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TransactionListWidget(userId: userId),
      ),
    );
  }

  static String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.uid : '';
  }
}

class TransactionListWidget extends StatelessWidget {
  final String userId;

  TransactionListWidget({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Transactions>>(
      stream: getTransactionsStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Text("No data available");
        }

        final transactions = snapshot.data!;
        Map<DateTime, List<Transactions>> groupedTransactions = {};

        for (var transaction in transactions) {
          DateTime dateWithoutTime = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
          groupedTransactions.putIfAbsent(dateWithoutTime, () => []).add(transaction);
        }

        List<DateTime> sortedDates = groupedTransactions.keys.toList();
        sortedDates.sort((a, b) => b.compareTo(a));

        return sortedDates.isNotEmpty ? ListView.builder(
          shrinkWrap: true,
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            DateTime date = sortedDates[index];
            List<Transactions> dailyTransactions = groupedTransactions[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Text(
                    DateFormat('dd MMMM yyyy').format(date),
                    style: TextStyle(color: Color(0xff242424), fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: dailyTransactions.map((transaction) => TransactionItem(transaction: transaction, userId: userId)).toList(),
                ),
              ],
            );
          },
        ) : Text("There are no transactions");
      },
    );
  }
}





class TransactionItem extends StatelessWidget {
  final Transactions transaction;
  final String userId;

  const TransactionItem({Key? key, required this.transaction, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = getUserName(transaction, userId);
    String formattedDate = DateFormat('HH:mm').format(transaction.date);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsTransaction(transaction,  transaction.isIncoming(userId)
                          ? "Sender"
                          : "Recipient"),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: transaction.isIncoming(userId) ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
              child: Icon(
                transaction.isIncoming(userId) ? Icons.arrow_downward : Icons.arrow_upward,
                color: transaction.isIncoming(userId) ? Colors.green : Colors.redAccent,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.isIncoming(userId) ? "From: ${transaction.fromCardId}" : "To: ${transaction.toCardId}",
                  style: TextStyle(color: Color(0xff242424), fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(color: Color(0xff747474), fontSize: 12, fontWeight: FontWeight.w400),
                )
              ],
            ),
            Spacer(),
            Text(
              transaction.isIncoming(userId) ? "+\$${transaction.amount.toStringAsFixed(2)}" : "-\$${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(color: Color(0xff242424), fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  String getUserName(Transactions transaction, String userId) {
    return transaction.isIncoming(userId) ? transaction.fromUserName : transaction.toUserName;
  }
}

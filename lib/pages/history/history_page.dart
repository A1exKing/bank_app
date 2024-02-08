
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_bank/api/get_transactions.dart';
import 'package:my_bank/controllers/user_controller.dart';
import 'package:my_bank/models/transactions.dart';
import 'package:my_bank/pages/history/details_page.dart';
import 'package:my_bank/pages/home.dart/last_transaction.dart';


class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

 
  String userId = Get.find<UserController>().userId;
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
        child: TransactionListWidget(),
      ),
    );
  }

 
}

class TransactionListWidget extends StatelessWidget {// Виводить список транзакці

  TransactionListWidget({Key? key}) : super(key: key);
  String userId = Get.find<UserController>().userId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Transactions>>(
      stream: getTransactionsStream(),
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
                  children: dailyTransactions.map((transaction) { 
                     String formattedDate = DateFormat('HH:mm').format(transaction.date);
 return transaction.type == "mobile"
              ? MobileTransactionItem(
                  transaction: transaction,
                  userId: userId,
                  formattedDate: formattedDate)
              : TransactionItem(
                  transaction: transaction,
                  userId: userId, formattedDate: formattedDate,
                  );
                   // return TransactionItem(transaction: transaction, userId: userId);
                    
                    }).toList(),
                ),
              ],
            );
          },
        ) : Text("There are no transactions");
      },
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/pages/history/history_page.dart';
import 'package:my_bank/pages/login/sign_in_page.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Statistic",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            FutureBuilder<dynamic>(
              future: calculateIncomeAndExpenses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Column(
                  children: [
                    ListTile(
                      title: Text('Total Income'),
                      subtitle: Text(
                          snapshot.data["totalIncome"].toString() ?? '0.00'),
                    ),
                    ListTile(
                      title: Text('Total Expenses'),
                      subtitle: Text(
                          snapshot.data["totalExpenses"].toString() ?? '0.00'),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> calculateIncomeAndExpenses() async {
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  String userId = Get.find<UserController>().userId;

  // Отримання транзакцій де користувач є отримувачем
  QuerySnapshot incomingTransactions = await FirebaseFirestore.instance
      .collection('transactions')
      .where('toUserId', isEqualTo: userId)
      .get();

  for (var doc in incomingTransactions.docs) {
    totalIncome += doc['amount'];
  }

  // Отримання транзакцій де користувач є відправником
  QuerySnapshot outgoingTransactions = await FirebaseFirestore.instance
      .collection('transactions')
      .where('fromUserId', isEqualTo: userId)
      .get();

  for (var doc in outgoingTransactions.docs) {
    totalExpenses += doc['amount'];
  }

  return {"totalIncome": totalIncome, "totalExpenses": totalExpenses};
}

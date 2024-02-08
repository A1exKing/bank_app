import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/api/get_transactions.dart';
import 'package:my_bank/controllers/user_controller.dart';
import 'package:my_bank/models/transactions.dart';
import 'package:my_bank/pages/history/details_mob_transaction.dart';
import 'package:my_bank/pages/history/details_page.dart';
import 'package:my_bank/pages/history/history_page.dart';
import 'package:intl/intl.dart';

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
        mainAxisSize: MainAxisSize.min,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(),
                ));
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
      stream: getTransactionsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return TransactionsListWidget(
            transactions: snapshot.data!,
          );
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

  final List<Transactions> transactions;
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
        physics:
            const NeverScrollableScrollPhysics(), // Вимкнення прокрутки у вкладеному списку
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final formattedDate =
              DateFormat("MMMM dd, yyyy HH:mm:ss").format(transaction.date);
          return transaction.type == "mobile"
              ? MobileTransactionItem(
                  transaction: transaction,
                  userId: userId,
                  formattedDate: formattedDate)
              : TransactionItem(
                  transaction: transaction,
                  userId: userId,
                  formattedDate: formattedDate);
        },
      ),
    );
  }
}

class MobileTransactionItem extends StatelessWidget {
  const MobileTransactionItem({
    super.key,
    required this.transaction,
    required this.userId,
    required this.formattedDate,
  });

  final Transactions transaction;
  final String userId;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsMobTransaction(transaction))),
      leading: CircleAvatar(
          backgroundColor: Color(0xfff3e6ff),
          child: Icon(
            Icons.phone_android,
            color: Colors.purpleAccent,
          )),
      title: Text("To: ${transaction.mobileNumber}",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(formattedDate,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
      trailing: Text("- \$${transaction.amount.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
    );
  }
}

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.userId,
    required this.formattedDate,
  });

  final Transactions transaction;
  final String userId;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsTransaction(transaction,
                  transaction.isIncoming(userId) ? "Sender" : "Recipient"))),
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(formattedDate,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
      trailing: Text(
          transaction.isIncoming(userId)
              ? "+ \$${transaction.amount.toStringAsFixed(2)}"
              : "- \$${transaction.amount.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/api/get_transactions.dart';
import 'package:my_bank/controllers/user_controller.dart';
import 'package:my_bank/models/bank_card.dart';
import 'package:my_bank/models/transactions.dart';
import 'package:my_bank/pages/pay/pay_page.dart';

class TransferTemplate extends StatelessWidget {
  final BankCard bankCard;
  const TransferTemplate({super.key, required this.bankCard});

  @override
  Widget build(BuildContext context) {
     String userId = Get.find<UserController>().userId;
    return Scaffold(
       backgroundColor: Color(0xfff9f9f9),
      appBar: AppBar(
        backgroundColor : Color(0xfff9f9f9),
        centerTitle: true,
        title: Text("Transfer template", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
      ),
      body:  StreamBuilder<List<Transactions>>(
  stream: getTransactionsStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData) {
      return Text("No data available");
    }
// Створення Set для зберігання унікальних номерів карток отримувачів
final uniqueReceiverCardNumbers = Set<String>();
    final transactions = snapshot.data!;
// Фільтрація транзакцій, де користувач є відправником і тип транзакції не є "mobile",
// та ігнорування дублікатів на основі номеру картки отримувача
final outgoingTransactions = transactions.where((transaction) {
  // Перевірка, чи вже існує транзакція з таким номером картки отримувача
  if (transaction.fromUserId == userId && transaction.type != "mobile" && !uniqueReceiverCardNumbers.contains(transaction.toCardId)) {
    // Додавання номеру картки отримувача до Set, щоб забезпечити унікальність
    uniqueReceiverCardNumbers.add(transaction.toCardId!);
    return true;
  }
  return false;
}).toList();
    return outgoingTransactions.isNotEmpty ? ListView.builder(
      shrinkWrap: true,
      itemCount: outgoingTransactions.length,
      itemBuilder: (context, index) {
        final transaction = outgoingTransactions[index];
        // Припускаємо, що у вас є поле toCardNumber в об'єкті Transaction
        return InkWell(
          onTap: () =>Navigator.push(context, MaterialPageRoute(builder:(context) => PayPage(cardData : bankCard, toCardNum : transaction.toCardId))),
          child: ListTile(
            title: Text("Card number: ${transaction.toCardId}"),
            subtitle: Text("User: ${transaction.toUserName}"),
            // Додайте додаткові деталі транзакції, які ви хочете відобразити
          ),
        );
      },
    ) : Text("There are no outgoing transactions");
  },
)

  
    );
  }
}
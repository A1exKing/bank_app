import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_bank/pages/history/details_page.dart';
import 'package:my_bank/pages/home_page.dart/last_transaction.dart';

FirebaseAuth auth = FirebaseAuth.instance;

String getCurrentUserUid() {
  User? user = auth.currentUser;

  if (user != null) {
    String uid = user.uid;
   return  uid;// Тут ви маєте UID користувача
  } else {
    print("Користувач не аутентифікований");
    return '';
  }
}

class HistoryPage extends StatelessWidget {
   HistoryPage({super.key, });
  //final String userId;
  @override
  Widget build(BuildContext context) {
   // print("user id card : $userId");
    return SafeArea(
      
      child: Scaffold(
        backgroundColor: Color(0xffF9F9F9),
        appBar: AppBar(
           backgroundColor: Color(0xffF9F9F9),
          leading: GestureDetector(
            
            child: Icon(Icons.chevron_left),
            onTap: (){},
          ),
          title: Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             // TimeSelector(),
StreamBuilder<List<Transactions>>(
  stream: getTransactionsStream( getCurrentUserUid() ), // Припускаємо, що getTransactionsStream() повертає Stream<List<Transaction>>
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    if (snapshot.hasData) {
      if(snapshot.data!.isNotEmpty){
        
        // Тут ми передаємо userId та дані зі snapshot.data! у наш виджет
        return TransactionListWidget(userId: getCurrentUserUid(), transactions: snapshot.data!);
      } else {
        return Text('There are no transactions');
      }
    }

    // Відображення індикатора завантаження поки дані завантажуються
    return CircularProgressIndicator();
  },
)
            ],
          ),
        ),
      ),
    );
  }
}


String getUserName(Transactions transaction, String currentUserId) {
  if (transaction.isIncoming(currentUserId)) {
    // Для вхідної транзакції повертаємо ім'я відправника
    return transaction.fromUserName; // Ваш код для отримання імені відправника
  } else if (transaction.isOutgoing(currentUserId)) {
    // Для вихідної транзакції повертаємо ім'я отримувача
    return transaction.toUserName; // Або інший спосіб отримання імені отримувача
  }
  return "Невідомий Користувач";
}

class TimeSelector extends StatefulWidget {
  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  int selectedIndex = 0; // Вибраний індекс для управління станом виділення
  final List<String> options = ['This Week', 'This Month', 'This Year'];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: options.asMap().entries.map((entry) {
            int idx = entry.key;
            String option = entry.value;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: selectedIndex == idx ? Colors.white : Colors.grey,
                    backgroundColor: selectedIndex == idx ? Colors.blue : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        color: selectedIndex == idx ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedIndex = idx;
                    });
                  },
                  child: Text(option),
                ),
              ),
            );
          }).toList(),
        ),
      );
  }
}
class TransactionListWidget extends StatelessWidget {

  TransactionListWidget({super.key,  required this.userId, required this.transactions});
  final String userId;
  final List<Transactions> transactions;

  @override
  Widget build(BuildContext context) {
    // Групування транзакцій за датою
    Map<DateTime, List<Transactions>> groupedTransactions = {};
    for (var transaction in transactions) {
      DateTime dateWithoutTime = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      if (groupedTransactions[dateWithoutTime] == null) {
        groupedTransactions[dateWithoutTime] = [];
      }
      groupedTransactions[dateWithoutTime]!.add(transaction);
    }

    List<DateTime> sortedDates = groupedTransactions.keys.toList();
    // Сортування за спаданням дати
    sortedDates.sort((a, b) => b.compareTo(a));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        DateTime date = sortedDates[index];
        List<Transactions> dailyTransactions = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 6),
              child: Text(
                DateFormat('dd MMMM yyyy').format(date),
                style: TextStyle(color: Color(0xff242424)),
              ),
            ),
            ...dailyTransactions.map((transaction) => 
             InkWell(
              onTap: () {
                 String userName = getUserName(transaction, userId);
                 print("USER NAME TO $userName");
                Navigator.push(context, MaterialPageRoute(builder:(context) => DetailsTransaction(transaction,userName, transaction.isIncoming(getCurrentUserUid())? "Sender" : "Recipient"),));
                },
               child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: transaction.isIncoming(getCurrentUserUid()) ?  Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2)  ,
                        child: transaction.isIncoming(getCurrentUserUid()) ?   Icon(Icons.arrow_downward, color: Colors.green,) :  Icon(Icons.arrow_upward, color: Colors.redAccent,),
                      ),
                      SizedBox(width: 12,),
                      Column( 
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(transaction.isIncoming(getCurrentUserUid())? "From: ${transaction.fromCardId}" : "To: ${transaction.toCardId}",  style: TextStyle(color: Color(0xff242424), fontSize: 14, fontWeight: FontWeight.w500),),
                        Text(DateFormat('HH:mm').format(transaction.date), style: TextStyle(color: Color(0xff747474), fontSize: 12, fontWeight: FontWeight.w400),)
                        //  Text(transaction.isIncoming(userId)? "To: ${transaction.toCardId}" : "From: ${transaction.fromCardId}" , style: TextStyle(color: Color(0xff242424), fontSize: 14, fontWeight: FontWeight.w500),),
                          //Text(DateFormat('HH:mm').format(transaction.date), style: TextStyle(color: Color(0xff747474), fontSize: 12, fontWeight: FontWeight.w400),)
                        ],
                      ),
                      Spacer(),//Займає вільний простір
                      Text(transaction.isIncoming(getCurrentUserUid()) ? "\$${ transaction.amount.toStringAsFixed(2)}" : "- \$${ transaction.amount.toStringAsFixed(2)}", style: TextStyle(color: Color(0xff242424), fontSize: 18, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
             )
            // ListTile(
            //   title: Text(transaction.description),
            //   subtitle: Text(DateFormat('HH:mm').format(transaction.date)),
            //   trailing: Text(transaction.isIncoming(userId) ?  '-\$${transaction.amount.toStringAsFixed(2)}' : '${transaction.amount.toStringAsFixed(2)}' ),
            // )
            ).toList(),
          ],
        );
      },
    );
  }
}
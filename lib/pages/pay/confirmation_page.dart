import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_bank/pages/pay/status_pay_page.dart';


class Transaction {
  double amount;
  String fromCardId;
  String toCardId;
  DateTime date;

  Transaction(
      {required this.amount,
      required this.fromCardId,
      required this.toCardId,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'fromCardId': fromCardId,
      'toCardId': toCardId,
      'date': date.toIso8601String(),
    };
  }
}

// Future<void> transferFunds({
//   required String fromUserId,
//   required String fromCardId,
//   required String toUserId,
//   required String toCardId,
//   required double amount,
// }) async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   DocumentReference fromCardRef = firestore
//       .collection('users')
//       .doc(fromUserId)
//       .collection('cards')
//       .doc(fromCardId);
//   DocumentReference toCardRef = firestore
//       .collection('users')
//       .doc(toUserId)
//       .collection('cards')
//       .doc(toCardId);


//   return firestore.runTransaction((transaction) async {
//     // Отримання даних карток
//     DocumentSnapshot fromCardSnapshot = await transaction.get(fromCardRef);
//     DocumentSnapshot toCardSnapshot = await transaction.get(toCardRef);

//     double fromCardBalance = (fromCardSnapshot['balanc'] as num).toDouble();
//     double toCardBalance = (toCardSnapshot['balanc'] as num).toDouble();
//     // Перевірка балансу та переказ коштів
//     if (fromCardBalance < amount) {
//       throw Exception('Недостатньо коштів на картці відправника');
//     }

//     transaction.update(fromCardRef, {'balanc': fromCardBalance - amount});
//     transaction.update(toCardRef, {'balanc': toCardBalance + amount});
//   });
// }




class ConfirmationPage extends StatefulWidget {
   ConfirmationPage({super.key, required  this.sum, required  this.description, required  this.numberOnCard, required  this.numberFromCard});
   final String sum;
   final String description;
   final String numberOnCard;
   final String numberFromCard;
  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool _isLoading = false;
  void openSnackbar({required String status, required String text}) {
      Get.snackbar('OK', text,
          snackPosition: SnackPosition.TOP,
          forwardAnimationCurve: Curves.elasticInOut,
          reverseAnimationCurve: Curves.easeOut,
          colorText: Colors.white,
          backgroundColor: status == "ok" ? Color(0xFF58C72C) : Color(0xffc72c41),
          duration: const Duration(seconds: 3));
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
       // elevation: 1,
        centerTitle: true,
        title: Text("Confirmation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
     
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                "Sender",
                style: TextStyle(color: Color(0xff747474), fontSize: 14),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Card",
                    style: TextStyle(color: Color(0xff242424), fontSize: 16),
                  ),
                   Text(
                    widget.numberFromCard.toString(),
                    style: TextStyle(color: Color(0xff747474), fontSize: 14),
                  ),
                ],
              )
              ],
            ),
            const SizedBox(height: 24,),
            Row(
               crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                "Receiver",
                style: TextStyle(color: Color(0xff747474), fontSize: 14),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Card",
                    style: TextStyle(color: Color(0xff242424), fontSize: 16),
                  ),
                   Text(
                    widget.numberOnCard,
                    style: TextStyle(color: Color(0xff747474), fontSize: 14),
                  ),
                ],
              )
              ],
            ),
            const SizedBox(height: 24,),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                 boxShadow: [BoxShadow(color: Color.fromARGB(255, 221, 221, 221), offset: Offset(2, 2), blurRadius: 12)]
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Commission from the sender",
                        style: TextStyle(color: Color(0xff747474), fontSize: 14),
                      ),
                      Text(
                        "\$ 2.00",
                        style: TextStyle(color: Color(0xff242424), fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Сommission from the recipient",
                        style: TextStyle(color: Color(0xff747474), fontSize: 14),
                      ),
                      Text(
                        "\$ 0.00",
                        style: TextStyle(color: Color(0xff242424), fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Before enrollment",
                        style: TextStyle(color: Color(0xff747474), fontSize: 14),
                      ),
                      Text(
                        "\$ ${widget.sum} ",
                        style: TextStyle(color: Color(0xff242424), fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),
                  Divider(
                    color: Color(0xff747474),

                  ),
                  SizedBox(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment amount",
                        style: TextStyle(color: Color(0xff747474), fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "\$ ${double.parse(widget.sum) + 2} ",
                        style: TextStyle(color: Color(0xff242424), fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ) 
                ],
              ),
            ),
            Expanded(
              child: _isLoading ? Center(child: Lottie.asset('assets/animations/makingTransaction_2.json')) : Container(),
            ),
            
             SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                   // findUserIdByCardNumber("6688193235576057");
                    setState(() => _isLoading = true);

    transferFundsByCardNumber(widget.numberFromCard, widget.numberOnCard, double.parse(widget.sum), widget.description)
    .then((_) {
      // Обробка успішного завершення
     // openSnackbar(status: "ok", text: "Транзакція успішно завершена");
     Navigator.push(context, MaterialPageRoute(builder:(context) =>  StatusPayPage(),));
    })
    .catchError((error) {
      // Обробка помилки
      openSnackbar(status: "error", text: 'Помилка транзакції: $error');
    })
    .whenComplete(() {
      // Виконується після успішного завершення або помилки
      setState(() => _isLoading = false);
    });
                  
                       
                   // Navigator.push(context, MaterialPageRoute(builder:(context) =>  CreateAccount(),));
                  }, 
                  style:  ButtonStyle(//задаємо стилі для кнопочки
                    backgroundColor: const MaterialStatePropertyAll(Color(0xff7f00ff)),
                    elevation: const MaterialStatePropertyAll(0),
                    shape: MaterialStatePropertyAll(//Задаємо скруглкння кутів
                      RoundedRectangleBorder(
                      //  side: BorderSide(color: Color(0xff7f00ff), width: 2.0),
                        borderRadius : BorderRadius.circular(12.0), // радіус скруглення тут
                      ),
                    ),
                  
                  ),
                  child: Text("Pay \$${double.parse(widget.sum) + 2} ",style: TextStyle(color: Colors.white)),),
              )
          ],
        ),
      ),
    );
  }
 
 

}


Future<String> findUserIdByCardNumber(String cardNumber) async {
 // FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    // FirebaseFirestore.instance
    // .collection('cards')
    // .where('cardNumber', isEqualTo: cardNumber)
    // .get()
    // .then((QuerySnapshot querySnapshot) {
    //     querySnapshot.docs.forEach((doc) {
    //         print(doc.data());
    //     });
    // });

    QuerySnapshot cardSnapshot = await firestore
        .collection('cards')
        .where('cardNumber', isEqualTo: cardNumber)
        .limit(1)
        .get();

    if (cardSnapshot.docs.isNotEmpty) {
      var cardData = cardSnapshot.docs.first.data() as Map<String, dynamic>; // Оновлено тут
      String userId = cardData['userID'];
      print(userId);
      return userId;
    } else {
      print("userID");
      return '';
      
    }
  } catch (e) {
    print(e);
    return '';
  }
}
Future<DocumentReference> findCardByNumber(String cardNumber) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('cards')
      .where('cardNumber', isEqualTo: cardNumber)
      .limit(1)
      .get();

  if (snapshot.docs.isNotEmpty) {
    return snapshot.docs.first.reference;
  } else {
    throw Exception('The card was not found');
  }
}
Future<void> transferFundsByCardNumber(
    String fromCardNumber, String toCardNumber, double amount, String description) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Знаходимо userId для обох карток
  String fromUserId = await findUserIdByCardNumber(fromCardNumber);
  String toUserId = await findUserIdByCardNumber(toCardNumber);

  // Якщо один з користувачів не знайдено, припиняємо операцію
  if (fromUserId.isEmpty || toUserId.isEmpty) {
    throw Exception('User with such a card was not found');
  }

  // Отримуємо посилання на документи карток
  //DocumentReference fromCardRef = firestore.collection('users').doc(fromUserId).collection('cards').doc(fromCardNumber);
 // DocumentReference toCardRef = firestore.collection('users').doc(toUserId).collection('cards').doc(toCardNumber);
 final DocumentReference fromCardRef = await findCardByNumber(fromCardNumber);
  final DocumentReference toCardRef = await findCardByNumber(toCardNumber);
  return firestore.runTransaction((transaction) async {
    // Отримання інформації про картки
    DocumentSnapshot fromCardSnapshot = await transaction.get(fromCardRef);
    DocumentSnapshot toCardSnapshot = await transaction.get(toCardRef);

    double fromCardBalance = fromCardSnapshot['balance'];
    double toCardBalance = toCardSnapshot['balance'];
    String toUserName = toCardSnapshot['cardHolderName'];
String fromUserName = fromCardSnapshot['cardHolderName'];
    // Перевірка балансу та оновлення
    if (fromCardBalance < amount) {
      throw Exception("The sender's card does not have sufficient funds");
    }

    transaction.update(fromCardRef, {'balance': fromCardBalance - amount});
    transaction.update(toCardRef, {'balance': toCardBalance + amount});
   // await FirebaseFirestore.instance.collection('transactions').add({"num" : "1"});
  await FirebaseFirestore.instance.collection('transactions').add({
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'toUserName': toUserName,
    'fromUserName': fromUserName,
    'fromCardId': fromCardNumber,
    'toCardId': toCardNumber,
    'amount': amount,
    "description" : description,
    'date': DateTime.now(),
  });


  });
}

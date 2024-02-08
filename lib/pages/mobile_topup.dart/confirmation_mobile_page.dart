import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_bank/controllers/user_controller.dart';
import 'package:my_bank/pages/pay/confirmation_page.dart';
import 'package:my_bank/pages/pay/status_pay_page.dart';
import 'package:my_bank/widgets/snackbar.dart';

class ConfirmationMobilePage extends StatefulWidget {
 ConfirmationMobilePage({super.key, required  this.sum,  required  this.mobileNumber, required  this.numberFromCard});
   final String sum;
   final String mobileNumber;
   final String numberFromCard;

  @override
  State<ConfirmationMobilePage> createState() => _ConfirmationMobilePageState();
}

class _ConfirmationMobilePageState extends State<ConfirmationMobilePage> {
   bool _isLoading = false;


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
                    "Mobile number",
                    style: TextStyle(color: Color(0xff242424), fontSize: 16),
                  ),
                   Text(
                    widget.mobileNumber,
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
                        "\$ 1.00",
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
                        "\$ ${double.parse(widget.sum) + 1} ",
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
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    setState(() => _isLoading = true);

                transferToMobile(widget.numberFromCard, widget.mobileNumber, double.parse(widget.sum)+1)
                .then((_) {
                  // Обробка успішного завершення
                // openSnackbar(status: "ok", text: "Транзакція успішно завершена");
                Navigator.push(context, MaterialPageRoute(builder:(context) =>  StatusPayPage(),));
                })
                .catchError((error) {
                  // Обробка помилки
                  openSnackbar(status: "error", text: 'Transaction error: $error');
                })
                .whenComplete(() {
                  // Виконується після успішного завершення або помилки
                  setState(() => _isLoading = false);
                });
                              
                       
                 
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
                  child: Text("Pay \$${double.parse(widget.sum) + 1} ",style: TextStyle(color: Colors.white)),),
              )
          ],
        ),
      ),
    );
  }
}
Future<void> transferToMobile(String fromCardNumber, String mobileNumber, double amount) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
 String userId = Get.find<UserController>().userId;
 
  final DocumentReference fromCardRef = await findCardByNumber(fromCardNumber);

  return firestore.runTransaction((transaction) async {
    // Отримання інформації про картки
    DocumentSnapshot fromCardSnapshot = await transaction.get(fromCardRef);

    // Перевірка, чи не заблоковані картки
    if (fromCardSnapshot['isBlocked'] == true) {
      throw Exception("The sender's card is blocked and cannot be used for transactions.");
    }
    double fromCardBalance = fromCardSnapshot['balance'];
    String fromUserName = fromCardSnapshot['cardHolderName'];

    // Перевірка балансу та оновлення
    if (fromCardBalance < amount) {
      throw Exception("The sender's card does not have sufficient funds");
    }

    transaction.update(fromCardRef, {'balance': fromCardBalance - amount});
   

    // Додавання запису транзакції
    await firestore.collection('transactions').add({
      'fromUserId': userId,
      'type': "mobile",
      'fromUserName': fromUserName,
      'fromCardId': fromCardNumber,
      'toMobileNumber': mobileNumber,
      'amount': amount,
      'date': DateTime.now(),
    });
  });
}

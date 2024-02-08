import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/models/bank_card.dart';
import 'package:my_bank/pages/card_details/transfer_template.dart';
import 'package:my_bank/pages/mobile_topup.dart/mobile_topup_page.dart';
import 'package:my_bank/pages/pay/pay_page.dart';
import 'package:my_bank/pages/statistic/statistic_page.dart';
import 'package:my_bank/widgets/snackbar.dart';
import 'package:flutter/services.dart';


class CardDetailsPage extends StatelessWidget {
  
   CardDetailsPage({super.key, required this.bankCard});
 final BankCard bankCard;
  @override
  Widget build(BuildContext context) {
   final LockCartController cardController = Get.find<LockCartController>();
   cardController.initVal(bankCard);
    
    print(bankCard);
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      appBar: AppBar(
        backgroundColor: Color(0xfff9f9f9),
        centerTitle: true,
        title: Text("Card Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              height:160,
               child:Container(
        width: 280,
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(colors: [Color(0xff8300ff), Color(0xffDB02FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: Color.fromARGB(255, 221, 221, 221), offset: Offset(2, 2), blurRadius: 12)]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/icons/chip.png", color: Color(0xfff6f6f6), width: 34,),
            Text("${bankCard.cardNumber}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BALANCE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),),
                    Text("\$ ${bankCard.balance.toStringAsFixed(2)}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset("assets/icons/master_card.png", width: 46,),
                    Text("MasterCard", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),),
                  ],
                )
              ],
            )
          ],
        ),
               )
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),//Зовнішні відступи
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            //height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Color(0xffe9e9e9), blurRadius: 18)]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context) => MobileTopUpPage(cardData: bankCard,),)),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Color(0xfff3e6ff),
                          borderRadius: BorderRadius.circular(34)
                        ),
                        child: Icon(Icons.phone_android, color: Color(0xff8612ff),),
                      ),
                      SizedBox(height: 6,),
                      Text("Mobile Top Up", style: TextStyle(fontSize: 12, color: Color(0xff242424), fontWeight: FontWeight.w500),)
                    ],
                  ),
                ),
                  Obx(() { 
                    final LockCartController cardController = Get.find<LockCartController>();
                   // cardController.initVal(bankCard.isBlocked);
                    return  GestureDetector(
                    onTap: (){
                     //bankCard.isBlocked?
                      cardController.toggleCardLock(bankCard.cardNumber);
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            color:  !cardController.isCardBlocked.value ? Color(0xffedfbf6)  :  Color(0xFFFBEDED),
                            borderRadius: BorderRadius.circular(34)
                          ),
                          child: !cardController.isCardBlocked.value ? Icon(Icons.lock_open_outlined, color: Color(0xff4cc3a9),):Icon(Icons.lock_outline, color: Color(0xFFC34C4C),),
                        ),
                        SizedBox(height: 6,),
                        Text(!cardController.isCardBlocked.value ? "Block card" : "Unlock card", style: TextStyle(fontSize: 12, color: Color(0xff242424), fontWeight: FontWeight.w500),)
                      ],
                    ),
                  );},
                ),
                 GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context) => PayPage(cardData : bankCard))),
                   child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Color(0xffe8eff6),
                          borderRadius: BorderRadius.circular(34)
                        ),
                        child: Icon(Icons.payment, color: Color(0xff4b85b2),),
                      ),
                      SizedBox(height: 6,),
                      Text("Pay", style: TextStyle(fontSize: 12, color: Color(0xff242424), fontWeight: FontWeight.w500),)
                    ],
                                 ),
                 )
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              color: Colors.white,
               boxShadow: [BoxShadow(color: Color(0xffe9e9e9), blurRadius: 18, offset: Offset(0, -2))]
            ),
            child: Column(
              children: [
                 Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context) => StatisticPage(),)),
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffe8ebef)
                            ),
                            child: Icon(Icons.bar_chart, color: Color(0xffacb8bf),),
                          ),
                          SizedBox(width: 12,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Statistics", style: TextStyle(color: Color(0xff242424), fontSize: 16, fontWeight: FontWeight.w500),),
                              Text("Card transactions", style: TextStyle(color: Color(0xff747474), fontSize: 14, fontWeight: FontWeight.w400),)
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right, color: Color(0xff7474747),)
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder:(context) => TransferTemplate(bankCard: bankCard,),));
                    
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xffe8ebef)
                          ),
                          child: Icon(Icons.payment, color: Color(0xffacb8bf),),
                        ),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Transfer template", style: TextStyle(color: Color(0xff242424), fontSize: 16, fontWeight: FontWeight.w500),),
                            Text("Make a payment ot transfer", style: TextStyle(color: Color(0xff747474), fontSize: 14, fontWeight: FontWeight.w400),)
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right, color: Color(0xff7474747),)
                      ],
                    ),
                  ),
                ),
                  GestureDetector(
                    onTap: (){
                      String textToCopy = bankCard.cardNumber;
                      Clipboard.setData(ClipboardData(text: textToCopy));
                      openSnackbar(status: "ok", text: "the card number has been copied:\n$textToCopy");

                    },
                    child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xffe8ebef)
                          ),
                          child: Icon(Icons.copy, color: Color(0xffacb8bf),),
                        ),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Copy card number", style: TextStyle(color: Color(0xff242424), fontSize: 16, fontWeight: FontWeight.w500),),
                            Text("Сopy card number", style: TextStyle(color: Color(0xff747474), fontSize: 14, fontWeight: FontWeight.w400),)
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right, color: Color(0xff7474747),)
                      ],
                    ),
                                  ),
                  ),
              ]
             ),
          ),

        ],
      ),
    );  
  }
}

class CardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final LockCartController cardController = Get.find<LockCartController>();
  Future<void> blockCardByNumber(String cardNumber) async {
     print("lock");
    // Здійсніть запит до Firestore для пошуку документа з номером карти
    var querySnapshot = await _firestore
        .collection('cards')
        .where('cardNumber', isEqualTo: cardNumber)
        .get();

    // Якщо документ існує, оновіть поле `isBlocked`
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('cards').doc(doc.id).update({
          'isBlocked': true,
        });
      //  cardController.toggleCardLock('4082649343365384');
        openSnackbar(status: 'error', text: 'Your card is blocked');
      }
    } 
  }
   Future<void> unlockCardByNumber(String cardNumber) async {
     print("unlock");
    // Здійсніть запит до Firestore для пошуку документа з номером карти
    var querySnapshot = await _firestore
        .collection('cards')
        .where('cardNumber', isEqualTo: cardNumber)
        .get();

    // Якщо документ існує, оновіть поле `isBlocked`
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('cards').doc(doc.id).update({
          'isBlocked': false,
        });
       // cardController.toggleCardLock('4082649343365384');
        openSnackbar(status: 'ok', text: 'Your card is unlocked');
      }
    } 
  }
}

class LockCartController extends GetxController {
//   void fetchCardBlockStatus(String cardNumber) {
//   FirebaseFirestore.instance
//       .collection('cards')
//       .doc(cardNumber)
//       .snapshots()
//       .listen((doc) {
//         if (doc.exists) {
//           isCardBlocked.value = doc.data()?['isBlocked'] ?? false;
//         }
//       });
// }
  // Rx тип дозволяє спостерігати за змінами значення
  
  var isCardBlocked = false.obs;
  void initVal(BankCard card)async{
    print(card.isBlocked);
     isCardBlocked.value = card.isBlocked;
  }
  // Метод для перемикання стану блокування
void toggleCardLock(String cardNumber) async {
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   

  final newValue = !isCardBlocked.value;
  try {
     var querySnapshot = await _firestore
        .collection('cards')
        .where('cardNumber', isEqualTo: cardNumber)
        .get();

    // Якщо документ існує, оновіть поле `isBlocked`
    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        await _firestore.collection('cards').doc(doc.id).update({
          'isBlocked': newValue,
        });
       // cardController.toggleCardLock('4082649343365384');
        newValue ? openSnackbar(status: 'ok', text: 'Your card is blocked') :  openSnackbar(status: 'ok', text: 'Your card is unlocked'); 
      }
    } 
    isCardBlocked.value = newValue; // Оновлюємо локальний стан лише після успішного оновлення бази даних
  } catch (e) {
    print("Помилка при оновленні стану блокування: $e");
  }
}


}
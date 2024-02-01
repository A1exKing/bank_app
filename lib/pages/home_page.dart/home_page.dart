// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_bank/pages/card_details/card_details_page.dart';
import 'package:my_bank/pages/home_page.dart/last_transaction.dart';







class HomePage extends StatelessWidget {
  const HomePage({super.key});

Future<Map<String, dynamic>?> getUserData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Отримання даних користувача
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    // Отримання карток користувача
   // QuerySnapshot cardsSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cards').get();
 QuerySnapshot cardsSnapshot = await FirebaseFirestore.instance
      .collection('cards')
      .where('userID', isEqualTo: user.uid )
      
      .get();
      print(cardsSnapshot);
    // Перетворення даних карток у список
    List<Map<String, dynamic>> cards = cardsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    // Повернення об'єднаних даних
    return {
      'userData': userDoc.data(),
      'cards': cards
    };
  }
  return null;
}
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return   WillPopScope(    ///Забороняє поверттися на попередню сторінку(Авторизації)
      onWillPop: () async {
        return false; 
      },
      child: Scaffold(
         backgroundColor: Color(0xffF9F9F9),
        body: SafeArea(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: getUserData(),//Отримуємо дані про користувача
             builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); //відображаємо завантаження 
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");//якщо ссталася помилка
                } else if (snapshot.hasData) {
                  Map<String, dynamic>? data = snapshot.data;
                  List dataCards = data!["cards"];
                  print(dataCards);
                  //відображаємо отримані дані
                  return  Column(
                crossAxisAlignment: CrossAxisAlignment.start, //Розташовуємо елементи прижимаючи їх до лівого краю
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), //Задаємо відступи
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blueAccent.withOpacity(0.1),
                          child: Image.asset("assets/icons/user_avatar.png",),
                         // backgroundImage: AssetImage("assets/icons/user_avatar.png"),
                          
                        ),
                        SizedBox(width: 12),
                        Text("${data!["userData"]["surname"]}\n${data["userData"]["name"]}", style: TextStyle(color: Color.fromARGB(255, 54, 54, 54), fontSize: 14, fontWeight: FontWeight.w500),),
                        Spacer(),
                        Image.asset("assets/icons/notification-bell.png", width: 28,)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Text("Cards", style: TextStyle(color: Color(0xff242424), fontSize: 16, fontWeight: FontWeight.w600),),
                  ),
                  SizedBox(
                    height: 174,
                    child: ListView.separated(//Виводимо список з відступами
                      separatorBuilder: (context, index) => const SizedBox(width : 12),//Задаємо відступи між елементами
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: dataCards.length,
                      itemBuilder: (context, index) => CardItem(data: BankCard.fromMap(data["cards"][index]), userId: userId, indexCard: index,),//виводимо елементи списку
                    ),  
                  ),
                  LastTransactionWidget(userId)
                 
                ],
              );
                
                } else {
                return Text("No user data available");
              }
             }
          )
        ),
      ),
    );
  }
}
class BankCard {
  String cardNumber;
  String cardHolderName;
  String expiryDate;
  int cvv;
   double  balanc;

  BankCard({required this.cardNumber, required this.cardHolderName, required this.expiryDate, required this.cvv,  required this.balanc});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'balanc': balanc,
    };
  }

  factory BankCard.fromMap(Map<String, dynamic> map) {
    return BankCard(
      cardNumber: map['cardNumber'] as String,
      cardHolderName: map['cardHolderName'] as String,
      expiryDate: map['expiryDate'] as String,
      cvv: map['cvv'] as int,
      balanc: map['balance'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory BankCard.fromJson(String source) => BankCard.fromMap(json.decode(source) as Map<String, dynamic>);
}


class CardItem extends StatefulWidget {
   CardItem({super.key, required this.data, required this.userId,  this.indexCard});
  BankCard data;
  int? indexCard;
  final String userId;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
//   Stream<List<BankCard>> getBalanceStream(String userId) {
//     //QuerySnapshot cardsSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('cards').get();
    
//  return FirebaseFirestore.instance
//       .collection('users')
//       .doc(userId)
//       .collection('cards')
//       .snapshots()
//       .map((snapshot) =>
//         snapshot.docs.map((doc) => BankCard.fromMap(doc.data())).toList());



// }


  @override
  Widget build(BuildContext context) {
    print(widget.data);
     
    // print( BankCard.fromMap(widget.data).balanc);
    return  GestureDetector( //відслідковування натиску
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CardDetailsPage(bankCard : widget.data ),)), //перехід по натиску на іншу сторінку
      child: Container(
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
            Text("${widget.data.cardNumber}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BALANCE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),),
                    Text("\$ ${widget.data.balanc.toStringAsFixed(2)}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
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
      ),
    );
         
     
    
    
   
  }
}

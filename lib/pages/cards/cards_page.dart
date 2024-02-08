import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/controllers/user_controller.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = Get.find<UserController>().userId;
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        centerTitle: true,
        title: Text("My Cards", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
      ),
      body:  StreamBuilder(
      stream: FirebaseFirestore.instance
        .collection('cards')
        .where('userID', isEqualTo: userId)
        .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
       
        if (snapshot.hasError) {
          return Text('Виникла помилка');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
             print(snapshot.data);
            var cardData = documents[index].data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Card number:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  Text('${cardData['cardNumber']}'),
                  const SizedBox(height: 6,),
                  Text("Card holder name:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  Text(cardData['cardHolderName'] ?? 'Невідомий'),
                  const SizedBox(height: 6,),
                  Text("Balance:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  Text('${cardData['balance']}'),
                  const SizedBox(height: 6,),
                  Text("CVV:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  Text('${cardData['cvv']}'),
                  const SizedBox(height: 6,),
                  Text("Expiry date:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  Text('${cardData['expiryDate']}')
                ],
              ),
            );

          },
        );
      },
    )
    );
  }
}
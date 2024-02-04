
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_bank/models/bank_card.dart';
import 'package:my_bank/pages/home.dart/last_transaction.dart';
import 'package:my_bank/pages/home.dart/widgets/card_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<Map<String, dynamic>?> getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final QuerySnapshot cardsSnapshot = await FirebaseFirestore.instance
        .collection('cards')
        .where('userID', isEqualTo: user.uid)
        .get();

    final List<Map<String, dynamic>> cards = cardsSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return {'userData': userDoc.data(), 'cards': cards};
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xffF9F9F9),
        body: SafeArea(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                return _buildUserData(context, snapshot.data!, userId);
              } else {
                return const Text("No user data available");
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserData(
      BuildContext context, Map<String, dynamic> data, String userId) {
    final List<dynamic> dataCards = data["cards"];
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, //Розташовуємо елементи прижимаючи їх до лівого краю
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8), //Задаємо відступи
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: Image.asset(
                    "assets/icons/user_avatar.png",
                  ),
                  // backgroundImage: AssetImage("assets/icons/user_avatar.png"),
                ),
                const SizedBox(width: 12),
                Text(
                  "${data["userData"]["surname"]}\n${data["userData"]["name"]}",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 54, 54, 54),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Image.asset(
                  "assets/icons/notification-bell.png",
                  width: 28,
                )
              ],
            ),
          ),
         const Padding(
            padding:  EdgeInsets.only(left: 16, top: 8),
            child: Text(
              "Cards",
              style: TextStyle(
                  color: Color(0xff242424),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 174,
            child: ListView.separated(
              //Виводимо список з відступами
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 12), //Задаємо відступи між елементами
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              scrollDirection: Axis.horizontal,
              itemCount: dataCards.length,
              itemBuilder: (context, index) => CardItem(
                data: BankCard.fromMap(data["cards"][index]),
                userId: userId,
                indexCard: index,
              ), //виводимо елементи списку
            ),
          ),
          LastTransactionWidget(userId)
        ],
      ),
    );
  }
}



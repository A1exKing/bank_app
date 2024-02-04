import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_bank/pages/login/login_page..dart';
import 'package:my_bank/pages/login/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    String userId = Get.find<UserController>().userId;
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
          centerTitle: true,
          title:const  Text("User profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
       
        actions: [
          IconButton(
            onPressed: ()async{
              // Виклик методу signOut для виходу з облікового запису
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => LoginPage(),));
            }, 
            icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
      return Text('Виникла помилка');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
      return Text('Користувача не знайдено');
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        return Padding(
          padding:const  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Center(
                 child: CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    child: Image.asset(
                      "assets/icons/user_avatar.png",
                    ),
                    // backgroundImage: AssetImage("assets/icons/user_avatar.png"),
                  ),
               ),
              const SizedBox(height: 24,),
              Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              Text('${userData['name']}'),
              const SizedBox(height: 6,),
              Text("Surname", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              Text('${userData['surname']}'),
              const SizedBox(height: 6,),
              Text("Phone", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              Text('${userData['phone']}'),
              const SizedBox(height: 6,),
              Text("Account creation date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              Text(DateFormat('dd MMMM yyyy').format(userData['createDate'].toDate())),

            ],
          ),
        );
        
      //   ListTile(
      // title: Text(userData['name'] ?? 'Невідоме ім\'я'),
      // subtitle: Text('Телефон: ${userData['phone']}'),
      // trailing: Text('Прізвище: ${userData['surname']}'),
      // Тут можна додати більше інформації або віджетів за необхідності
        //);
      },
    ),
    );
  }
}
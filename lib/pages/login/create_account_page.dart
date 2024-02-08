import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/controllers/user_controller.dart';
import 'package:my_bank/main.dart';
import 'dart:math';

import 'package:my_bank/widgets/snackbar.dart';



class CreateAccount extends StatelessWidget {
  CreateAccount({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();



  String generateCardNumber() {
  Random random = Random();
  int firstDigit = random.nextInt(6) + 3; // Зазвичай 3, 4, 5 або 6 для стандартних платіжних систем
  String cardNumber = '$firstDigit';
  // Генерація перших 15 цифр картки
  for (int i = 0; i < 15; i++) {
    cardNumber += random.nextInt(10).toString();
  }
  return cardNumber;
}

void _register(context) async {
    try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    User? user = userCredential.user;

    if (user != null) {
      var cardData = {
      'cardNumber': generateCardNumber(),
      'cardHolderName': surnameController.text,
      'expiryDate': "${DateTime.now().month}/${DateTime.now().year +2}",
      'userID' : user.uid,
      'balance' : 1000.0,
      'isBlocked' : false,
      'cvv': Random().nextInt(900) + 100 // 900 = 999 - 100 + 1
    };  
      // Зберігання додаткової інформації в Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text,
        'surname': surnameController.text, 
        'phone': phoneController.text,   
        'createDate': DateTime.now()
      });
      
     await FirebaseFirestore.instance.collection('cards').add(cardData);
      openSnackbar(status: 'ok',text : "you have successfully registered");
       final userController = Get.find<UserController>();
       userController.userId = userCredential.user!.uid;
      Navigator.push(context, MaterialPageRoute(builder:(context) => MainPage(),));// Перехід на головний екран
      // Перехід на головний екран або інші дії після реєстрації
    }
  }on FirebaseAuthException catch (e) {
     openSnackbar(status: 'error', text: e.code);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    resizeToAvoidBottomInset: false,//потрібно для накладання клавіатури по верх основого контексту
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context); // По натиску повертаємося на попередню сторінку
          },
          icon: const Icon(Icons.chevron_left)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            const Text(
              "Create account",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            //Поле для вводу тексту
           TextFormField(
            controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                enabledBorder: UnderlineInputBorder(
                 borderSide: BorderSide(color: Color(0xffb8b8b8)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
                    
              ),
            ),
            const SizedBox(height: 14,),
            TextFormField(
              controller: surnameController,
              decoration: const InputDecoration(
                labelText: 'Surname',
                 labelStyle: TextStyle(fontWeight: FontWeight.w500),
                 enabledBorder: UnderlineInputBorder(
                 borderSide: BorderSide(color: Color(0xffb8b8b8)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
            const SizedBox(height: 14,),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress, //тип клавіатури для логіну
              decoration: const InputDecoration(
                labelText: 'Email',
                 labelStyle: TextStyle(fontWeight: FontWeight.w500),
                 enabledBorder: UnderlineInputBorder(
                 borderSide: BorderSide(color: Color(0xffb8b8b8)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
            const SizedBox(height: 14,),
            TextFormField(
              controller: passwordController,
              obscureText: true,//Приховуємо текст
              decoration: const InputDecoration(
                labelText: 'Password',
                 labelStyle: TextStyle(fontWeight: FontWeight.w500),
                 enabledBorder: UnderlineInputBorder(
                 borderSide: BorderSide(color: Color(0xffb8b8b8)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
             const SizedBox(height: 14,),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,//тип клавіатури для номеру телефону
              decoration: const InputDecoration(
                labelText: 'Phone number',
                 labelStyle: TextStyle(fontWeight: FontWeight.w500),
                 enabledBorder: UnderlineInputBorder(
                 borderSide: BorderSide(color: Color(0xffb8b8b8)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
             const Spacer(),
              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    _register(context);
                  
                  }, 
                  style:  ButtonStyle(//задаємо стилі для кнопочки
                    backgroundColor: MaterialStatePropertyAll(Color(0xff7f00ff)),
                    shape: MaterialStatePropertyAll(//Задаємо скруглкння кутів
                      RoundedRectangleBorder(
                        borderRadius : BorderRadius.circular(12.0), // радіус скруглення тут
                      ),
                    )
                  
                  ),
                  child: Text("Create account",style: TextStyle(color: Colors.white),)),
              ),
          ],
        ),
      ),
    );
  }
}

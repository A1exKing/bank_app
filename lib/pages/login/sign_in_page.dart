import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:my_bank/main.dart';

class UserController extends GetxController {
  var _userId = ''.obs;

  String get userId => _userId.value;

  set userId(String value) => _userId.value = value;
}


class SignInPage extends StatefulWidget {
   SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
   final TextEditingController emailController = TextEditingController();

   final TextEditingController passwordController = TextEditingController();

   void openSnackbar(textError) {
    Get.snackbar(
      'Error',
      textError,
      snackPosition: SnackPosition.TOP,
      forwardAnimationCurve: Curves.elasticInOut,
      reverseAnimationCurve: Curves.easeOut,
      colorText: Colors.white,
      backgroundColor: Color(0xffc72c41),
      duration: const Duration(seconds: 3)
    );
  }

   void _signIn(context) async {
    try {
      final userController = Get.find<UserController>();
      // Використання firebase_auth для входу користувача
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      userController.userId = userCredential.user!.uid;
      Navigator.push(context, MaterialPageRoute(builder:(context) => MainPage(),));// Перехід на головний екран
      
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') { // Немає користувача, що відповідає вказаній електронній адресі.
        openSnackbar("There is no user matching the specified email address.");
    } else if (e.code == 'invalid-credential') { // Неправильний пароль для даної електронної адреси.
      
        openSnackbar("The password for this email address is incorrect.");
      
     } else if (e.code == 'too-many-requests') { //   Багато спроб входу з невірним паролем.
        openSnackbar("Many login attempts with incorrect password.");
     } else if (e.code == 'channel-error') { // Незаповнені поля.
      
        openSnackbar("There are blank fields.");
      
     } else if (e.code == 'invalid-email') { //   Багато спроб входу з невірним паролем.
        openSnackbar("Invalid Email.");
     } else{
      openSnackbar("Login Error");
     }
    }
  }

  @override
  Widget build(BuildContext context) {
     // Визначення, чи відкрита клавіатура
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: Colors.white,
     // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
       
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
             AnimatedContainer(
              duration: const Duration(milliseconds: 200), // Тривалість анімації
              child: Center(
                child: SvgPicture.asset(
                  "assets/images/sign_in.svg",
                 height: isKeyboardOpen ? 150 : 300,
                ),
              ),
            ),
            Text('Sign In', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
            SizedBox(height: 16,),
            TextFormField(
            controller: emailController,
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
            obscureText: true,
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
           const Spacer(),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                 _signIn(context);
                }, 
                style:  ButtonStyle(//задаємо стилі для кнопочки
                  backgroundColor: MaterialStatePropertyAll(Color(0xff7f00ff)),
                  shape: MaterialStatePropertyAll(//Задаємо скруглкння кутів
                    RoundedRectangleBorder(
                      borderRadius : BorderRadius.circular(12.0), // радіус скруглення тут
                    ),
                  )
                
                ),
                child: Text("Sign In",style: TextStyle(color: Colors.white),)),
            ),
          ]
        )
      )
    ); 
  }
}
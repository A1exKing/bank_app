import 'package:flutter/material.dart';
import 'package:my_bank/pages/login/create_account_page.dart';
import 'package:my_bank/pages/login/sign_in_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 80,),
                Image.asset("assets/images/bank.jpg"),
                Text('Let`s get started', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),),
                Text(
                  'Welcome to My Bank! Your reliable partner in the financial world. Together, we make your finances simpler and safer',
                  textAlign: TextAlign.center,//вирівнюємо текст по центру
                  style: TextStyle(color: Color(0xff747474),fontSize: 16, fontWeight: FontWeight.w400),),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context) => SignInPage(),));
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
                SizedBox(height: 12,),
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context) =>  CreateAccount(),));
                    }, 
                    style:  ButtonStyle(//задаємо стилі для кнопочки
                      backgroundColor: const MaterialStatePropertyAll(Colors.white),
                      elevation: const MaterialStatePropertyAll(0),
                      shape: MaterialStatePropertyAll(//Задаємо скруглкння кутів
                        RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xff7f00ff), width: 2.0),
                          borderRadius : BorderRadius.circular(12.0), // радіус скруглення тут
                        ),
                      ),
                    
                    ),
                    child: Text("Create account",style: TextStyle(color: Color(0xff7f00ff)),)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
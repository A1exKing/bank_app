import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_bank/main.dart';
import 'package:my_bank/pages/home.dart/home_page.dart';

class StatusPayPage extends StatelessWidget {
  const StatusPayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      
        
        Navigator.push(context, MaterialPageRoute(builder:(context) => MainPage(),));
        return false; 
      },
      child: Scaffold(
        backgroundColor: Color(0xffF9F9F9),
        appBar: AppBar(
          backgroundColor: Color(0xffF9F9F9),
           centerTitle: true,
          title:const  Text("Result", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          
          leading: IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => MainPage(),)),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              Center(child: Lottie.asset('assets/animations/result.json', repeat: false)),
              Text("Transfer completed successfully", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.green),),
              const SizedBox(height: 12,),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context) => MainPage(),));
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
                  child: Text("Home Page",style: TextStyle(color: Colors.white)),),
              
            ],
          ),
        ),
      ),
    );
  }
}
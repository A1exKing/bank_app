import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_bank/main.dart';
import 'package:my_bank/pages/home_page.dart/home_page.dart';

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
        appBar: AppBar(
          title: Text("Result"),
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
              Text("Transfer completed successfully", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.green),)
            ],
          ),
        ),
      ),
    );
  }
}
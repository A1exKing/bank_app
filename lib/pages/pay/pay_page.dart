import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_bank/pages/home_page.dart/home_page.dart';
import 'package:my_bank/pages/pay/confirmation_page.dart';


class PayPage extends StatelessWidget {
  final TextEditingController numCardController = TextEditingController();
  final TextEditingController sumTransferController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final BankCard cardData;
  PayPage({super.key, required this.cardData});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Transfer to the card"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 12, top: 24),
            child: Text(
              "From the card",
              style: TextStyle(color: Color(0xff747474), fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16, right: 16
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E4E4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 85,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                          colors: [Color(0xff8300ff), Color(0xffDB02FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.payment_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${cardData.cardNumber}",
                        style:
                            TextStyle(color: Color(0xff747474), fontSize: 14),
                      ),
                      Text(
                        "\$ ${cardData.balanc.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Color(0xff242424),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 14),
            child: Text(
              "On a card",
              style: TextStyle(color: Color(0xff747474), fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 85,
              child:  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFFE4E4E4)),
                    ),
                    child: TextField(
                      controller: numCardController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.payment_outlined),
                          hintText: "Number card"),
                    ),
                  ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: sumTransferController,
              decoration: InputDecoration(
                hintText: "Amount to transfer",
                 hintStyle: TextStyle(fontWeight: FontWeight.w400)),
            ),
          ),
      
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Purpose of payment",
                hintStyle: TextStyle(fontWeight: FontWeight.w400)
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
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
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context) => ConfirmationPage(
                      sum : sumTransferController.text, 
                      description : descriptionController.text,
                      numberOnCard : numCardController.text,
                      numberFromCard : cardData.cardNumber,
                      ),));
                    
                  },
                  child: Text("Continue", style: TextStyle(color: Colors.white),)),
            ),
          )
        ],
      ),
    );
  }
}

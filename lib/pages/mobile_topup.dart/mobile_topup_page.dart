import 'package:flutter/material.dart';
import 'package:my_bank/models/bank_card.dart';
import 'package:my_bank/pages/mobile_topup.dart/confirmation_mobile_page.dart';


class MobileTopUpPage extends StatelessWidget {
   final BankCard cardData;
  MobileTopUpPage({super.key, required this.cardData});

  final TextEditingController mobileNumController = TextEditingController();
  final TextEditingController sumTransferController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      final _formKey = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        centerTitle: true,
        title: Text("Mobile top up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
     
      ),
      body: Form(
        key: _formKey,
        child: Column(
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
                            "\$ ${cardData.balance.toStringAsFixed(2)}",
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
                  "Mobile number",
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
                        child: TextFormField( 
                          keyboardType: TextInputType.phone,
                          controller: mobileNumController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone_android),
                              hintText: "Mobile number"),
                              validator: (value) {
                              String pattern = r'(^\+?3?8?(0[5-9][0-9]\d{7})$)';
                              RegExp regExp = RegExp(pattern);
                              if (value == null || value.isEmpty) {
                                return 'Please enter a phone number';
                              } else if (!regExp.hasMatch(value)) {
                                return 'Must correspond to the format +XX (XХХ) ХХХХХХХ';
                              }
                              return null;
                            },
                            
                        ),
                        
                      ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: sumTransferController,
                  decoration: InputDecoration(
                    hintText: "Amount to transfer",
                     hintStyle: TextStyle(fontWeight: FontWeight.w400)),
                     validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount for the transfer';
                    }
                    if (!RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(value)) {
                      return 'Enter a valid number (integer or floating point. )';
                    }
                    return null; // Якщо дані валідні
                  },
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 54,
                width: double.infinity-34,
                child: ElevatedButton(
                  style:  ButtonStyle(//задаємо стилі для кнопочки
                      backgroundColor: const MaterialStatePropertyAll(Color(0xff7f00ff)),
                      elevation: const MaterialStatePropertyAll(0),
                      shape: MaterialStatePropertyAll(//Задаємо скруглкння кутів
                        RoundedRectangleBorder(
                          borderRadius : BorderRadius.circular(12.0), // радіус скруглення тут
                        ),
                      ),
                    
                    ),
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                   // Якщо всі поля форми валідні, тут можна виконувати подальші дії
                  Navigator.push(context, MaterialPageRoute(builder:(context) => ConfirmationMobilePage(
                              sum : sumTransferController.text, 
                              mobileNumber : mobileNumController.text,
                              numberFromCard : cardData.cardNumber,
                              ),));
                }
                      
                      
                    
                  },
                  child: Text("Continue", style: const TextStyle(color: Colors.white),),
                ),
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
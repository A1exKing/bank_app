import 'package:flutter/material.dart';
import 'package:my_bank/pages/home_page.dart/home_page.dart';
import 'package:my_bank/pages/pay/pay_page.dart';
import 'package:my_bank/pages/statistic_page/statistic_page.dart';

class CardDetailsPage extends StatelessWidget {
   CardDetailsPage({super.key, required this.bankCard});
 final BankCard bankCard;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Card Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              height:160,
               child:Container(
        width: 280,
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(colors: [Color(0xff8300ff), Color(0xffDB02FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: Color.fromARGB(255, 221, 221, 221), offset: Offset(2, 2), blurRadius: 12)]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/icons/chip.png", color: Color(0xfff6f6f6), width: 34,),
            Text("${bankCard.cardNumber}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("BALANCE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),),
                    Text("\$ ${bankCard.balanc.toStringAsFixed(2)}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset("assets/icons/master_card.png", width: 46,),
                    Text("MasterCard", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),),
                  ],
                )
              ],
            )
          ],
        ),
               )
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),//Зовнішні відступи
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            //height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Color(0xffe9e9e9), blurRadius: 18)]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Color(0xfff3e6ff),
                        borderRadius: BorderRadius.circular(34)
                      ),
                      child: Icon(Icons.add, color: Color(0xff8612ff),),
                    ),
                    SizedBox(height: 6,),
                    Text("Top Up", style: TextStyle(fontSize: 12, color: Color(0xff242424), fontWeight: FontWeight.w500),)
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Color(0xffedfbf6),
                        borderRadius: BorderRadius.circular(34)
                      ),
                      child: Icon(Icons.lock_outline, color: Color(0xff4cc3a9),),
                    ),
                    SizedBox(height: 6,),
                    Text("Lock Card", style: TextStyle(fontSize: 12, color: Color(0xff242424), fontWeight: FontWeight.w500),)
                  ],
                ),
                 GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context) => PayPage(cardData : bankCard))),
                   child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Color(0xffe8eff6),
                          borderRadius: BorderRadius.circular(34)
                        ),
                        child: Icon(Icons.payment, color: Color(0xff4b85b2),),
                      ),
                      SizedBox(height: 6,),
                      Text("Pay", style: TextStyle(fontSize: 12, color: Color(0xff242424), fontWeight: FontWeight.w500),)
                    ],
                                 ),
                 )
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder:(context) => StatisticPage(),)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                color: Colors.white,
                 boxShadow: [BoxShadow(color: Color(0xffe9e9e9), blurRadius: 18, offset: Offset(0, -2))]
              ),
              child: Column(
                children: [
                   Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xffe8ebef)
                          ),
                          child: Icon(Icons.bar_chart, color: Color(0xffacb8bf),),
                        ),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Statistics", style: TextStyle(color: Color(0xff242424), fontSize: 16, fontWeight: FontWeight.w500),),
                            Text("Card transactions", style: TextStyle(color: Color(0xff747474), fontSize: 14, fontWeight: FontWeight.w400),)
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right, color: Color(0xff7474747),)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xffe8ebef)
                          ),
                          child: Icon(Icons.payment, color: Color(0xffacb8bf),),
                        ),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment or transfer", style: TextStyle(color: Color(0xff242424), fontSize: 16, fontWeight: FontWeight.w500),),
                            Text("Make a payment ot transfer", style: TextStyle(color: Color(0xff747474), fontSize: 14, fontWeight: FontWeight.w400),)
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right, color: Color(0xff7474747),)
                      ],
                    ),
                  ),
                    Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xffe8ebef)
                          ),
                          child: Icon(Icons.settings, color: Color(0xffacb8bf),),
                        ),
                        SizedBox(width: 12,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Card Settings", style: TextStyle(color: Color(0xff242424), fontSize: 16, fontWeight: FontWeight.w500),),
                            Text("Modify card", style: TextStyle(color: Color(0xff747474), fontSize: 14, fontWeight: FontWeight.w400),)
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.chevron_right, color: Color(0xff7474747),)
                      ],
                    ),
                  ),
                ]
               ),
            ),
          ),

        ],
      ),
    );  
  }
}
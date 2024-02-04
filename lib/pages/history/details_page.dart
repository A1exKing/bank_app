import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_bank/models/transactions.dart';
import 'package:my_bank/pages/home.dart/last_transaction.dart';

class DetailsTransaction extends StatelessWidget {
  Transactions transaction;

  String typeTran;
   DetailsTransaction(this.transaction, this.typeTran, {super.key});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM, yyyy ----- kk:mm').format(transaction.date);
    return Scaffold(
       backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
         backgroundColor: Color(0xffF9F9F9),
          centerTitle: true,
        title: Text("Details Transaction", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
      
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xfff6f6f6),
                boxShadow:  [BoxShadow(color: Color.fromARGB(255, 221, 221, 221), offset: Offset(2, 2), blurRadius: 12)]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("From Card:"),
                  Text("${transaction.fromCardId}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  SizedBox(height: 12,),
                  Text("To Card:"),
                  Text("${transaction.toCardId}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  SizedBox(height: 12,),
                  Text("Date:"),
                  Text("${formattedDate}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  SizedBox(height: 12,),
                  Text("$typeTran's:"),
                  Text(typeTran == "Sender" ? '${transaction.fromUserName}' : '${transaction.toUserName}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  
                  SizedBox(height: 12,),
                  Text("Description:"),
                  Text("${transaction.description}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
 SizedBox(height: 12,),
                  
                  Divider(color: Color.fromARGB(255, 94, 77, 77),),
                 
 
                  Text("Amount:"),
                  Text("\$${transaction.amount.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
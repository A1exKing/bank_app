import 'package:flutter/material.dart';
import 'package:my_bank/models/bank_card.dart';
import 'package:my_bank/pages/card_details/card_details_page.dart';

class CardItem extends StatefulWidget {
  CardItem(
      {super.key, required this.data, required this.userId, this.indexCard});
  BankCard data;
  int? indexCard;
  final String userId;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);

    // print( BankCard.fromMap(widget.data).balanc);
    return GestureDetector(
      //відслідковування натиску
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CardDetailsPage(bankCard: widget.data),
          )), //перехід по натиску на іншу сторінку
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
                colors: [Color(0xff8300ff), Color(0xffDB02FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 221, 221, 221),
                  offset: Offset(2, 2),
                  blurRadius: 12)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/icons/chip.png",
              color: Color(0xfff6f6f6),
              width: 34,
            ),
            Text(
              "${widget.data.cardNumber}",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BALANCE",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                    Text(
                      "\$ ${widget.data.balance.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      "assets/icons/master_card.png",
                      width: 46,
                    ),
                    Text(
                      "MasterCard",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

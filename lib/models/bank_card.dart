import 'dart:convert';

  class BankCard {
    String cardNumber;
    String cardHolderName;
    String expiryDate;
    bool isBlocked;
    int cvv;
    num balance;

    BankCard(
        {required this.cardNumber,
        required this.cardHolderName,
        required this.expiryDate,
        required this.cvv,
        required this.isBlocked,
        required this.balance});


    factory BankCard.fromMap(Map<String, dynamic> map) {
      return BankCard(
        cardNumber: map['cardNumber'] as String,
        cardHolderName: map['cardHolderName'] as String,
        expiryDate: map['expiryDate'] as String,
        isBlocked: map['isBlocked'] as bool,
        cvv: map['cvv'] as int,
        balance: map['balance'] as num,
      );
    }

    
    factory BankCard.fromJson(String source) =>
        BankCard.fromMap(json.decode(source) as Map<String, dynamic>);
  }

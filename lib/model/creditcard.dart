class CreditCard {
  final String? cardNumber;
  final String? expiryDate;
  final String? cardHolder;
  final String? cvv;

  CreditCard({
    this.cardNumber,
    this.expiryDate,
    this.cardHolder,
    this.cvv,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      cardNumber: json["cardNumber"],
      expiryDate: json["expiryData"],
      cardHolder: json["cardHolder"],
      cvv: json["cvv"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "cardNumber": cardNumber,
      "expiryDate": expiryDate,
      "cardHolder": cardHolder,
      "cvv": cvv,
    };
  }
}

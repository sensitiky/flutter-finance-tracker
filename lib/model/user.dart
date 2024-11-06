import 'package:fundora/model/creditcard.dart';

class User {
  final String id;
  final String? name;
  final String? email;
  final List<CreditCard>? creditCards;

  User({required this.id, this.name, this.email, this.creditCards});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json["email"],
      creditCards: json["creditCards"] != null
          ? (json["creditCards"] as List)
              .map((cardJson) => CreditCard.fromJson(cardJson))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "creditCards": creditCards?.map((card) => card.toJson()).toList(),
    };
  }
}

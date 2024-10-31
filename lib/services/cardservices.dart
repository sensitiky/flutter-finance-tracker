import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/creditcard.dart';

/*TODO
Recorrer las tarjetas del usuario si tiene más de una, máximo de 5 por persona??
Poder editar las tarjetas, verificar tarjetas con un pago minimo de $0.1
*/
class CardServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CreditCard>> getUserCards(String uid) async {
    if (uid.isNotEmpty) {
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection("users").doc(uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          List<dynamic> creditCardsData = data["creditCards"] ?? [];
          List<CreditCard> cards = creditCardsData
              .map((cardData) => CreditCard.fromJson(cardData))
              .toList();
          return cards;
        } else {
          return [];
        }
      } catch (error) {
        throw Exception("Error getting card data $error");
      }
    } else {
      return [];
    }
  }

  Future<bool> saveCreditCard(String uid, Map<String, dynamic> cardData) async {
    try {
      await _firestore.collection("users").doc(uid).set({
        "creditCards": FieldValue.arrayUnion([cardData])
      }, SetOptions(merge: true));
      return true;
    } catch (error) {
      throw Exception("Failed to save user data: $error");
    }
  }
}

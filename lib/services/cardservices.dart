import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fundora/model/creditcard.dart';

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

  Future<bool> updateCreditCard(
      String uid, index, Map<String, dynamic> cardData) async {
    try {
      var userDocs = await _firestore.collection("users").doc(uid).get();
      if (userDocs.exists) {
        Map<String, dynamic> data = userDocs.data() as Map<String, dynamic>;
        List<dynamic> creditCardsData = data["creditCards"] ?? [];
        if (index >= 0 && index < creditCardsData.length) {
          creditCardsData[index] = cardData;
          await _firestore
              .collection("users")
              .doc(uid)
              .update({"creditCards": creditCardsData});
        }
      }
      return true;
    } catch (error) {
      throw Exception("Failed to update credit card $error");
    }
  }

  Future<bool> removeCreditCard(String uid, index) async {
    try {
      var userDocs = await _firestore.collection("users").doc(uid).get();
      if (userDocs.exists) {
        Map<String, dynamic> data = userDocs.data() as Map<String, dynamic>;
        List<dynamic> creditCardsData = data["creditCards"] ?? [];
        creditCardsData.removeAt(index);
        await _firestore
            .collection("users")
            .doc(uid)
            .update({"creditCards": creditCardsData});
      }
      return true;
    } catch (error) {
      throw Exception("Failed to remove credit card $error");
    }
  }
}

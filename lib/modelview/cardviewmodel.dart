import 'package:expense_tracker/model/creditcard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/cardservices.dart';

class CreditCardViewModel extends ChangeNotifier {
  final CardServices _cardServices;
  CreditCard? _cardModel;
  CreditCardViewModel(this._cardServices);

  CreditCard? get cardModel => _cardModel;
  String get cardNumber => _cardModel?.cardNumber ?? "";
  String get expiryDate => _cardModel?.expiryDate ?? "";
  String get cardHolder => _cardModel?.cardHolder ?? "";
  String get cvv => _cardModel?.cvv ?? "";

  Future<void> getUserCard(String uid) async {
    try {
      List<CreditCard> cards = await _cardServices.getUserCards(uid);
      if (cards.isNotEmpty) {
        _cardModel = cards.first;
        notifyListeners();
      }
    } catch (error) {
      throw Exception("Error fetching user card $error");
    }
  }

  Future<bool> saveCardOrUpdateCard(String uid, String cardNumber,
      String expiryDate, String cardHolder, String cvv) async {
    var cardData = {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolder': cardHolder,
      'cvv': cvv
    };
    try {
      var isCardSaved = await _cardServices.saveCreditCard(uid, cardData);
      if (isCardSaved) {
        _cardModel = CreditCard(
          cardHolder: cardHolder,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cvv: cvv,
        );
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception("Error saving credit card $error");
    }
  }
}

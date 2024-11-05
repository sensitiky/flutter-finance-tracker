import 'package:fundora/src/model/creditcard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/cardservices.dart';

class CreditCardViewModel extends ChangeNotifier {
  final CardServices _cardServices;
  List<CreditCard> _cardModels = [];

  CreditCardViewModel(this._cardServices);
  List<CreditCard> get cardModel => _cardModels;

  Future<void> getUserCard(String uid) async {
    try {
      List<CreditCard> cards = await _cardServices.getUserCards(uid);
      _cardModels = cards;
      notifyListeners();
    } catch (error) {
      throw Exception("Error fetching user card $error");
    }
  }

  Future<bool> saveCreditCard({
    required String uid,
    required String cardNumber,
    required String expiryDate,
    required String cardHolder,
    required String cvv,
  }) async {
    var cardData = {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolder': cardHolder,
      'cvv': cvv
    };
    try {
      var isCardSaved = await _cardServices.saveCreditCard(uid, cardData);
      if (isCardSaved) {
        CreditCard newCard = CreditCard(
          cardHolder: cardHolder,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cvv: cvv,
        );
        _cardModels.add(newCard);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw Exception("Error saving credit card $error");
    }
  }

  Future<bool> updateCard({
    required String uid,
    required int index,
    required String cardNumber,
    required String expiryDate,
    required String cardHolder,
    required String cvv,
  }) async {
    if (index < 0 || index > _cardModels.length) {
      throw Exception("Invalid card index");
    }
    var cardData = {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolder': cardHolder,
      'cvv': cvv
    };
    try {
      var isCardUpdated =
          await _cardServices.updateCreditCard(uid, index, cardData);
      if (isCardUpdated) {
        _cardModels[index] = CreditCard(
          cardHolder: cardHolder,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cvv: cvv,
        );
        notifyListeners();
        return true;
      }
      return false;
    } catch (error) {
      throw Exception("Unable to update user card $error");
    }
  }

  Future<bool> deleteCreditCard({required uid, required index}) async {
    try {
      if (index < 0 || index > _cardModels.length) {
        throw Exception("Invalid card index");
      }
      var isCardDeleted = await _cardServices.removeCreditCard(uid, index);
      if (isCardDeleted) {
        notifyListeners();
        return true;
      }
      return false;
    } catch (error) {
      throw Exception("Unable to delete user card $error");
    }
  }
}

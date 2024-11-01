import 'package:fundora/model/creditcard.dart';
import 'package:fundora/modelview/cardviewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "dart:math" as math;

class CardComponent extends StatefulWidget {
  const CardComponent({super.key});

  @override
  State<CardComponent> createState() => _CardComponentState();
}

class _CardComponentState extends State<CardComponent> {
  bool showCardNumber = false;
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _cvvController = TextEditingController();
  final PageController _pageController = PageController();
  final List<Color> cardColors = [
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
  ];
  @override
  void initState() {
    super.initState();
    final cardViewModel =
        Provider.of<CreditCardViewModel>(context, listen: false);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (uid.isNotEmpty) {
      cardViewModel.getUserCard(uid);
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cardHolderController.dispose();
    _cvvController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> editCard(
      BuildContext context, int index, CreditCard card) async {
    _cardNumberController.text = card.cardNumber ?? "";
    _expiryDateController.text = card.expiryDate ?? "";
    _cardHolderController.text = card.cardHolder ?? "";
    _cvvController.text = card.cvv ?? "";

    if (_cvvController.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CVV must be 3 digits")),
      );
      return;
    }

    try {
      final cardViewModel =
          Provider.of<CreditCardViewModel>(context, listen: false);
      bool success = await cardViewModel.saveCreditCard(
        uid: FirebaseAuth.instance.currentUser!.uid,
        cardNumber: _cardNumberController.text,
        expiryDate: _expiryDateController.text,
        cardHolder: _cardHolderController.text,
        cvv: _cvvController.text,
      );
      if (success) {
        if (context.mounted) Navigator.of(context).pop();
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to save card")),
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving card: $error")),
        );
      }
    }
  }

  void showEditCardDialog(BuildContext context, int index, CreditCard card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Credit Card'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(labelText: "Card Number"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(labelText: "Expiry Date"),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: _cardHolderController,
                  decoration: const InputDecoration(labelText: "Card Holder"),
                ),
                TextField(
                  controller: _cvvController,
                  decoration: const InputDecoration(labelText: "CVV"),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await editCard(context, index, card);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreditCardViewModel>(
      builder: (context, creditCardViewModel, child) {
        final cards = creditCardViewModel.cardModel;
        if (cards.isEmpty) {
          return Center(child: Text("No credit cards found."));
        }
        return SizedBox(
          height: 280,
          child: PageView.builder(
            controller: _pageController,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              final cardColor = cardColors[index % cardColors.length];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 280,
                      width: Curves.easeOut.transform(value) * 400,
                      child: child,
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showCardNumber = !showCardNumber;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: buildCardContent(card, index),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildCardContent(CreditCard card, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.credit_card_rounded,
                color: Colors.white, size: 40),
            const Text(
              'VISA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Card Number
        Text(
          showCardNumber
              ? card.cardNumber ?? "**** **** **** 1234"
              : '**** **** ****',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 20),
        // Card Details
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Card Holder
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CARD HOLDER',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  card.cardHolder ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            // Expiry Date and Edit Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'EXPIRES',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  card.expiryDate ?? "XX/XX",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

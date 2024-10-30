import 'package:expense_tracker/modelview/cardviewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardComponent extends StatefulWidget {
  const CardComponent({super.key});

  @override
  State<CardComponent> createState() => _CardComponentState();
}

class _CardComponentState extends State<CardComponent> {
  bool showCardNumber = false;
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cardHolderController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final cardViewModel =
        Provider.of<CreditCardViewModel>(context, listen: false);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    cardViewModel.getUserCard(uid);
  }

  @override
  Widget build(BuildContext context) {
    final cardViewModel =
        Provider.of<CreditCardViewModel>(context, listen: false);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    Future<void> editCard() async {
      try {
        bool success = await cardViewModel.saveCardOrUpdateCard(
          uid,
          cardNumberController.text,
          expiryDateController.text,
          cardHolderController.text,
          cvvController.text,
        );
        if (success) {
          if (context.mounted) Navigator.of(context).pop();
        }
      } catch (error) {
        throw Exception("Error saving card: $error");
      }
    }

    void showEditCardDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Credit Card'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: cardNumberController,
                    decoration: const InputDecoration(labelText: "Card Number"),
                  ),
                  TextField(
                    controller: expiryDateController,
                    decoration: const InputDecoration(labelText: "Expiry Date"),
                  ),
                  TextField(
                    controller: cardHolderController,
                    decoration: const InputDecoration(labelText: "Card Holder"),
                  ),
                  TextField(
                    controller: cvvController,
                    decoration: const InputDecoration(labelText: "CVV"),
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
              TextButton(
                onPressed: () async {
                  await editCard();
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    }

    return Consumer<CreditCardViewModel>(
      builder: (context, creditCardViewModel, child) {
        return Container(
          height: 250,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1E3C72),
                      Color(0xFF2A5298),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    GestureDetector(
                      onTap: () =>
                          setState(() => showCardNumber = !showCardNumber),
                      child: Text(
                        showCardNumber
                            ? creditCardViewModel.cardNumber
                            : '**** **** **** 1234',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                              creditCardViewModel.cardHolder,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
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
                              creditCardViewModel.expiryDate,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              onPressed: () {
                                showEditCardDialog();
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

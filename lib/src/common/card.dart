import 'package:fundora/src/model/creditcard.dart';
import 'package:fundora/src/modelview/cardviewmodel.dart';
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
  final PageController _pageController = PageController();
  final List<Color> cardColors = [
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
    Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
  ];

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (!showCardNumber) {
                      return Colors.white10;
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.black12;
                    }
                    return Colors.black12;
                  },
                ),
              ),
              onPressed: () {
                setState(
                  () {
                    showCardNumber = !showCardNumber;
                  },
                );
              },
              child: Icon(Icons.remove_red_eye_outlined),
            ),
          ],
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

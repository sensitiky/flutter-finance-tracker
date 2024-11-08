import 'package:flutter/material.dart';
import 'package:fundora/common/card.dart';
import 'package:provider/provider.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, cardViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Payment Methods"),
          ),
          body: Column(
            children: [
              CardComponent(),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Icon(Icons.send, color: Colors.blue),
                          Text("Send Money"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Icon(Icons.payment, color: Colors.green),
                          Text("Make Payment"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Icon(Icons.more_horiz, color: Colors.purple),
                          Text("More Options"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Disclaimer",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "To make use of this credit card, you must be the real owner. We do not possess the ability to let you use another person's credit card.",
                        textAlign: TextAlign.center,
                      ),
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

import 'package:flutter/material.dart';
import 'package:fundora/src/view/dashboard/dashboard.dart';
import 'package:provider/provider.dart';

class SpendingTips extends StatelessWidget {
  const SpendingTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataAnalyzer>(
      builder: (context, analyzer, child) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Spending Improvement Tips',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ...analyzer.tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )),
                if (analyzer.tips.isEmpty)
                  const Text(
                    'Great job! Your spending is optimized.',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

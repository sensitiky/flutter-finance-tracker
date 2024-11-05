import 'package:fundora/src/common/card.dart';
import 'package:flutter/material.dart';
import 'package:fundora/src/model/expenseCategory.dart';
import 'package:fundora/src/modelview/themeviewmodel.dart';
import 'package:provider/provider.dart';
import 'package:fundora/src/modelview/userviewmodel.dart';
import 'components/spendingTips.dart';
import 'components/spendingTrends.dart';
import 'components/expenseOverview.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return ChangeNotifierProvider(
          create: (_) => DataAnalyzer(),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Dashboard"),
            ),
            body: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: DashboardContent(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Themeviewmodel>(
      builder: (context, themeViewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CardComponent(),
            const SizedBox(height: 20),
            const ExpenseOverview(),
            const SizedBox(height: 20),
            const SpendingTrends(),
            const SizedBox(height: 20),
            const SpendingTips(),
          ],
        );
      },
    );
  }
}

class DataAnalyzer with ChangeNotifier {
  double mainIncome = 5000.0; // MOCKUP income
  List<ExpenseCategory> expenses = [
    ExpenseCategory(title: 'Housing', amount: 1750.0, color: Colors.blue),
    ExpenseCategory(title: 'Food', amount: 1250.0, color: Colors.green),
    ExpenseCategory(title: 'Transport', amount: 1000.0, color: Colors.orange),
    ExpenseCategory(
        title: 'Entertainment', amount: 500.0, color: Colors.purple),
  ];

  double predictedIncome = 0.0;
  List<String> tips = [];

  DataAnalyzer() {
    analyzeData();
  }

  void analyzeData() {
    double totalExpenses = expenses.fold(0.0, (sum, item) => sum + item.amount);
    predictedIncome = mainIncome - totalExpenses;

    tips = [];

    for (var expense in expenses) {
      if (expense.title.toLowerCase() == 'entertainment' ||
          expense.title.toLowerCase() == 'cinema' ||
          expense.title.toLowerCase() == 'ocio') {
        tips.add(
            'Consider reducing your spending on ${expense.title.toLowerCase()} to save more.');
      }
    }

    notifyListeners();
  }

  void updateMainIncome(double income) {
    mainIncome = income;
    analyzeData();
  }

  void updateExpenses(List<ExpenseCategory> newExpenses) {
    expenses = newExpenses;
    analyzeData();
  }
}

class PredictedIncome extends StatelessWidget {
  const PredictedIncome({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataAnalyzer>(
      builder: (context, analyzer, child) {
        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Predicted Income',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Main Income: \$${analyzer.mainIncome.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Expenses: \$${analyzer.expenses.fold(0.0, (sum, item) => sum + item.amount).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  'Predicted Remaining Income: \$${analyzer.predictedIncome.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: analyzer.predictedIncome >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showIncomeInputDialog(context, analyzer);
                  },
                  child: const Text('Update Main Income'),
                ),
              ],
            ),
          ),
        ]);
      },
    );
  }

  void _showIncomeInputDialog(BuildContext context, DataAnalyzer analyzer) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Main Income'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: 'Enter your main income'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                double? income = double.tryParse(controller.text);
                if (income != null) {
                  analyzer.updateMainIncome(income);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

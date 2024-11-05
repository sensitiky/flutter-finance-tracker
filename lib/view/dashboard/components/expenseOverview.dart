import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fundora/model/expenseCategory.dart';
import 'package:fundora/view/dashboard/dashboard.dart';
import 'package:provider/provider.dart';

class ExpenseOverview extends StatelessWidget {
  const ExpenseOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final dataAnalyzer = Provider.of<DataAnalyzer>(context, listen: false);
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white10
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Expenses Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: dataAnalyzer.expenses.map((expense) {
                    return PieChartSectionData(
                      value: expense.amount,
                      title:
                          '${(expense.amount / dataAnalyzer.expenses.fold(0.0, (sum, item) => sum + item.amount) * 100).toStringAsFixed(0)}%',
                      color: expense.color,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(dataAnalyzer.expenses),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(List<ExpenseCategory> categories) {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      children: categories.map((category) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${category.title} (${(category.amount).toStringAsFixed(0)})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}

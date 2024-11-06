import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fundora/modelview/themeviewmodel.dart';
import 'package:fundora/view/dashboard/dashboard.dart';
import 'package:provider/provider.dart';

class SpendingTrends extends StatelessWidget {
  const SpendingTrends({super.key});

  @override
  Widget build(BuildContext context) {
//    final dataAnalyzer = Provider.of<DataAnalyzer>(context, listen: false);
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
              'Spending Trends',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun'
                          ];
                          if (value.toInt() < 0 ||
                              value.toInt() >= months.length) {
                            return const Text('');
                          }
                          return Text(
                            months[value.toInt()],
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1000),
                        FlSpot(1, 1200),
                        FlSpot(2, 1100),
                        FlSpot(3, 1400),
                        FlSpot(4, 1300),
                        FlSpot(5, 1500),
                      ],
                      isCurved: true,
                      color: Colors.purple.shade300,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color.fromARGB(255, 46, 24, 238)
                            .withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  title: 'Average Spending',
                  value: '\$1,250',
                  trend: '+12%',
                  isPositive: false,
                ),
                SizedBox(height: 20),
                _buildStatCard(
                  title: 'Total Saved',
                  value: '\$3,500',
                  trend: '+23%',
                  isPositive: true,
                ),
              ],
            ),
            const PredictedIncome(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
  }) {
    return Consumer<Themeviewmodel>(
      builder: (context, themeViewModel, child) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: themeViewModel.isDarkMode
                ? Colors.white10
                : Colors.purple.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: themeViewModel.isDarkMode
                      ? Colors.white
                      : Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 14,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  Text(
                    trend,
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

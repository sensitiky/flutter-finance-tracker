import 'package:fundora/components/card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fundora/modelview/userviewmodel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Dashboard"),
          ),
          body: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CardComponent(),
                SizedBox(height: 20),
                ExpenseOverview(),
                SizedBox(height: 20),
                SpendingTrends(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExpenseOverview extends StatelessWidget {
  const ExpenseOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
                  sections: [
                    PieChartSectionData(
                      value: 35,
                      title: 'Housing',
                      color: Colors.blue,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 25,
                      title: 'Food',
                      color: Colors.green,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: 'Transport',
                      color: Colors.orange,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: 'Other',
                      color: Colors.purple,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final categories = [
      {'title': 'Housing', 'color': Colors.blue, 'percentage': '35%'},
      {'title': 'Food', 'color': Colors.green, 'percentage': '25%'},
      {'title': 'Transport', 'color': Colors.orange, 'percentage': '20%'},
      {'title': 'Other', 'color': Colors.purple, 'percentage': '20%'},
    ];

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
                color: category['color'] as Color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${category['title']} (${category['percentage']})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class SpendingTrends extends StatelessWidget {
  const SpendingTrends({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  title: 'Average Spending',
                  value: '\$1,250',
                  trend: '+12%',
                  isPositive: false,
                ),
                _buildStatCard(
                  title: 'Total Saved',
                  value: '\$3,500',
                  trend: '+23%',
                  isPositive: true,
                ),
              ],
            ),
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
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
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
  }
}

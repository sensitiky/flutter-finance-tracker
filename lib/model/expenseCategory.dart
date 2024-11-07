import 'package:flutter/material.dart';

class ExpenseCategory {
  final num id;
  final String title;
  final double amount;
  final Color color;

  ExpenseCategory({
    required this.id,
    required this.title,
    required this.amount,
    required this.color,
  });
}

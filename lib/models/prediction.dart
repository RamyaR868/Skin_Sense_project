import 'package:flutter/material.dart';

class Prediction {
  final String label;
  final double confidence;
  final DateTime timestamp;

  Prediction({
    required this.label,
    required this.confidence,
    required this.timestamp,
  });

  // Helper to determine the "Danger Level" UI color
  Color get statusColor {
    if (confidence > 0.8 && label.toLowerCase() != 'benign') {
      return Colors.redAccent;
    } else if (confidence > 0.5) {
      return Colors.orangeAccent;
    }
    return Colors.greenAccent;
  }
}

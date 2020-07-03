import 'package:flutter/material.dart';

String calculateGrowthPercentage(int newData, int previousData ) {
  var growthPercentage = ((newData - previousData) / previousData) * 100;
  return growthPercentage.isInfinite || growthPercentage.isNaN
      ? '0.0'
      : growthPercentage.toStringAsFixed(2);
}

Icon showGrowthIcon(int currentData, int previousData, bool isRecovered) {
  Icon icon;
  if (currentData > previousData) {
    icon = Icon(
      Icons.arrow_upward,
      color: isRecovered ? Colors.green : Colors.red,
    );
  } else {
    icon = Icon(
      Icons.arrow_downward,
      color: isRecovered ? Colors.red : Colors.green,
    );
  }
  return icon;
}

Color showGrowthColor(int currentData, int previousData) {
  Color color;
  if (currentData > previousData) {
    color = Colors.green;
  } else {
    color = Colors.red;
  }
  return color;
}

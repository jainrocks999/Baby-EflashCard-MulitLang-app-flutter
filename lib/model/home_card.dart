import 'package:flutter/material.dart';

class HomeCardData {
  final String imagePath;
  final String title;
  final Color cardBg;
  final Color? btnBg;
  final String category;

  HomeCardData({
    required this.imagePath,
    required this.title,
    required this.cardBg,
    this.btnBg,
    required this.category,
  });
}

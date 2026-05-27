// import 'dart:math';

import 'package:eflash_multilagnuage_upgrade/screens/setting/settings_screen.dart';
import 'package:flutter/material.dart';

class AppHelpers {
  static void showSettingModal(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SettingsScreen(),
    );
  }

  static String getLanguageFolder(String langName) {
    switch (langName.toLowerCase()) {
      case 'fre/fra':
        return 'french';
      case 'de':
        return 'german';
      case 'it':
        return 'italian';
      case 'es':
        return 'spanish';
      case 'en':
        return 'english';
      default:
        return 'japanies';
    }
  }

  static String getModifiedImgName({
    required String image,
    required String langName,
  }) {
    final folder = getLanguageFolder(langName);

    String suffix = '';
    switch (folder) {
      case 'italian':
        suffix = '_it';
        break;
      case 'spanish':
        suffix = '_es';
        break;
      case 'japanies':
        suffix = '_jap';
        break;
    }
    final parts = image.split('.');
    if (parts.length < 2) return image;

    final name = parts.first;
    final ext = parts.last;
    return '$name$suffix.$ext';
  }

  static String getCount(String key, Map<String, int> counts) {
    final value = counts[key] ?? 0;
    return "Total $value Items";
  }

  // static List<Map<String, dynamic>> getRandomItems(
  //     List<Map<String, dynamic>> data,
  //     Set<int> usedIndexes, {
  //     int count = 4,
  //   }) {
  //     final available = List.generate(
  //       data.length,
  //       (i) => i,
  //     ).where((i) => !usedIndexes.contains(i)).toList();

  //     available.shuffle();
  //     final picked = available.take(count).toList();
  //     usedIndexes.addAll(picked);

  //     return picked.map((i) => data[i]).toList();
  //   }

  static List<Map<String, dynamic>> getRandomItems(
    List<Map<String, dynamic>> data,
    Set<int> usedQuestionIndexes, {
    int count = 4,
  }) {
    //pick available questions
    final availableQuestions = List.generate(
      data.length,
      (i) => i,
    ).where((i) => !usedQuestionIndexes.contains(i)).toList();

    // reset if all used
    if (availableQuestions.isEmpty) {
      usedQuestionIndexes.clear();
      return getRandomItems(data, usedQuestionIndexes, count: count);
    }

    availableQuestions.shuffle();
    final questionIndex = availableQuestions.first;
    usedQuestionIndexes.add(questionIndex);

    final otherIndexes = List.generate(data.length, (i) => i)
      ..remove(questionIndex);

    otherIndexes.shuffle();
    final options = otherIndexes.take(count - 1).toList();

    final result = [questionIndex, ...options]..shuffle();

    return result.map((i) => data[i]).toList();
  }
}

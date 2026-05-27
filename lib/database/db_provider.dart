import 'package:eflash_multilagnuage_upgrade/database/db_repository.dart';
import 'package:eflash_multilagnuage_upgrade/services/secure_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';

final dbProvider = StateNotifierProvider<DbNotifier, DbState>(
  (ref) => DbNotifier(DbRepository()),
);

class DbState {
  final bool isLoading;
  final String? message;
  final bool isSuccess;
  final List<Map<String, dynamic>> data;
  final String? language;
  final Map<String, int> categoryCounts;
  final bool questionMode;
  final bool isSoundOn;
  final bool isMusicOn;
  final bool isShowLangTxt;
  final bool isSwpieOn;

  const DbState({
    this.isLoading = false,
    this.message,
    this.isSuccess = false,
    this.data = const [],
    this.language,
    this.categoryCounts = const {},
    this.questionMode = false,
    this.isSoundOn = false,
    this.isMusicOn = false,
    this.isShowLangTxt = false,
    this.isSwpieOn = false,
  });

  DbState copyWith({
    bool? isLoading,
    String? message,
    bool? isSuccess,
    List<Map<String, dynamic>>? data,
    String? language,
    Map<String, int>? categoryCounts,
    bool? questionMode,
    bool? isSoundOn,
    bool? isMusicOn,
    bool? isShowLangTxt,
    bool? isSwpieOn,
  }) {
    return DbState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      language: language ?? this.language,
      categoryCounts: categoryCounts ?? this.categoryCounts,
      questionMode: questionMode ?? this.questionMode,
      isSoundOn: isSoundOn ?? this.isSoundOn,
      isMusicOn: isMusicOn ?? this.isMusicOn,
      isShowLangTxt: isShowLangTxt ?? this.isShowLangTxt,
      isSwpieOn: isSwpieOn ?? this.isSwpieOn,
    );
  }
}

class DbNotifier extends StateNotifier<DbState> {
  final DbRepository repository;
  DbNotifier(this.repository) : super(const DbState());

  ///clear the state
  void clearData() {
    state = state.copyWith(
      data: [],
      isLoading: false,
      message: null,
      isSuccess: false,
    );
  }

  Future<void> loadLanguage() async {
    try {
      String? lang = await SecureStorage.getLang();
      state = state.copyWith(language: lang);
    } catch (e) {
      debugPrint("Error loading language: $e");
    }
  }

  Future<void> loadQuestionMode() async {
    try {
      final value = await SecureStorage.getQuesMode();

      state = state.copyWith(questionMode: value);
    } catch (e) {
      state = state.copyWith(message: e.toString());
    }
  }

  Future<void> loadSoundAndLangSettings() async {
    try {
      final valueMusic = await SecureStorage.getMusic();
      final valueSound = await SecureStorage.getSound();
      final valueLangTxt = await SecureStorage.getLangText();
      final valueSwipe = await SecureStorage.getSwipe();
      state = state.copyWith(
        isMusicOn: valueMusic,
        isSoundOn: valueSound,
        isShowLangTxt: valueLangTxt,
        isSwpieOn:valueSwipe
      );
    } catch (e) {
      state = state.copyWith(message: e.toString());
    }
  }

  Future<void> fetchData({
    String? tableName,
    String? category,
    bool random = false,
    int limit = 0,
  }) async {
    // state = state.copyWith(isLoading: true, message: null);
    state = state.copyWith(
      isLoading: true,
      message: null,
      data: [],
      isSuccess: false,
    );

    try {
      String? storedLang = await SecureStorage.getLang();
      if (storedLang == null || storedLang.isEmpty) {
        storedLang = 'tbl_items'; // default English
        await SecureStorage.setLang(storedLang);
      }
      final result = await repository.fetchData(
        tableName: storedLang,
        category: category,
        random: random,
        limit: limit,
      );
      // print('venom $result');
      state = state.copyWith(isLoading: false, data: result, isSuccess: true);
    } catch (e) {
      debugPrint('error of Fetch Data $e');
      state = state.copyWith(
        isLoading: false,
        message: e.toString(),
        isSuccess: false,
      );
    }
  }

  Future<void> loadCateCounts() async {
    try {
      final tableName = state.language ?? 'tbl_items';
      state = state.copyWith(isLoading: true);

      final result = await repository.getCategoryCounts(tableName: tableName);
      state = state.copyWith(
        isLoading: false,
        categoryCounts: result,
        isSuccess: true,
      );
    } catch (e) {
      debugPrint('error of cate Count $e');
      state = state.copyWith(
        isLoading: false,
        message: e.toString(),
        isSuccess: false,
      );
    }
  }
}

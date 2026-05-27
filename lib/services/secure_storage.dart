import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const langKey = 'LANG';
  static const quesModeKey = 'QUESMODE';
  static const musicKey = 'MUSIC';
  static const soundKey = 'SOUND';
  static const swipeKey = 'SWIPE';
  static const showLangTextKey = 'LANGTEXT';

  static Future<void> setLang(String lang) async {
    await _storage.write(key: langKey, value: lang);
  }

  static Future<void> setQuestionMode(bool value) async {
    await _storage.write(key: quesModeKey, value: value.toString());
  }

  static Future<void> setMusic(bool value) async {
    await _storage.write(key: musicKey, value: value.toString());
  }

  static Future<void> setSound(bool value) async {
    await _storage.write(key: soundKey, value: value.toString());
  }

  static Future<void> setSwipe(bool value) async {
    await _storage.write(key: swipeKey, value: value.toString());
  }

  static Future<void> setLangText(bool value) async {
    await _storage.write(key: showLangTextKey, value: value.toString());
  }

  static Future<String?> getLang() async {
    return _storage.read(key: langKey);
  }

  static Future<bool> getQuesMode() async {
    final value = await _storage.read(key: quesModeKey);
    return value == null ? false : value == 'true';
  }

  static Future<bool> getMusic() async {
    final value = await _storage.read(key: musicKey);
    return value == null ? true : value == 'true';
  }

  static Future<bool> getSound() async {
    final value = await _storage.read(key: soundKey);
    return value == null ? true : value == 'true';
  }

  static Future<bool> getSwipe() async {
    final value = await _storage.read(key: swipeKey);
    return value == null ? true : value == 'true';
  }

  static Future<bool> getLangText() async {
    final value = await _storage.read(key: showLangTextKey);
    return value == null ? true : value == 'true';
  }
}

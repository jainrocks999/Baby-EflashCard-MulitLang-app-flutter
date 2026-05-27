import 'package:eflash_multilagnuage_upgrade/database/db_provider.dart';
import 'package:eflash_multilagnuage_upgrade/screens/setting/settings_screen.dart';
import 'package:eflash_multilagnuage_upgrade/services/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSelectionModal extends ConsumerStatefulWidget {
  final String selectedLanguage;

  const LanguageSelectionModal({super.key, required this.selectedLanguage});

  @override
  ConsumerState<LanguageSelectionModal> createState() =>
      _LanguageSelectionModalState();
}

class _LanguageSelectionModalState
    extends ConsumerState<LanguageSelectionModal> {
  late String currentLang;

  final List<Map<String, String>> languages = [
    {'label': 'English', 'value': 'tbl_items'},
    {'label': 'French', 'value': 'tbl_french'},
    {'label': 'Italian', 'value': 'tbl_italian'},
    {'label': 'Japanese', 'value': 'tbl_japanies'},
    {'label': 'Spanish', 'value': 'tbl_spanish'},
  ];

  @override
  void initState() {
    super.initState();
    currentLang = widget.selectedLanguage.isEmpty
        ? 'tbl_items'
        : widget.selectedLanguage;
  }

  Future<void> _saveLanguage() async {
    await SecureStorage.setLang(currentLang);
    await ref.read(dbProvider.notifier).loadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await _saveLanguage();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFF4C77D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              "Select Language".toUpperCase(),
               style:  const TextStyle(
                    fontSize: 18,
                    fontFamily: "Fredoka",
                    fontWeight: FontWeight.w700,
                    color: Color(0xff825c2f),
                  ),
            ),
            const SizedBox(height: 16),

            ...languages.map((lang) {
              return _buildLanguageItem(
                label: lang['label']!,
                value: lang['value']!,
              );
            }),

            const SizedBox(height: 16),

             CommonButton(
                    text: "Done",
                    onPressed: ()async {
                       await _saveLanguage();
                      Navigator.pop(context);
                    },
                    backgroundColor: Color(0xff3ed043),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageItem({required String label, required String value}) {
    final bool isSelected = value == currentLang;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentLang = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.language),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Fredoka',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                size: 35,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
}

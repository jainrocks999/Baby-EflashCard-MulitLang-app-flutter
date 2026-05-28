import 'package:baby_flash_apps/core/utils/responsive.dart';
import 'package:baby_flash_apps/database/db_provider.dart';
import 'package:baby_flash_apps/services/secure_storage.dart';
import 'package:baby_flash_apps/widgets/custom_switch.dart';
import 'package:baby_flash_apps/widgets/setting_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool questionMode = false;
  bool music = false;
  bool sound = false;
  bool randomOrder = false;
  bool swipe = false;
  bool languageText = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final questionModeValue = await SecureStorage.getQuesMode();
    final musicValue = await SecureStorage.getMusic();
    final soundValue = await SecureStorage.getSound();
    final swipeValue = await SecureStorage.getSwipe();
    final languageTextValue = await SecureStorage.getLangText();

    setState(() {
      questionMode = questionModeValue;
      music = musicValue;
      sound = soundValue;
      swipe = swipeValue;
      languageText = languageTextValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ResponsiveUtils.isTablet(context);

    return Consumer(
      builder: (context, ref, child) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              Future.microtask(() async {
                await ref.read(dbProvider.notifier).loadSoundAndLangSettings();
              });
            }
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xfff7cd89),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: ResponsiveUtils.height(context, isTablet?1:0.2),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Icon(Icons.settings, color: Color(0xff825c2f), size:ResponsiveUtils.width(context, isTablet?5:6)),
                        Text(
                          'Setting'.toUpperCase(),
                          style: TextStyle(
                            fontSize: ResponsiveUtils.fontSize(
                              context,
                              isTablet ? 6 : 7.5,
                            ),
                            fontFamily: "Fredoka",
                            fontWeight: FontWeight.w700,
                            color: Color(0xff825c2f),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ResponsiveUtils.height(
                        context,
                        isTablet ? 0.5 : 0.5,
                      ),
                    ),
                    SettingContainer(
                      child: Column(
                        children: [
                          _RowDropdown(questionMode: questionMode),
                
                          Opacity(
                            opacity: questionMode ? 0.5 : 1,
                            child: _SwitchRow(
                              icon: Icons.subtitles,
                              title: "Language Text",
                              value: languageText,
                              onChanged: questionMode
                                  ? null
                                  : (val) async {
                                      setState(() => languageText = val);
                                      await SecureStorage.setLangText(val);
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SettingContainer(
                      child: Column(
                        spacing: 15,
                        children: [
                          _SwitchRow(
                            icon: Icons.music_note_rounded,
                            title: "Music",
                            value: music,
                            onChanged: (val) async {
                              setState(() => music = val);
                              await SecureStorage.setMusic(val);
                            },
                          ),
                          _SwitchRow(
                            icon: Icons.graphic_eq_rounded,
                            title: "Sound",
                            value: sound,
                
                            onChanged: (val) async {
                              setState(() => sound = val);
                              await SecureStorage.setSound(val);
                            },
                          ),
                        ],
                      ),
                    ),
                    SettingContainer(
                      child: Column(
                        spacing: 15,
                        children: [
                          _SwitchRow(
                            title: "Question mode",
                            value: questionMode,
                            onChanged: (val) async {
                              setState(() => questionMode = val);
                              await SecureStorage.setQuestionMode(val);
                              await SecureStorage.setSwipe(false);
                              ref.read(dbProvider.notifier).loadQuestionMode();
                            },
                          ),
                
                          Opacity(
                            opacity: questionMode ? 0.5 : 1,
                            child: _SwitchRow(
                              icon: Icons.swipe,
                              title: "Swipe",
                              value: swipe,
                              onChanged: questionMode
                                  ? null
                                  : (val) async {
                                      setState(() => swipe = val);
                                      await SecureStorage.setSwipe(val);
                                    },
                            ),
                          ),
                
                          Opacity(
                            opacity: questionMode ? 0.5 : 1,
                            child: _SwitchRow(
                              icon: Icons.shuffle_rounded,
                              title: "Random Order",
                              value: randomOrder,
                              onChanged: questionMode
                                  ? null
                                  : (val) {
                                      setState(() => randomOrder = val);
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        Expanded(
                          child: CommonButton(
                            text: "Close",
                            onPressed: () async {
                              await ref
                                  .read(dbProvider.notifier)
                                  .loadSoundAndLangSettings();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RowDropdown extends ConsumerStatefulWidget {
  final bool questionMode;
  const _RowDropdown({required this.questionMode});

  @override
  ConsumerState<_RowDropdown> createState() => _RowDropdownState();
}

class _RowDropdownState extends ConsumerState<_RowDropdown> {
  final List<Map<String, String>> languages = [
    {'label': 'English', 'value': 'tbl_items'},
    {'label': 'French', 'value': 'tbl_french'},
    {'label': 'Italian', 'value': 'tbl_italian'},
    {'label': 'Japanese', 'value': 'tbl_japanies'}, //(tbl_japanese) fixed typo
    {'label': 'Spanish', 'value': 'tbl_spanish'},
  ];

  Future<void> _onLanChanged(String newValue) async {
    await SecureStorage.setLang(newValue);
    await ref.read(dbProvider.notifier).loadLanguage();
  }

  Future<void> _forceEnglish() async {
    await SecureStorage.setLang("tbl_items");
    await ref.read(dbProvider.notifier).loadLanguage();
  }

  @override
  void didUpdateWidget(covariant _RowDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.questionMode && !oldWidget.questionMode) {
      _forceEnglish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ResponsiveUtils.isTablet(context);
    final state = ref.watch(dbProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(Icons.translate_rounded, size: ResponsiveUtils.fontSize(context, isTablet ? 3.8 : 5)),
            Text(
              "Language",
              style: TextStyle(
                // fontSize: 18,
                fontSize: ResponsiveUtils.fontSize(context, isTablet ? 3.8 : 5),
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        DropdownButton<String>(
          value: state.language,
          underline: const SizedBox(),
          icon: Icon(Icons.keyboard_arrow_down,size: ResponsiveUtils.width(context, isTablet?3.5:4.8),),
          dropdownColor: Color(0xfff7cd89),
          borderRadius: BorderRadius.circular(20),
          style: TextStyle(
            color: widget.questionMode ? Colors.grey : Colors.black,
            // fontSize: 16,
            fontSize: ResponsiveUtils.fontSize(context, isTablet ? 3.5 : 4.7),
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w500,
          ),
          onChanged: widget.questionMode
              ? null
              : (String? newValue) {
                  if (newValue != null) {
                    _onLanChanged(newValue);
                  }
                },
          items: languages.map((lang) {
            return DropdownMenuItem<String>(
              value: lang['value'],
              child: Text(lang['label']!),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool value;
  final Function(bool)? onChanged;

  const _SwitchRow({
    this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ResponsiveUtils.isTablet(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 5,
          children: [
            icon != null ? Icon(icon, size: ResponsiveUtils.width(context, isTablet?3.5:4.8)) : SizedBox(),
            Text(
              title,
              style: TextStyle(
                // fontSize: 18,
                fontSize: ResponsiveUtils.fontSize(context, isTablet ? 3.8 : 5),
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        CustomSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final double borderRadius;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.red,
    this.borderRadius = 12,
    this.fontSize = 18,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, color: Colors.white)
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 10,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: const BorderSide(color: Colors.white, width: 3),
          ),
        ),
      ),
    );
  }
}

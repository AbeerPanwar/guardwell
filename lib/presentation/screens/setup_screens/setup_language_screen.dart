import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const LanguageSelectionScreen({super.key, this.isFirstLaunch = false});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  var _isSelected = false;

  Future<void> _selectLanguage(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('languageSelected', true);

    if (widget.isFirstLaunch) {
      _isSelected = true;
    } else {
      Navigator.pop(context); // from settings page
    }
  }

  @override
  Widget build(BuildContext context) {
    final languages = {
      'English': const Locale('en'),
      'हिन्दी (Hindi)': const Locale('hi'),
      'বাংলা (Bengali)': const Locale('bn'),
      'தமிழ் (Tamil)': const Locale('ta'),
      'తెలుగు (Telugu)': const Locale('te'),
      'मराठी (Marathi)': const Locale('mr'),
      'ગુજરાતી (Gujarati)': const Locale('gu'),
      'ಕನ್ನಡ (Kannada)': const Locale('kn'),
      'മലയാളം (Malayalam)': const Locale('ml'),
      'ਪੰਜਾਬੀ (Punjabi)': const Locale('pa'),
      'اردو (Urdu)': const Locale('ur'),
    };

    return Scaffold(
      appBar: widget.isFirstLaunch ? null : AppBar(title: Text('language'.tr())),
      body: ListView(
        children: languages.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            trailing: context.locale == entry.value
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () => _selectLanguage(context, entry.value),
          );
        }).toList(),
      ),
      bottomNavigationBar: widget.isFirstLaunch ? null : Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green.shade100),
            ),
            onPressed: !_isSelected
                ? null
                : (){Navigator.pop(context);},
            child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
    );
  }
}

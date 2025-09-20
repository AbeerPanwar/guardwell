import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:guardwell/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFirstLaunch;

  const LanguageSelectionScreen({super.key, this.isFirstLaunch = false});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale? _selectedLocale;

  Future<void> _saveLanguage(Locale locale) async {
    await context.setLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('languageSelected', true);
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
      appBar: widget.isFirstLaunch
          ? AppBar(
              title: Text(
                'language'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                  fontSize: 25,
                ),
              ),
              backgroundColor: Colors.green.shade100,
            )
          : AppBar(
              title: Text(
                'language'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.transparent,
              leadingWidth: 70,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
                  ),
                  elevation: 0.5,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: ListView(
          children: languages.entries.map((entry) {
            final isSelected = _selectedLocale == entry.value;
            return ListTile(
              title: Text(
                entry.key,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                setState(() {
                  _selectedLocale = entry.value;
                });
              },
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              _selectedLocale == null
                  ? Colors.grey.shade300
                  : Colors.green.shade100,
            ),
          ),
          onPressed: _selectedLocale == null
              ? null
              : () async {
                  await _saveLanguage(_selectedLocale!);
                  if (widget.isFirstLaunch) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const AppInitializer()),
                      (route) => false,
                    );
                  } else {
                    Navigator.pop(context); // from settings
                  }
                },
          child: Text(
            'Continue',
            style: TextStyle(
              color: _selectedLocale == null
                  ? Colors.grey.shade600
                  : Colors.green.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

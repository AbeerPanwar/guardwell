import 'package:flutter/material.dart';
import 'package:guardwell/presentation/screens/setup_screens/setup_language_screen.dart';

class LanguageManagementScreen extends StatelessWidget {
  const LanguageManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LanguageSelectionScreen(isFirstLaunch: false);
  }
}

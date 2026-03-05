import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;

  // --- លំនាំ (Pattern) សម្រាប់ពាក្យបកប្រែ ---
static const Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'profile': 'Profile',
    'acc_settings': 'Account Settings',
    'edit_profile': 'Edit Profile',
    'my_purchases': 'My Purchases',
    'notifications': 'Notifications',
    'preferences': 'Preferences',
    'language': 'Language',
    'dark_mode': 'Dark Mode',
    'select_lang': 'Select Language',
    'khmer': 'Khmer',
    'english': 'English',
  },
  'km': {
    'profile': 'ប្រវត្តិរូប',
    'acc_settings': 'ការកំណត់គណនី',
    'edit_profile': 'កែសម្រួលព័ត៌មាន',
    'my_purchases': 'ការទិញរបស់ខ្ញុំ',
    'notifications': 'ការជូនដំណឹង',
    'preferences': 'ចំណូលចិត្ត',
    'language': 'ភាសា',
    'dark_mode': 'មុខងារងងឹត',
    'select_lang': 'ជ្រើសរើសភាសា',
    'khmer': 'ខ្មែរ',
    'english': 'អង់គ្លេស',
  },
};

String translate(String key) {
  return _localizedValues[_currentLocale.languageCode]?[key] ?? key;
}

  void changeLanguage(String type) {
    _currentLocale = Locale(type);
    notifyListeners();
  }

  bool get isKhmer => _currentLocale.languageCode == 'km';
}
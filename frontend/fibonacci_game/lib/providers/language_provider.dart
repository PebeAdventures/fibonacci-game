import 'package:flutter/foundation.dart';
import '../l10n/app_strings.dart';

/// Manages the active language of the application.
/// Toggling between 'en' (English) and 'pl' (Polish).
/// All widgets read strings via context.watch<LanguageProvider>().strings.
class LanguageProvider extends ChangeNotifier {
  String _langCode = 'en';

  String get langCode => _langCode;
  AppStrings get strings => AppStrings.of(_langCode);
  bool get isPolish => _langCode == 'pl';

  /// Switches between English and Polish.
  void toggle() {
    _langCode = _langCode == 'en' ? 'pl' : 'en';
    notifyListeners();
  }

  /// Set a specific language code ('en' or 'pl').
  void setLanguage(String code) {
    if (code == _langCode) return;
    _langCode = code;
    notifyListeners();
  }
}

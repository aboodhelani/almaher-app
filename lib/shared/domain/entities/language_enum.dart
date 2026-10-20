import '../../../core/helper/helper.dart';
import '../../../core/translations/l10n.dart';

enum LanguageEnum {
  ar, // Arabic
  en, // English
}

extension LanguageEnumExtension on LanguageEnum {
  String get local {
    switch (this) {
      case LanguageEnum.ar:
        return "ar";

      case LanguageEnum.en:
        return "en";
    }
  }

  String get langName {
    switch (this) {
      case LanguageEnum.ar:
        return S.of(Helper.navigatorKey.currentContext!).arabic;

      case LanguageEnum.en:
        return S.of(Helper.navigatorKey.currentContext!).english;
    }
  }

  static LanguageEnum valueOf(String data) {
    for (var type in LanguageEnum.values) {
      if (type.name.toLowerCase() == data.toLowerCase()) {
        return type;
      }
    }
    throw ArgumentError('$data is not a valid LanguageEnum value');
  }
}

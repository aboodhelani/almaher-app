/// The tajweed rules the bundled data marks, with their Arabic names and how
/// long each is held. Codes match `assets/quran/tajweed.json`.
enum TajweedRule {
  maddNatural(
    'n',
    TajweedCategory.madd,
    'المد الطبيعي',
    'مدّ حرف المد بلا سبب من همز أو سكون.',
    'حركتان',
  ),
  maddPermissible(
    'p',
    TajweedCategory.madd,
    'المد الجائز',
    'المد المنفصل أو العارض للسكون، يجوز فيه القصر والتوسط والإشباع.',
    '٢ أو ٤ أو ٦ حركات',
  ),
  maddObligatory(
    'o',
    TajweedCategory.madd,
    'المد الواجب المتصل',
    'حرف مد بعده همزة في الكلمة نفسها.',
    '٤ أو ٥ حركات',
  ),
  maddNecessary(
    'm',
    TajweedCategory.madd,
    'المد اللازم',
    'حرف مد بعده سكون أصلي، يُمدّ ستّ حركات لزومًا.',
    '٦ حركات',
  ),
  ghunna(
    'g',
    TajweedCategory.noon,
    'الغنة',
    'صوت يخرج من الخيشوم في النون والميم المشددتين.',
    'حركتان',
  ),
  ikhfa(
    'f',
    TajweedCategory.noon,
    'الإخفاء',
    'نطق النون الساكنة أو التنوين بين الإظهار والإدغام مع الغنة، عند حروف الإخفاء الخمسة عشر.',
    'غنة بمقدار حركتين',
  ),
  idghamWithGhunna(
    'a',
    TajweedCategory.noon,
    'الإدغام بغنة',
    'إدغام النون الساكنة أو التنوين في أحد حروف (ينمو) مع الغنة.',
    'غنة بمقدار حركتين',
  ),
  idghamWithoutGhunna(
    'u',
    TajweedCategory.noon,
    'الإدغام بغير غنة',
    'إدغام النون الساكنة أو التنوين في اللام أو الراء بلا غنة.',
    'بلا غنة',
  ),
  iqlab(
    'i',
    TajweedCategory.noon,
    'الإقلاب',
    'قلب النون الساكنة أو التنوين ميمًا مخفاة عند الباء مع الغنة.',
    'غنة بمقدار حركتين',
  ),
  ikhfaShafawi(
    'c',
    TajweedCategory.meem,
    'الإخفاء الشفوي',
    'إخفاء الميم الساكنة عند الباء مع الغنة.',
    'غنة بمقدار حركتين',
  ),
  idghamShafawi(
    'w',
    TajweedCategory.meem,
    'الإدغام الشفوي',
    'إدغام الميم الساكنة في ميم بعدها مع الغنة.',
    'غنة بمقدار حركتين',
  ),
  qalqala(
    'q',
    TajweedCategory.qalqala,
    'القلقلة',
    'اضطراب الصوت عند النطق بأحد حروف (قطب جد) ساكنًا.',
    null,
  ),
  idghamMutajanisayn(
    'd',
    TajweedCategory.idgham,
    'إدغام المتجانسين',
    'إدغام حرفين اتفقا مخرجًا واختلفا صفة، كالتاء في الطاء.',
    null,
  ),
  idghamMutaqaribayn(
    'b',
    TajweedCategory.idgham,
    'إدغام المتقاربين',
    'إدغام حرفين تقاربا مخرجًا وصفة، كاللام في الراء.',
    null,
  ),
  hamzatWasl(
    'h',
    TajweedCategory.silent,
    'همزة الوصل',
    'تُكتب ولا تُنطق عند وصل الكلام بما قبلها.',
    null,
  ),
  lamShamsiyya(
    'l',
    TajweedCategory.silent,
    'اللام الشمسية',
    'لام (ال) تُدغم في الحرف الشمسي بعدها فلا تُنطق.',
    null,
  ),
  silent(
    's',
    TajweedCategory.silent,
    'حرف لا يُنطق',
    'يُكتب في المصحف ولا يُنطق.',
    null,
  );

  final String code;
  final TajweedCategory category;
  final String nameArabic;
  final String descriptionArabic;

  /// How long it is held, if the rule has a length.
  final String? durationArabic;

  const TajweedRule(
    this.code,
    this.category,
    this.nameArabic,
    this.descriptionArabic,
    this.durationArabic,
  );

  static final Map<String, TajweedRule> _byCode = {
    for (final r in values) r.code: r,
  };

  static TajweedRule? fromCode(String code) => _byCode[code];
}

/// Groups for the colour guide, in display order.
enum TajweedCategory {
  madd('المدود'),
  noon('النون الساكنة والتنوين والغنة'),
  meem('الميم الساكنة'),
  qalqala('القلقلة'),
  idgham('الإدغام'),
  silent('ما يُكتب ولا يُنطق');

  final String nameArabic;

  const TajweedCategory(this.nameArabic);
}

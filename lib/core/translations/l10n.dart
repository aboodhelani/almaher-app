// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `الماهر`
  String get app_name {
    return Intl.message('الماهر', name: 'app_name', desc: '', args: []);
  }

  /// `اللغة`
  String get language {
    return Intl.message('اللغة', name: 'language', desc: '', args: []);
  }

  /// `العربية`
  String get arabic {
    return Intl.message('العربية', name: 'arabic', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `القرآن الكريم`
  String get quran {
    return Intl.message('القرآن الكريم', name: 'quran', desc: '', args: []);
  }

  /// `فهرس السور`
  String get surahs_index {
    return Intl.message('فهرس السور', name: 'surahs_index', desc: '', args: []);
  }

  /// `صفحة`
  String get page {
    return Intl.message('صفحة', name: 'page', desc: '', args: []);
  }

  /// `الجزء`
  String get juz {
    return Intl.message('الجزء', name: 'juz', desc: '', args: []);
  }

  /// `{count} آية`
  String ayahs_count(String count) {
    return Intl.message(
      '$count آية',
      name: 'ayahs_count',
      desc: '',
      args: [count],
    );
  }

  /// `مكية`
  String get meccan {
    return Intl.message('مكية', name: 'meccan', desc: '', args: []);
  }

  /// `مدنية`
  String get medinan {
    return Intl.message('مدنية', name: 'medinan', desc: '', args: []);
  }

  /// `تعذر تحميل المصحف`
  String get failed_to_load_quran {
    return Intl.message(
      'تعذر تحميل المصحف',
      name: 'failed_to_load_quran',
      desc: '',
      args: [],
    );
  }

  /// `إعادة المحاولة`
  String get retry {
    return Intl.message('إعادة المحاولة', name: 'retry', desc: '', args: []);
  }

  /// `الإعدادات`
  String get settings {
    return Intl.message('الإعدادات', name: 'settings', desc: '', args: []);
  }

  /// `المظهر`
  String get appearance {
    return Intl.message('المظهر', name: 'appearance', desc: '', args: []);
  }

  /// `الوضع الليلي`
  String get dark_mode {
    return Intl.message('الوضع الليلي', name: 'dark_mode', desc: '', args: []);
  }

  /// `خلفية سوداء ونص أبيض`
  String get dark_mode_subtitle {
    return Intl.message(
      'خلفية سوداء ونص أبيض',
      name: 'dark_mode_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `بحث`
  String get search {
    return Intl.message('بحث', name: 'search', desc: '', args: []);
  }

  /// `ابحث عن سورة أو آية`
  String get search_hint {
    return Intl.message(
      'ابحث عن سورة أو آية',
      name: 'search_hint',
      desc: '',
      args: [],
    );
  }

  /// `اكتب اسم سورة أو كلمات من آية.\nاكتب بالتشكيل لتظهر المطابقة التامة.`
  String get search_start_hint {
    return Intl.message(
      'اكتب اسم سورة أو كلمات من آية.\nاكتب بالتشكيل لتظهر المطابقة التامة.',
      name: 'search_start_hint',
      desc: '',
      args: [],
    );
  }

  /// `السور`
  String get search_surahs {
    return Intl.message('السور', name: 'search_surahs', desc: '', args: []);
  }

  /// `مطابقة تامة`
  String get search_full_match {
    return Intl.message(
      'مطابقة تامة',
      name: 'search_full_match',
      desc: '',
      args: [],
    );
  }

  /// `مطابقة جزئية`
  String get search_partial_match {
    return Intl.message(
      'مطابقة جزئية',
      name: 'search_partial_match',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد نتائج`
  String get search_no_results {
    return Intl.message(
      'لا توجد نتائج',
      name: 'search_no_results',
      desc: '',
      args: [],
    );
  }

  /// `تعذر البحث`
  String get search_failed {
    return Intl.message(
      'تعذر البحث',
      name: 'search_failed',
      desc: '',
      args: [],
    );
  }

  /// `كل السور`
  String get search_all_surahs {
    return Intl.message(
      'كل السور',
      name: 'search_all_surahs',
      desc: '',
      args: [],
    );
  }

  /// `رقم الآية أو كلمات منها`
  String get search_in_surah_hint {
    return Intl.message(
      'رقم الآية أو كلمات منها',
      name: 'search_in_surah_hint',
      desc: '',
      args: [],
    );
  }

  /// `اكتب رقم آية للانتقال إليها،\nأو كلمات للبحث داخل هذه السورة.`
  String get search_in_surah_start_hint {
    return Intl.message(
      'اكتب رقم آية للانتقال إليها،\nأو كلمات للبحث داخل هذه السورة.',
      name: 'search_in_surah_start_hint',
      desc: '',
      args: [],
    );
  }

  /// `الآية`
  String get search_ayah {
    return Intl.message('الآية', name: 'search_ayah', desc: '', args: []);
  }

  /// `التجويد`
  String get tajweed {
    return Intl.message('التجويد', name: 'tajweed', desc: '', args: []);
  }

  /// `تلوين أحكام التجويد`
  String get tajweed_colors {
    return Intl.message(
      'تلوين أحكام التجويد',
      name: 'tajweed_colors',
      desc: '',
      args: [],
    );
  }

  /// `تلوين الحروف في المصحف حسب أحكام التجويد`
  String get tajweed_colors_subtitle {
    return Intl.message(
      'تلوين الحروف في المصحف حسب أحكام التجويد',
      name: 'tajweed_colors_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `دليل ألوان التجويد`
  String get tajweed_guide {
    return Intl.message(
      'دليل ألوان التجويد',
      name: 'tajweed_guide',
      desc: '',
      args: [],
    );
  }

  /// `معنى كل لون ومدته ومثال عليه`
  String get tajweed_guide_subtitle {
    return Intl.message(
      'معنى كل لون ومدته ومثال عليه',
      name: 'tajweed_guide_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `أحكام التجويد`
  String get tajweed_details {
    return Intl.message(
      'أحكام التجويد',
      name: 'tajweed_details',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد أحكام ملونة في هذه الآية`
  String get tajweed_no_rules {
    return Intl.message(
      'لا توجد أحكام ملونة في هذه الآية',
      name: 'tajweed_no_rules',
      desc: '',
      args: [],
    );
  }

  /// `تعذر تحميل أحكام التجويد`
  String get tajweed_unavailable {
    return Intl.message(
      'تعذر تحميل أحكام التجويد',
      name: 'tajweed_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `الموضع`
  String get tajweed_position {
    return Intl.message('الموضع', name: 'tajweed_position', desc: '', args: []);
  }

  /// `الحرف`
  String get tajweed_letters {
    return Intl.message('الحرف', name: 'tajweed_letters', desc: '', args: []);
  }

  /// `المدة`
  String get tajweed_duration {
    return Intl.message('المدة', name: 'tajweed_duration', desc: '', args: []);
  }

  /// `مثال`
  String get tajweed_example {
    return Intl.message('مثال', name: 'tajweed_example', desc: '', args: []);
  }

  /// `آية`
  String get ayah_label {
    return Intl.message('آية', name: 'ayah_label', desc: '', args: []);
  }

  /// `الآيات المتشابهة`
  String get similar_ayahs {
    return Intl.message(
      'الآيات المتشابهة',
      name: 'similar_ayahs',
      desc: '',
      args: [],
    );
  }

  /// `تلوين الآيات المتشابهة`
  String get similar_colors {
    return Intl.message(
      'تلوين الآيات المتشابهة',
      name: 'similar_colors',
      desc: '',
      args: [],
    );
  }

  /// `تمييز الآيات المكررة والعبارات المشتركة بين الآيات`
  String get similar_colors_subtitle {
    return Intl.message(
      'تمييز الآيات المكررة والعبارات المشتركة بين الآيات',
      name: 'similar_colors_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `تطابق تام`
  String get similar_full {
    return Intl.message('تطابق تام', name: 'similar_full', desc: '', args: []);
  }

  /// `تشابه جزئي`
  String get similar_partial {
    return Intl.message(
      'تشابه جزئي',
      name: 'similar_partial',
      desc: '',
      args: [],
    );
  }

  /// `أقل عدد كلمات للتشابه`
  String get similar_min_words {
    return Intl.message(
      'أقل عدد كلمات للتشابه',
      name: 'similar_min_words',
      desc: '',
      args: [],
    );
  }

  /// `عدد الكلمات المتتالية المشتركة ليعد تشابهًا جزئيًا`
  String get similar_min_words_subtitle {
    return Intl.message(
      'عدد الكلمات المتتالية المشتركة ليعد تشابهًا جزئيًا',
      name: 'similar_min_words_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد آية تشترك معها في {count} كلمات متتالية أو أكثر`
  String similar_none(String count) {
    return Intl.message(
      'لا توجد آية تشترك معها في $count كلمات متتالية أو أكثر',
      name: 'similar_none',
      desc: '',
      args: [count],
    );
  }

  /// `تعذر البحث عن الآيات المتشابهة`
  String get similar_failed {
    return Intl.message(
      'تعذر البحث عن الآيات المتشابهة',
      name: 'similar_failed',
      desc: '',
      args: [],
    );
  }

  /// `{count} كلمات`
  String similar_words(String count) {
    return Intl.message(
      '$count كلمات',
      name: 'similar_words',
      desc: '',
      args: [count],
    );
  }

  /// `قراءة القرآن`
  String get home_read {
    return Intl.message('قراءة القرآن', name: 'home_read', desc: '', args: []);
  }

  /// `المصحف مع التجويد والمتشابهات والبحث`
  String get home_read_subtitle {
    return Intl.message(
      'المصحف مع التجويد والمتشابهات والبحث',
      name: 'home_read_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `المسابقة`
  String get home_play {
    return Intl.message('المسابقة', name: 'home_play', desc: '', args: []);
  }

  /// `تحدَّ حافظًا آخر بوجود حكم`
  String get home_play_subtitle {
    return Intl.message(
      'تحدَّ حافظًا آخر بوجود حكم',
      name: 'home_play_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء مباراة`
  String get match_create {
    return Intl.message(
      'إنشاء مباراة',
      name: 'match_create',
      desc: '',
      args: [],
    );
  }

  /// `الانضمام لمباراة`
  String get match_join {
    return Intl.message(
      'الانضمام لمباراة',
      name: 'match_join',
      desc: '',
      args: [],
    );
  }

  /// `اسمك`
  String get match_your_name {
    return Intl.message('اسمك', name: 'match_your_name', desc: '', args: []);
  }

  /// `رمز المباراة`
  String get match_code {
    return Intl.message('رمز المباراة', name: 'match_code', desc: '', args: []);
  }

  /// `طريقة اللعب`
  String get match_mode {
    return Intl.message('طريقة اللعب', name: 'match_mode', desc: '', args: []);
  }

  /// `في نفس المكان`
  String get match_mode_same_room {
    return Intl.message(
      'في نفس المكان',
      name: 'match_mode_same_room',
      desc: '',
      args: [],
    );
  }

  /// `عن بُعد`
  String get match_mode_remote {
    return Intl.message(
      'عن بُعد',
      name: 'match_mode_remote',
      desc: '',
      args: [],
    );
  }

  /// `دورك`
  String get match_your_role {
    return Intl.message('دورك', name: 'match_your_role', desc: '', args: []);
  }

  /// `المتسابق الأول`
  String get match_role_player1 {
    return Intl.message(
      'المتسابق الأول',
      name: 'match_role_player1',
      desc: '',
      args: [],
    );
  }

  /// `المتسابق الثاني`
  String get match_role_player2 {
    return Intl.message(
      'المتسابق الثاني',
      name: 'match_role_player2',
      desc: '',
      args: [],
    );
  }

  /// `الحكم`
  String get match_role_referee {
    return Intl.message(
      'الحكم',
      name: 'match_role_referee',
      desc: '',
      args: [],
    );
  }

  /// `بانتظار الانضمام`
  String get match_waiting_seat {
    return Intl.message(
      'بانتظار الانضمام',
      name: 'match_waiting_seat',
      desc: '',
      args: [],
    );
  }

  /// `تم نسخ رمز المباراة`
  String get match_code_copied {
    return Intl.message(
      'تم نسخ رمز المباراة',
      name: 'match_code_copied',
      desc: '',
      args: [],
    );
  }

  /// `أنت {name}`
  String match_you_are(String name) {
    return Intl.message(
      'أنت $name',
      name: 'match_you_are',
      desc: '',
      args: [name],
    );
  }

  /// `الصوت والصورة بين المتسابقين في المرحلة القادمة`
  String get match_remote_media_soon {
    return Intl.message(
      'الصوت والصورة بين المتسابقين في المرحلة القادمة',
      name: 'match_remote_media_soon',
      desc: '',
      args: [],
    );
  }

  /// `بانتظار انضمام المتسابقَين بالرمز`
  String get match_waiting_players {
    return Intl.message(
      'بانتظار انضمام المتسابقَين بالرمز',
      name: 'match_waiting_players',
      desc: '',
      args: [],
    );
  }

  /// `المتسابقان جاهزان`
  String get match_players_ready {
    return Intl.message(
      'المتسابقان جاهزان',
      name: 'match_players_ready',
      desc: '',
      args: [],
    );
  }

  /// `ابدأ فقرة رقم الآيات`
  String get match_start_ayah_number {
    return Intl.message(
      'ابدأ فقرة رقم الآيات',
      name: 'match_start_ayah_number',
      desc: '',
      args: [],
    );
  }

  /// `بانتظار الحكم ليبدأ`
  String get match_wait_referee_start {
    return Intl.message(
      'بانتظار الحكم ليبدأ',
      name: 'match_wait_referee_start',
      desc: '',
      args: [],
    );
  }

  /// `رقم الآيات`
  String get match_round_ayah_number {
    return Intl.message(
      'رقم الآيات',
      name: 'match_round_ayah_number',
      desc: '',
      args: [],
    );
  }

  /// `السؤال {current} من {total}`
  String match_question_of(String current, String total) {
    return Intl.message(
      'السؤال $current من $total',
      name: 'match_question_of',
      desc: '',
      args: [current, total],
    );
  }

  /// `ما رقم هذه الآية في سورتها؟`
  String get match_ayah_number_prompt {
    return Intl.message(
      'ما رقم هذه الآية في سورتها؟',
      name: 'match_ayah_number_prompt',
      desc: '',
      args: [],
    );
  }

  /// `أجاب`
  String get match_answered {
    return Intl.message('أجاب', name: 'match_answered', desc: '', args: []);
  }

  /// `…`
  String get match_waiting_answer {
    return Intl.message('…', name: 'match_waiting_answer', desc: '', args: []);
  }

  /// `نقطة`
  String get match_got_point {
    return Intl.message('نقطة', name: 'match_got_point', desc: '', args: []);
  }

  /// `رقم الآية`
  String get match_your_answer {
    return Intl.message(
      'رقم الآية',
      name: 'match_your_answer',
      desc: '',
      args: [],
    );
  }

  /// `إرسال`
  String get match_send {
    return Intl.message('إرسال', name: 'match_send', desc: '', args: []);
  }

  /// `تم الإرسال، بانتظار كشف الإجابات`
  String get match_wait_reveal {
    return Intl.message(
      'تم الإرسال، بانتظار كشف الإجابات',
      name: 'match_wait_reveal',
      desc: '',
      args: [],
    );
  }

  /// `بانتظار الحكم للسؤال التالي`
  String get match_wait_referee_next {
    return Intl.message(
      'بانتظار الحكم للسؤال التالي',
      name: 'match_wait_referee_next',
      desc: '',
      args: [],
    );
  }

  /// `اكشف الإجابات`
  String get match_reveal {
    return Intl.message(
      'اكشف الإجابات',
      name: 'match_reveal',
      desc: '',
      args: [],
    );
  }

  /// `السؤال التالي`
  String get match_next {
    return Intl.message(
      'السؤال التالي',
      name: 'match_next',
      desc: '',
      args: [],
    );
  }

  /// `إنهاء المباراة`
  String get match_finish {
    return Intl.message(
      'إنهاء المباراة',
      name: 'match_finish',
      desc: '',
      args: [],
    );
  }

  /// `تعديل النقاط`
  String get match_adjust_scores {
    return Intl.message(
      'تعديل النقاط',
      name: 'match_adjust_scores',
      desc: '',
      args: [],
    );
  }

  /// `تعادل`
  String get match_draw {
    return Intl.message('تعادل', name: 'match_draw', desc: '', args: []);
  }

  /// `الفائز: {name}`
  String match_winner(String name) {
    return Intl.message(
      'الفائز: $name',
      name: 'match_winner',
      desc: '',
      args: [name],
    );
  }

  /// `مباراة جديدة`
  String get match_new {
    return Intl.message('مباراة جديدة', name: 'match_new', desc: '', args: []);
  }

  /// `خروج`
  String get match_leave {
    return Intl.message('خروج', name: 'match_leave', desc: '', args: []);
  }

  /// `تعذر الاتصال بالخادم`
  String get match_err_unreachable {
    return Intl.message(
      'تعذر الاتصال بالخادم',
      name: 'match_err_unreachable',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد مباراة بهذا الرمز`
  String get match_err_not_found {
    return Intl.message(
      'لا توجد مباراة بهذا الرمز',
      name: 'match_err_not_found',
      desc: '',
      args: [],
    );
  }

  /// `هذا الدور مأخوذ`
  String get match_err_role_taken {
    return Intl.message(
      'هذا الدور مأخوذ',
      name: 'match_err_role_taken',
      desc: '',
      args: [],
    );
  }

  /// `اكتب اسمك`
  String get match_err_name {
    return Intl.message(
      'اكتب اسمك',
      name: 'match_err_name',
      desc: '',
      args: [],
    );
  }

  /// `لم ينضم المتسابقان بعد`
  String get match_err_players_missing {
    return Intl.message(
      'لم ينضم المتسابقان بعد',
      name: 'match_err_players_missing',
      desc: '',
      args: [],
    );
  }

  /// `انتهى الوقت`
  String get match_err_time_up {
    return Intl.message(
      'انتهى الوقت',
      name: 'match_err_time_up',
      desc: '',
      args: [],
    );
  }

  /// `أرسلت إجابتك بالفعل`
  String get match_err_already_answered {
    return Intl.message(
      'أرسلت إجابتك بالفعل',
      name: 'match_err_already_answered',
      desc: '',
      args: [],
    );
  }

  /// `رقم غير صحيح`
  String get match_err_invalid_answer {
    return Intl.message(
      'رقم غير صحيح',
      name: 'match_err_invalid_answer',
      desc: '',
      args: [],
    );
  }

  /// `حدث خطأ، حاول مرة أخرى`
  String get match_err_generic {
    return Intl.message(
      'حدث خطأ، حاول مرة أخرى',
      name: 'match_err_generic',
      desc: '',
      args: [],
    );
  }

  /// `متسابق`
  String get match_role_player {
    return Intl.message(
      'متسابق',
      name: 'match_role_player',
      desc: '',
      args: [],
    );
  }

  /// `رقم المباراة (اختياري)`
  String get match_id_optional {
    return Intl.message(
      'رقم المباراة (اختياري)',
      name: 'match_id_optional',
      desc: '',
      args: [],
    );
  }

  /// `ستدخل هذه المباراة بالضبط، وتُنشأ بهذا الرقم إن لم تكن موجودة`
  String get match_id_hint_set {
    return Intl.message(
      'ستدخل هذه المباراة بالضبط، وتُنشأ بهذا الرقم إن لم تكن موجودة',
      name: 'match_id_hint_set',
      desc: '',
      args: [],
    );
  }

  /// `اتركه فارغًا ليختار الخادم لك مباراة مفتوحة`
  String get match_id_hint_empty {
    return Intl.message(
      'اتركه فارغًا ليختار الخادم لك مباراة مفتوحة',
      name: 'match_id_hint_empty',
      desc: '',
      args: [],
    );
  }

  /// `دخول المباراة`
  String get match_enter_by_id {
    return Intl.message(
      'دخول المباراة',
      name: 'match_enter_by_id',
      desc: '',
      args: [],
    );
  }

  /// `ابحث لي عن مباراة`
  String get match_find {
    return Intl.message(
      'ابحث لي عن مباراة',
      name: 'match_find',
      desc: '',
      args: [],
    );
  }

  /// `المباراة مكتملة بالمتسابقين`
  String get match_err_full {
    return Intl.message(
      'المباراة مكتملة بالمتسابقين',
      name: 'match_err_full',
      desc: '',
      args: [],
    );
  }

  /// `رقم المباراة من ٣ إلى ٢٠ حرفًا أو رقمًا بلا مسافات`
  String get match_err_invalid_code {
    return Intl.message(
      'رقم المباراة من ٣ إلى ٢٠ حرفًا أو رقمًا بلا مسافات',
      name: 'match_err_invalid_code',
      desc: '',
      args: [],
    );
  }

  /// `هذا الرقم مستخدم لمباراة جارية`
  String get match_err_code_taken {
    return Intl.message(
      'هذا الرقم مستخدم لمباراة جارية',
      name: 'match_err_code_taken',
      desc: '',
      args: [],
    );
  }

  /// `انتهت المباراة السابقة أو أُغلقت`
  String get match_err_closed {
    return Intl.message(
      'انتهت المباراة السابقة أو أُغلقت',
      name: 'match_err_closed',
      desc: '',
      args: [],
    );
  }

  /// `الأسرع`
  String get match_answered_first {
    return Intl.message(
      'الأسرع',
      name: 'match_answered_first',
      desc: '',
      args: [],
    );
  }

  /// `{value} ث`
  String match_seconds(String value) {
    return Intl.message(
      '$value ث',
      name: 'match_seconds',
      desc: '',
      args: [value],
    );
  }

  /// `ماذا تعرف`
  String get round_what_do_you_know {
    return Intl.message(
      'ماذا تعرف',
      name: 'round_what_do_you_know',
      desc: '',
      args: [],
    );
  }

  /// `رقم الآيات`
  String get round_ayah_number {
    return Intl.message(
      'رقم الآيات',
      name: 'round_ayah_number',
      desc: '',
      args: [],
    );
  }

  /// `المزاد`
  String get round_auction {
    return Intl.message('المزاد', name: 'round_auction', desc: '', args: []);
  }

  /// `المتشابهات`
  String get round_similar {
    return Intl.message(
      'المتشابهات',
      name: 'round_similar',
      desc: '',
      args: [],
    );
  }

  /// `الجرس`
  String get round_buzzer {
    return Intl.message('الجرس', name: 'round_buzzer', desc: '', args: []);
  }

  /// `أجيبا بالتناوب: لكل متسابق {strikes} أخطاء وتجاوز واحد`
  String round_hint_what_do_you_know(String strikes) {
    return Intl.message(
      'أجيبا بالتناوب: لكل متسابق $strikes أخطاء وتجاوز واحد',
      name: 'round_hint_what_do_you_know',
      desc: '',
      args: [strikes],
    );
  }

  /// `هذه أول آية في الصفحة: كم آية في هذه الصفحة؟`
  String get round_hint_ayah_number {
    return Intl.message(
      'هذه أول آية في الصفحة: كم آية في هذه الصفحة؟',
      name: 'round_hint_ayah_number',
      desc: '',
      args: [],
    );
  }

  /// `زايِد علنًا على عدد ما تستطيع ذكره، وصاحب المزايدة الأعلى يسرد`
  String get round_hint_auction {
    return Intl.message(
      'زايِد علنًا على عدد ما تستطيع ذكره، وصاحب المزايدة الأعلى يسرد',
      name: 'round_hint_auction',
      desc: '',
      args: [],
    );
  }

  /// `أجب مباشرة بصوتك إن عرفت العبارة المشتركة`
  String get round_hint_similar {
    return Intl.message(
      'أجب مباشرة بصوتك إن عرفت العبارة المشتركة',
      name: 'round_hint_similar',
      desc: '',
      args: [],
    );
  }

  /// `أول من يضغط الجرس يجيب`
  String get round_hint_buzzer {
    return Intl.message(
      'أول من يضغط الجرس يجيب',
      name: 'round_hint_buzzer',
      desc: '',
      args: [],
    );
  }

  /// `الفقرة {round} من {rounds} · السؤال {q} من {qs} · ({n}/{total})`
  String match_progress(
    String round,
    String rounds,
    String q,
    String qs,
    String n,
    String total,
  ) {
    return Intl.message(
      'الفقرة $round من $rounds · السؤال $q من $qs · ($n/$total)',
      name: 'match_progress',
      desc: '',
      args: [round, rounds, q, qs, n, total],
    );
  }

  /// `العدد الكلي: {count}`
  String match_auction_total(String count) {
    return Intl.message(
      'العدد الكلي: $count',
      name: 'match_auction_total',
      desc: '',
      args: [count],
    );
  }

  /// `صفحة {page} ({surah}) · {count}`
  String match_page_answer(String surah, String page, String count) {
    return Intl.message(
      'صفحة $page ($surah) · $count',
      name: 'match_page_answer',
      desc: '',
      args: [surah, page, count],
    );
  }

  /// `الإجابة`
  String get match_answer_label {
    return Intl.message(
      'الإجابة',
      name: 'match_answer_label',
      desc: '',
      args: [],
    );
  }

  /// `مزايدتك`
  String get match_your_bid {
    return Intl.message('مزايدتك', name: 'match_your_bid', desc: '', args: []);
  }

  /// `مزايدتك: {count}، بانتظار الحكم`
  String match_bid_sent(String count) {
    return Intl.message(
      'مزايدتك: $count، بانتظار الحكم',
      name: 'match_bid_sent',
      desc: '',
      args: [count],
    );
  }

  /// `أنت تسرد الآن: {count}`
  String match_you_recite(String count) {
    return Intl.message(
      'أنت تسرد الآن: $count',
      name: 'match_you_recite',
      desc: '',
      args: [count],
    );
  }

  /// `{name} يسرد الآن: {count}`
  String match_other_recites(String name, String count) {
    return Intl.message(
      '$name يسرد الآن: $count',
      name: 'match_other_recites',
      desc: '',
      args: [name, count],
    );
  }

  /// `دورك الآن`
  String get match_your_turn {
    return Intl.message(
      'دورك الآن',
      name: 'match_your_turn',
      desc: '',
      args: [],
    );
  }

  /// `دور {name}`
  String match_turn_of(String name) {
    return Intl.message(
      'دور $name',
      name: 'match_turn_of',
      desc: '',
      args: [name],
    );
  }

  /// `اضغط الجرس للإجابة`
  String get match_press_buzzer {
    return Intl.message(
      'اضغط الجرس للإجابة',
      name: 'match_press_buzzer',
      desc: '',
      args: [],
    );
  }

  /// `أجب الآن!`
  String get match_you_buzzed {
    return Intl.message(
      'أجب الآن!',
      name: 'match_you_buzzed',
      desc: '',
      args: [],
    );
  }

  /// `{name} ضغط الجرس`
  String match_other_buzzed(String name) {
    return Intl.message(
      '$name ضغط الجرس',
      name: 'match_other_buzzed',
      desc: '',
      args: [name],
    );
  }

  /// `أغلق المزايدة`
  String get match_close_bids {
    return Intl.message(
      'أغلق المزايدة',
      name: 'match_close_bids',
      desc: '',
      args: [],
    );
  }

  /// `نجح`
  String get match_recite_ok {
    return Intl.message('نجح', name: 'match_recite_ok', desc: '', args: []);
  }

  /// `لم ينجح`
  String get match_recite_fail {
    return Intl.message(
      'لم ينجح',
      name: 'match_recite_fail',
      desc: '',
      args: [],
    );
  }

  /// `صحيح`
  String get match_correct {
    return Intl.message('صحيح', name: 'match_correct', desc: '', args: []);
  }

  /// `خطأ`
  String get match_strike {
    return Intl.message('خطأ', name: 'match_strike', desc: '', args: []);
  }

  /// `خطأ`
  String get match_wrong {
    return Intl.message('خطأ', name: 'match_wrong', desc: '', args: []);
  }

  /// `بانتظار من يضغط الجرس`
  String get match_waiting_buzz {
    return Intl.message(
      'بانتظار من يضغط الجرس',
      name: 'match_waiting_buzz',
      desc: '',
      args: [],
    );
  }

  /// `إنهاء السؤال يدويًا`
  String get match_manual_point {
    return Intl.message(
      'إنهاء السؤال يدويًا',
      name: 'match_manual_point',
      desc: '',
      args: [],
    );
  }

  /// `بلا نقطة`
  String get match_no_point {
    return Intl.message('بلا نقطة', name: 'match_no_point', desc: '', args: []);
  }

  /// `مفتاح الإجابة ({said} من {total})`
  String match_answer_key(String said, String total) {
    return Intl.message(
      'مفتاح الإجابة ($said من $total)',
      name: 'match_answer_key',
      desc: '',
      args: [said, total],
    );
  }

  /// `ابدأ المباراة ({n} سؤالًا)`
  String match_start(String n) {
    return Intl.message(
      'ابدأ المباراة ($n سؤالًا)',
      name: 'match_start',
      desc: '',
      args: [n],
    );
  }

  /// `أخطأت، الفرصة للمنافس`
  String get match_locked_out {
    return Intl.message(
      'أخطأت، الفرصة للمنافس',
      name: 'match_locked_out',
      desc: '',
      args: [],
    );
  }

  /// `أخطأ منافسك، أجب الآن`
  String get match_your_chance {
    return Intl.message(
      'أخطأ منافسك، أجب الآن',
      name: 'match_your_chance',
      desc: '',
      args: [],
    );
  }

  /// `أخطأ {wrong}، يجيب الآن {name}`
  String match_handed_over(String wrong, String name) {
    return Intl.message(
      'أخطأ $wrong، يجيب الآن $name',
      name: 'match_handed_over',
      desc: '',
      args: [wrong, name],
    );
  }

  /// `قيمة السؤال الآن: {count} نقاط`
  String match_worth(String count) {
    return Intl.message(
      'قيمة السؤال الآن: $count نقاط',
      name: 'match_worth',
      desc: '',
      args: [count],
    );
  }

  /// `رفيقك في تلاوة القرآن ومراجعته`
  String get splash_tagline {
    return Intl.message(
      'رفيقك في تلاوة القرآن ومراجعته',
      name: 'splash_tagline',
      desc: '',
      args: [],
    );
  }

  /// `السلام عليكم`
  String get home_greeting {
    return Intl.message(
      'السلام عليكم',
      name: 'home_greeting',
      desc: '',
      args: [],
    );
  }

  /// `تابع القراءة · صفحة {page}`
  String home_continue(String page) {
    return Intl.message(
      'تابع القراءة · صفحة $page',
      name: 'home_continue',
      desc: '',
      args: [page],
    );
  }

  /// `ابدأ القراءة`
  String get home_start_reading {
    return Intl.message(
      'ابدأ القراءة',
      name: 'home_start_reading',
      desc: '',
      args: [],
    );
  }

  /// `العب الآن`
  String get home_play_now {
    return Intl.message('العب الآن', name: 'home_play_now', desc: '', args: []);
  }

  /// `سبع فقرات · ٢٨ سؤالًا`
  String get home_rounds {
    return Intl.message(
      'سبع فقرات · ٢٨ سؤالًا',
      name: 'home_rounds',
      desc: '',
      args: [],
    );
  }

  /// `المزيد`
  String get home_more {
    return Intl.message('المزيد', name: 'home_more', desc: '', args: []);
  }

  /// `دليل التجويد`
  String get home_tajweed_guide {
    return Intl.message(
      'دليل التجويد',
      name: 'home_tajweed_guide',
      desc: '',
      args: [],
    );
  }

  /// `الإعدادات`
  String get home_settings {
    return Intl.message('الإعدادات', name: 'home_settings', desc: '', args: []);
  }

  /// `اسم السورة أو رقمها`
  String get surah_filter_hint {
    return Intl.message(
      'اسم السورة أو رقمها',
      name: 'surah_filter_hint',
      desc: '',
      args: [],
    );
  }

  /// `ص {page}`
  String surah_page_short(String page) {
    return Intl.message(
      'ص $page',
      name: 'surah_page_short',
      desc: '',
      args: [page],
    );
  }

  /// `لا توجد سورة بهذا الاسم`
  String get surah_none {
    return Intl.message(
      'لا توجد سورة بهذا الاسم',
      name: 'surah_none',
      desc: '',
      args: [],
    );
  }

  /// `الوضع الفاتح`
  String get light_mode {
    return Intl.message('الوضع الفاتح', name: 'light_mode', desc: '', args: []);
  }

  /// `جاهز للتحدي؟`
  String get lobby_title {
    return Intl.message(
      'جاهز للتحدي؟',
      name: 'lobby_title',
      desc: '',
      args: [],
    );
  }

  /// `اختر دورك وابدأ المنافسة`
  String get lobby_subtitle {
    return Intl.message(
      'اختر دورك وابدأ المنافسة',
      name: 'lobby_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `تجيب وتنافس على النقاط`
  String get match_role_player_desc {
    return Intl.message(
      'تجيب وتنافس على النقاط',
      name: 'match_role_player_desc',
      desc: '',
      args: [],
    );
  }

  /// `تدير الأسئلة وتحكم الإجابات`
  String get match_role_referee_desc {
    return Intl.message(
      'تدير الأسئلة وتحكم الإجابات',
      name: 'match_role_referee_desc',
      desc: '',
      args: [],
    );
  }

  /// `الجميع في مكان واحد`
  String get match_mode_same_room_desc {
    return Intl.message(
      'الجميع في مكان واحد',
      name: 'match_mode_same_room_desc',
      desc: '',
      args: [],
    );
  }

  /// `كل واحد من جهازه`
  String get match_mode_remote_desc {
    return Intl.message(
      'كل واحد من جهازه',
      name: 'match_mode_remote_desc',
      desc: '',
      args: [],
    );
  }

  /// `مثال: عبدالله`
  String get match_name_hint {
    return Intl.message(
      'مثال: عبدالله',
      name: 'match_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `رقم المباراة`
  String get match_id_placeholder {
    return Intl.message(
      'رقم المباراة',
      name: 'match_id_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `أنت`
  String get match_you_short {
    return Intl.message('أنت', name: 'match_you_short', desc: '', args: []);
  }

  /// `ضد`
  String get match_vs {
    return Intl.message('ضد', name: 'match_vs', desc: '', args: []);
  }

  /// `يجيب الآن`
  String get match_answering_now {
    return Intl.message(
      'يجيب الآن',
      name: 'match_answering_now',
      desc: '',
      args: [],
    );
  }

  /// `الفقرة {round} من {rounds} · السؤال {q} من {qs}`
  String match_round_of(String round, String rounds, String q, String qs) {
    return Intl.message(
      'الفقرة $round من $rounds · السؤال $q من $qs',
      name: 'match_round_of',
      desc: '',
      args: [round, rounds, q, qs],
    );
  }

  /// `انتهى`
  String get match_question_done {
    return Intl.message(
      'انتهى',
      name: 'match_question_done',
      desc: '',
      args: [],
    );
  }

  /// `{count} نقاط`
  String match_points_chip(String count) {
    return Intl.message(
      '$count نقاط',
      name: 'match_points_chip',
      desc: '',
      args: [count],
    );
  }

  /// `أدوات الحكم`
  String get referee_tools {
    return Intl.message(
      'أدوات الحكم',
      name: 'referee_tools',
      desc: '',
      args: [],
    );
  }

  /// `نقطة يدوية وتعديل النتيجة`
  String get referee_tools_hint {
    return Intl.message(
      'نقطة يدوية وتعديل النتيجة',
      name: 'referee_tools_hint',
      desc: '',
      args: [],
    );
  }

  /// `شارك الرمز ليدخل الآخرون نفس المباراة`
  String get match_share_code {
    return Intl.message(
      'شارك الرمز ليدخل الآخرون نفس المباراة',
      name: 'match_share_code',
      desc: '',
      args: [],
    );
  }

  /// `المقاعد`
  String get match_seats {
    return Intl.message('المقاعد', name: 'match_seats', desc: '', args: []);
  }

  /// `النتيجة النهائية`
  String get match_final_score {
    return Intl.message(
      'النتيجة النهائية',
      name: 'match_final_score',
      desc: '',
      args: [],
    );
  }

  /// `اضغط للنسخ`
  String get match_tap_to_copy {
    return Intl.message(
      'اضغط للنسخ',
      name: 'match_tap_to_copy',
      desc: '',
      args: [],
    );
  }

  /// `الفائز`
  String get match_winner_chip {
    return Intl.message(
      'الفائز',
      name: 'match_winner_chip',
      desc: '',
      args: [],
    );
  }

  /// `سؤال بديل`
  String get match_replace {
    return Intl.message('سؤال بديل', name: 'match_replace', desc: '', args: []);
  }

  /// `تبديل السؤال؟`
  String get match_replace_title {
    return Intl.message(
      'تبديل السؤال؟',
      name: 'match_replace_title',
      desc: '',
      args: [],
    );
  }

  /// `سيُستبدل هذا السؤال بسؤال آخر من نفس الفقرة، ويظهر للمتسابقين أنه سؤال بديل. إن احتُسبت له نقاط فستُلغى.`
  String get match_replace_body {
    return Intl.message(
      'سيُستبدل هذا السؤال بسؤال آخر من نفس الفقرة، ويظهر للمتسابقين أنه سؤال بديل. إن احتُسبت له نقاط فستُلغى.',
      name: 'match_replace_body',
      desc: '',
      args: [],
    );
  }

  /// `بدّل السؤال`
  String get match_replace_do {
    return Intl.message(
      'بدّل السؤال',
      name: 'match_replace_do',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get match_cancel {
    return Intl.message('إلغاء', name: 'match_cancel', desc: '', args: []);
  }

  /// `سؤال بديل`
  String get match_replaced_chip {
    return Intl.message(
      'سؤال بديل',
      name: 'match_replaced_chip',
      desc: '',
      args: [],
    );
  }

  /// `استمع للسؤال من الحكم`
  String get match_listen_question {
    return Intl.message(
      'استمع للسؤال من الحكم',
      name: 'match_listen_question',
      desc: '',
      args: [],
    );
  }

  /// `يظهر نص السؤال بعد انتهائه`
  String get match_listen_hint {
    return Intl.message(
      'يظهر نص السؤال بعد انتهائه',
      name: 'match_listen_hint',
      desc: '',
      args: [],
    );
  }

  /// `بلا وقت`
  String get match_no_timer {
    return Intl.message('بلا وقت', name: 'match_no_timer', desc: '', args: []);
  }

  /// `لوحة التشكيل`
  String get search_tashkeel_keyboard {
    return Intl.message(
      'لوحة التشكيل',
      name: 'search_tashkeel_keyboard',
      desc: '',
      args: [],
    );
  }

  /// `الصفحات المحفوظة`
  String get saved_pages {
    return Intl.message(
      'الصفحات المحفوظة',
      name: 'saved_pages',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد صفحات محفوظة بعد`
  String get saved_pages_empty {
    return Intl.message(
      'لا توجد صفحات محفوظة بعد',
      name: 'saved_pages_empty',
      desc: '',
      args: [],
    );
  }

  /// `اضغط زر الحفظ أعلى صفحة المصحف لتعود إليها لاحقًا`
  String get saved_pages_empty_hint {
    return Intl.message(
      'اضغط زر الحفظ أعلى صفحة المصحف لتعود إليها لاحقًا',
      name: 'saved_pages_empty_hint',
      desc: '',
      args: [],
    );
  }

  /// `حفظ الصفحة`
  String get save_page {
    return Intl.message('حفظ الصفحة', name: 'save_page', desc: '', args: []);
  }

  /// `حُفظت الصفحة {page}`
  String page_saved(String page) {
    return Intl.message(
      'حُفظت الصفحة $page',
      name: 'page_saved',
      desc: '',
      args: [page],
    );
  }

  /// `أُزيلت الصفحة {page} من المحفوظات`
  String page_unsaved(String page) {
    return Intl.message(
      'أُزيلت الصفحة $page من المحفوظات',
      name: 'page_unsaved',
      desc: '',
      args: [page],
    );
  }

  /// `تراجع`
  String get undo {
    return Intl.message('تراجع', name: 'undo', desc: '', args: []);
  }

  /// `{count} صفحة محفوظة`
  String saved_count(String count) {
    return Intl.message(
      '$count صفحة محفوظة',
      name: 'saved_count',
      desc: '',
      args: [count],
    );
  }

  /// `المزيد`
  String get reader_more {
    return Intl.message('المزيد', name: 'reader_more', desc: '', args: []);
  }

  /// `تسجيل الدخول`
  String get auth_login_title {
    return Intl.message(
      'تسجيل الدخول',
      name: 'auth_login_title',
      desc: '',
      args: [],
    );
  }

  /// `حساب جديد`
  String get auth_register_title {
    return Intl.message(
      'حساب جديد',
      name: 'auth_register_title',
      desc: '',
      args: [],
    );
  }

  /// `المسابقة تحتاج حسابًا`
  String get auth_gate_title {
    return Intl.message(
      'المسابقة تحتاج حسابًا',
      name: 'auth_gate_title',
      desc: '',
      args: [],
    );
  }

  /// `سجّل الدخول أو أنشئ حسابًا لتلعب وتُحفظ نتائجك. القراءة متاحة للجميع دون حساب.`
  String get auth_gate_subtitle {
    return Intl.message(
      'سجّل الدخول أو أنشئ حسابًا لتلعب وتُحفظ نتائجك. القراءة متاحة للجميع دون حساب.',
      name: 'auth_gate_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني`
  String get auth_email {
    return Intl.message(
      'البريد الإلكتروني',
      name: 'auth_email',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور`
  String get auth_password {
    return Intl.message(
      'كلمة المرور',
      name: 'auth_password',
      desc: '',
      args: [],
    );
  }

  /// `الاسم الظاهر للمنافسين`
  String get auth_name {
    return Intl.message(
      'الاسم الظاهر للمنافسين',
      name: 'auth_name',
      desc: '',
      args: [],
    );
  }

  /// `دخول`
  String get auth_login {
    return Intl.message('دخول', name: 'auth_login', desc: '', args: []);
  }

  /// `إنشاء الحساب`
  String get auth_register {
    return Intl.message(
      'إنشاء الحساب',
      name: 'auth_register',
      desc: '',
      args: [],
    );
  }

  /// `ليس لديك حساب؟ أنشئ حسابًا`
  String get auth_to_register {
    return Intl.message(
      'ليس لديك حساب؟ أنشئ حسابًا',
      name: 'auth_to_register',
      desc: '',
      args: [],
    );
  }

  /// `لديك حساب؟ سجّل الدخول`
  String get auth_to_login {
    return Intl.message(
      'لديك حساب؟ سجّل الدخول',
      name: 'auth_to_login',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني غير صحيح`
  String get auth_err_invalid_email {
    return Intl.message(
      'البريد الإلكتروني غير صحيح',
      name: 'auth_err_invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور ٦ أحرف على الأقل`
  String get auth_err_weak_password {
    return Intl.message(
      'كلمة المرور ٦ أحرف على الأقل',
      name: 'auth_err_weak_password',
      desc: '',
      args: [],
    );
  }

  /// `اكتب اسمًا من حرفين على الأقل`
  String get auth_err_name {
    return Intl.message(
      'اكتب اسمًا من حرفين على الأقل',
      name: 'auth_err_name',
      desc: '',
      args: [],
    );
  }

  /// `هذا البريد مسجّل بالفعل، سجّل الدخول`
  String get auth_err_email_taken {
    return Intl.message(
      'هذا البريد مسجّل بالفعل، سجّل الدخول',
      name: 'auth_err_email_taken',
      desc: '',
      args: [],
    );
  }

  /// `البريد أو كلمة المرور غير صحيحة`
  String get auth_err_invalid_credentials {
    return Intl.message(
      'البريد أو كلمة المرور غير صحيحة',
      name: 'auth_err_invalid_credentials',
      desc: '',
      args: [],
    );
  }

  /// `تعذر إكمال الطلب، حاول مرة أخرى`
  String get auth_err_generic {
    return Intl.message(
      'تعذر إكمال الطلب، حاول مرة أخرى',
      name: 'auth_err_generic',
      desc: '',
      args: [],
    );
  }

  /// `حسابي`
  String get profile_title {
    return Intl.message('حسابي', name: 'profile_title', desc: '', args: []);
  }

  /// `مباريات`
  String get profile_matches {
    return Intl.message('مباريات', name: 'profile_matches', desc: '', args: []);
  }

  /// `فوز`
  String get profile_wins {
    return Intl.message('فوز', name: 'profile_wins', desc: '', args: []);
  }

  /// `تعادل`
  String get profile_draws {
    return Intl.message('تعادل', name: 'profile_draws', desc: '', args: []);
  }

  /// `خسارة`
  String get profile_losses {
    return Intl.message('خسارة', name: 'profile_losses', desc: '', args: []);
  }

  /// `نقاط`
  String get profile_points {
    return Intl.message('نقاط', name: 'profile_points', desc: '', args: []);
  }

  /// `نسبة الفوز {rate}٪`
  String profile_win_rate(String rate) {
    return Intl.message(
      'نسبة الفوز $rate٪',
      name: 'profile_win_rate',
      desc: '',
      args: [rate],
    );
  }

  /// `آخر المباريات`
  String get profile_recent {
    return Intl.message(
      'آخر المباريات',
      name: 'profile_recent',
      desc: '',
      args: [],
    );
  }

  /// `لم تلعب أي مباراة بعد`
  String get profile_no_matches {
    return Intl.message(
      'لم تلعب أي مباراة بعد',
      name: 'profile_no_matches',
      desc: '',
      args: [],
    );
  }

  /// `ضد {name}`
  String profile_vs(String name) {
    return Intl.message('ضد $name', name: 'profile_vs', desc: '', args: [name]);
  }

  /// `لوحة المتصدرين`
  String get leaderboard {
    return Intl.message(
      'لوحة المتصدرين',
      name: 'leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `لا توجد نتائج بعد، كن أول المتصدرين`
  String get leaderboard_empty {
    return Intl.message(
      'لا توجد نتائج بعد، كن أول المتصدرين',
      name: 'leaderboard_empty',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الخروج`
  String get logout {
    return Intl.message('تسجيل الخروج', name: 'logout', desc: '', args: []);
  }

  /// `تلعب باسم {name}`
  String playing_as(String name) {
    return Intl.message(
      'تلعب باسم $name',
      name: 'playing_as',
      desc: '',
      args: [name],
    );
  }

  /// `سجّل الدخول للعب`
  String get match_err_login_required {
    return Intl.message(
      'سجّل الدخول للعب',
      name: 'match_err_login_required',
      desc: '',
      args: [],
    );
  }

  /// `أنت متسابق في هذه المباراة`
  String get match_err_already_player {
    return Intl.message(
      'أنت متسابق في هذه المباراة',
      name: 'match_err_already_player',
      desc: '',
      args: [],
    );
  }

  /// `أنت الحكم في هذه المباراة`
  String get match_err_already_referee {
    return Intl.message(
      'أنت الحكم في هذه المباراة',
      name: 'match_err_already_referee',
      desc: '',
      args: [],
    );
  }

  /// `(أنت)`
  String get you_label {
    return Intl.message('(أنت)', name: 'you_label', desc: '', args: []);
  }

  /// `المسابقة`
  String get settings_competition {
    return Intl.message(
      'المسابقة',
      name: 'settings_competition',
      desc: '',
      args: [],
    );
  }

  /// `أصوات المسابقة`
  String get game_sounds {
    return Intl.message(
      'أصوات المسابقة',
      name: 'game_sounds',
      desc: '',
      args: [],
    );
  }

  /// `الجرس، الإجابة الصحيحة والخاطئة، والثواني الأخيرة`
  String get game_sounds_subtitle {
    return Intl.message(
      'الجرس، الإجابة الصحيحة والخاطئة، والثواني الأخيرة',
      name: 'game_sounds_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `جارٍ الاتصال بالصوت والصورة…`
  String get media_connecting {
    return Intl.message(
      'جارٍ الاتصال بالصوت والصورة…',
      name: 'media_connecting',
      desc: '',
      args: [],
    );
  }

  /// `تعذر الاتصال بالصوت والصورة`
  String get media_failed {
    return Intl.message(
      'تعذر الاتصال بالصوت والصورة',
      name: 'media_failed',
      desc: '',
      args: [],
    );
  }

  /// `إعادة المحاولة`
  String get media_retry {
    return Intl.message(
      'إعادة المحاولة',
      name: 'media_retry',
      desc: '',
      args: [],
    );
  }

  /// `الميكروفون`
  String get media_mic {
    return Intl.message('الميكروفون', name: 'media_mic', desc: '', args: []);
  }

  /// `الكاميرا`
  String get media_camera {
    return Intl.message('الكاميرا', name: 'media_camera', desc: '', args: []);
  }

  /// `لم ينضم بعد`
  String get media_not_here {
    return Intl.message(
      'لم ينضم بعد',
      name: 'media_not_here',
      desc: '',
      args: [],
    );
  }

  /// `التفاسير والتلاوات`
  String get library {
    return Intl.message(
      'التفاسير والتلاوات',
      name: 'library',
      desc: '',
      args: [],
    );
  }

  /// `حمّل تفسيرًا أو ترجمة أو قارئًا لتستخدمه دون إنترنت`
  String get library_subtitle {
    return Intl.message(
      'حمّل تفسيرًا أو ترجمة أو قارئًا لتستخدمه دون إنترنت',
      name: 'library_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `التفاسير`
  String get library_tafsirs {
    return Intl.message(
      'التفاسير',
      name: 'library_tafsirs',
      desc: '',
      args: [],
    );
  }

  /// `الترجمات`
  String get library_translations {
    return Intl.message(
      'الترجمات',
      name: 'library_translations',
      desc: '',
      args: [],
    );
  }

  /// `القراء`
  String get library_reciters {
    return Intl.message('القراء', name: 'library_reciters', desc: '', args: []);
  }

  /// `مضمّن`
  String get library_bundled {
    return Intl.message('مضمّن', name: 'library_bundled', desc: '', args: []);
  }

  /// `محمّل`
  String get library_downloaded {
    return Intl.message(
      'محمّل',
      name: 'library_downloaded',
      desc: '',
      args: [],
    );
  }

  /// `تحميل`
  String get library_download {
    return Intl.message('تحميل', name: 'library_download', desc: '', args: []);
  }

  /// `حذف`
  String get library_delete {
    return Intl.message('حذف', name: 'library_delete', desc: '', args: []);
  }

  /// `مستخدم`
  String get library_in_use {
    return Intl.message('مستخدم', name: 'library_in_use', desc: '', args: []);
  }

  /// `استخدام`
  String get library_use {
    return Intl.message('استخدام', name: 'library_use', desc: '', args: []);
  }

  /// `تعذّر تحميل القائمة. تحقق من اتصالك بالإنترنت.`
  String get library_offline {
    return Intl.message(
      'تعذّر تحميل القائمة. تحقق من اتصالك بالإنترنت.',
      name: 'library_offline',
      desc: '',
      args: [],
    );
  }

  /// `تعذّر التحميل. حاول مرة أخرى.`
  String get library_download_failed {
    return Intl.message(
      'تعذّر التحميل. حاول مرة أخرى.',
      name: 'library_download_failed',
      desc: '',
      args: [],
    );
  }

  /// `ابحث بالاسم أو اللغة`
  String get library_search {
    return Intl.message(
      'ابحث بالاسم أو اللغة',
      name: 'library_search',
      desc: '',
      args: [],
    );
  }

  /// `{count} سورة محمّلة`
  String library_surahs_count(String count) {
    return Intl.message(
      '$count سورة محمّلة',
      name: 'library_surahs_count',
      desc: '',
      args: [count],
    );
  }

  /// `تحميل الكل`
  String get library_download_all {
    return Intl.message(
      'تحميل الكل',
      name: 'library_download_all',
      desc: '',
      args: [],
    );
  }

  /// `حذف {name}؟`
  String library_delete_confirm(String name) {
    return Intl.message(
      'حذف $name؟',
      name: 'library_delete_confirm',
      desc: '',
      args: [name],
    );
  }

  /// `التفسير`
  String get tafsir {
    return Intl.message('التفسير', name: 'tafsir', desc: '', args: []);
  }

  /// `الترجمة`
  String get translation {
    return Intl.message('الترجمة', name: 'translation', desc: '', args: []);
  }

  /// `الاستماع`
  String get recitation {
    return Intl.message('الاستماع', name: 'recitation', desc: '', args: []);
  }

  /// `استمع من هذه الآية`
  String get recitation_play_from {
    return Intl.message(
      'استمع من هذه الآية',
      name: 'recitation_play_from',
      desc: '',
      args: [],
    );
  }

  /// `حمّل السورة للاستماع`
  String get recitation_download_surah {
    return Intl.message(
      'حمّل السورة للاستماع',
      name: 'recitation_download_surah',
      desc: '',
      args: [],
    );
  }

  /// `جارٍ التحميل {percent}`
  String recitation_downloading(String percent) {
    return Intl.message(
      'جارٍ التحميل $percent',
      name: 'recitation_downloading',
      desc: '',
      args: [percent],
    );
  }

  /// `القارئ`
  String get recitation_reciter {
    return Intl.message(
      'القارئ',
      name: 'recitation_reciter',
      desc: '',
      args: [],
    );
  }

  /// `المزيد…`
  String get more_downloads {
    return Intl.message('المزيد…', name: 'more_downloads', desc: '', args: []);
  }

  /// `تعذّر عرض النص`
  String get text_unavailable {
    return Intl.message(
      'تعذّر عرض النص',
      name: 'text_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `القراءة والاستماع`
  String get settings_reading {
    return Intl.message(
      'القراءة والاستماع',
      name: 'settings_reading',
      desc: '',
      args: [],
    );
  }

  /// `المتشابهات والتجويد`
  String get sheet_tab_similar {
    return Intl.message(
      'المتشابهات والتجويد',
      name: 'sheet_tab_similar',
      desc: '',
      args: [],
    );
  }

  /// `التفسير والترجمة`
  String get sheet_tab_tafsir {
    return Intl.message(
      'التفسير والترجمة',
      name: 'sheet_tab_tafsir',
      desc: '',
      args: [],
    );
  }

  /// `حذف الحساب`
  String get delete_account {
    return Intl.message(
      'حذف الحساب',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `سيُحذف حسابك نهائيًا، وتبقى مبارياتك السابقة في السجل دون اسمك. أدخل كلمة المرور للتأكيد.`
  String get delete_account_body {
    return Intl.message(
      'سيُحذف حسابك نهائيًا، وتبقى مبارياتك السابقة في السجل دون اسمك. أدخل كلمة المرور للتأكيد.',
      name: 'delete_account_body',
      desc: '',
      args: [],
    );
  }

  /// `حذف نهائي`
  String get delete_account_confirm {
    return Intl.message(
      'حذف نهائي',
      name: 'delete_account_confirm',
      desc: '',
      args: [],
    );
  }

  /// `تم حذف حسابك`
  String get delete_account_done {
    return Intl.message(
      'تم حذف حسابك',
      name: 'delete_account_done',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get cancel {
    return Intl.message('إلغاء', name: 'cancel', desc: '', args: []);
  }

  /// `عن التطبيق والخصوصية`
  String get about {
    return Intl.message(
      'عن التطبيق والخصوصية',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `سياسة الخصوصية ومصادر المحتوى`
  String get about_subtitle {
    return Intl.message(
      'سياسة الخصوصية ومصادر المحتوى',
      name: 'about_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `مصحف للقراءة والتجويد، ومسابقة للحفّاظ`
  String get about_tagline {
    return Intl.message(
      'مصحف للقراءة والتجويد، ومسابقة للحفّاظ',
      name: 'about_tagline',
      desc: '',
      args: [],
    );
  }

  /// `الإصدار {version}`
  String about_version(String version) {
    return Intl.message(
      'الإصدار $version',
      name: 'about_version',
      desc: '',
      args: [version],
    );
  }

  /// `سياسة الخصوصية`
  String get privacy_title {
    return Intl.message(
      'سياسة الخصوصية',
      name: 'privacy_title',
      desc: '',
      args: [],
    );
  }

  /// `القراءة دون حساب`
  String get privacy_reading_title {
    return Intl.message(
      'القراءة دون حساب',
      name: 'privacy_reading_title',
      desc: '',
      args: [],
    );
  }

  /// `المصحف والبحث والتجويد والتفاسير والتلاوات تعمل دون تسجيل. الصفحات المحفوظة وآخر صفحة قرأتها وما تحمّله من تفاسير وتلاوات تبقى على جهازك فقط.`
  String get privacy_reading_body {
    return Intl.message(
      'المصحف والبحث والتجويد والتفاسير والتلاوات تعمل دون تسجيل. الصفحات المحفوظة وآخر صفحة قرأتها وما تحمّله من تفاسير وتلاوات تبقى على جهازك فقط.',
      name: 'privacy_reading_body',
      desc: '',
      args: [],
    );
  }

  /// `حساب المسابقة`
  String get privacy_account_title {
    return Intl.message(
      'حساب المسابقة',
      name: 'privacy_account_title',
      desc: '',
      args: [],
    );
  }

  /// `للعب في المسابقة نحفظ بريدك الإلكتروني واسمك وكلمة مرورك مشفّرة، ونتائج مبارياتك لعرض إحصاءاتك ولوحة المتصدرين. لا نبيع بياناتك ولا نشاركها مع أي جهة.`
  String get privacy_account_body {
    return Intl.message(
      'للعب في المسابقة نحفظ بريدك الإلكتروني واسمك وكلمة مرورك مشفّرة، ونتائج مبارياتك لعرض إحصاءاتك ولوحة المتصدرين. لا نبيع بياناتك ولا نشاركها مع أي جهة.',
      name: 'privacy_account_body',
      desc: '',
      args: [],
    );
  }

  /// `الصوت والصورة`
  String get privacy_media_title {
    return Intl.message(
      'الصوت والصورة',
      name: 'privacy_media_title',
      desc: '',
      args: [],
    );
  }

  /// `في المباريات عن بُعد يُبث الصوت والصورة مباشرة بين المشاركين فقط عند تشغيلك لهما، ولا يُسجَّل أو يُحفظ أي منهما.`
  String get privacy_media_body {
    return Intl.message(
      'في المباريات عن بُعد يُبث الصوت والصورة مباشرة بين المشاركين فقط عند تشغيلك لهما، ولا يُسجَّل أو يُحفظ أي منهما.',
      name: 'privacy_media_body',
      desc: '',
      args: [],
    );
  }

  /// `حذف بياناتك`
  String get privacy_delete_title {
    return Intl.message(
      'حذف بياناتك',
      name: 'privacy_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `يمكنك حذف حسابك في أي وقت من صفحة حسابك، فيُحذف بريدك واسمك وكلمة مرورك، وتبقى نتائج المباريات دون اسمك.`
  String get privacy_delete_body {
    return Intl.message(
      'يمكنك حذف حسابك في أي وقت من صفحة حسابك، فيُحذف بريدك واسمك وكلمة مرورك، وتبقى نتائج المباريات دون اسمك.',
      name: 'privacy_delete_body',
      desc: '',
      args: [],
    );
  }

  /// `مصادر المحتوى`
  String get sources_title {
    return Intl.message(
      'مصادر المحتوى',
      name: 'sources_title',
      desc: '',
      args: [],
    );
  }

  /// `نص المصحف: مشروع تنزيل (tanzil.net) برواية حفص.\nالتفاسير والترجمات والتلاوات: alquran.cloud وislamic.network.\nالتفسير الميسر: مجمع الملك فهد لطباعة المصحف الشريف.\nالخطوط: Amiri Quran وIBM Plex Sans Arabic برخصة SIL OFL.`
  String get sources_body {
    return Intl.message(
      'نص المصحف: مشروع تنزيل (tanzil.net) برواية حفص.\nالتفاسير والترجمات والتلاوات: alquran.cloud وislamic.network.\nالتفسير الميسر: مجمع الملك فهد لطباعة المصحف الشريف.\nالخطوط: Amiri Quran وIBM Plex Sans Arabic برخصة SIL OFL.',
      name: 'sources_body',
      desc: '',
      args: [],
    );
  }

  /// `طريقة اللعب`
  String get rules_title {
    return Intl.message('طريقة اللعب', name: 'rules_title', desc: '', args: []);
  }

  /// `المباراة`
  String get rules_overview_title {
    return Intl.message(
      'المباراة',
      name: 'rules_overview_title',
      desc: '',
      args: [],
    );
  }

  /// `متسابقان وحكم، والمباراة {rounds} فقرات في كل منها {perRound} أسئلة.\nيُعدّ الحكم المباراة ويختار أسئلتها أو يتركها عشوائية، ثم ينشرها ليدخل المتسابقان برقمها.\nالعبوا في نفس المكان، أو عن بُعد بالصوت والصورة.`
  String rules_overview(String rounds, String perRound) {
    return Intl.message(
      'متسابقان وحكم، والمباراة $rounds فقرات في كل منها $perRound أسئلة.\nيُعدّ الحكم المباراة ويختار أسئلتها أو يتركها عشوائية، ثم ينشرها ليدخل المتسابقان برقمها.\nالعبوا في نفس المكان، أو عن بُعد بالصوت والصورة.',
      name: 'rules_overview',
      desc: '',
      args: [rounds, perRound],
    );
  }

  /// `للمتسابق`
  String get rules_players {
    return Intl.message('للمتسابق', name: 'rules_players', desc: '', args: []);
  }

  /// `دور الحكم`
  String get rules_referee {
    return Intl.message('دور الحكم', name: 'rules_referee', desc: '', args: []);
  }

  /// `سؤال له إجابات كثيرة، ويذكر المتسابقان الإجابات بالتناوب.\nلا يوجد وقت محدد، والحكم ينتقل إلى السؤال التالي متى شاء.\nلكل متسابق تجاوز واحد في السؤال: إن لم تكن لديه إجابة ينتقل الدور لمنافسه دون خطأ.\nلكل متسابق {strikes} أخطاء في السؤال، وبآخرها يفوز منافسه: {cleanPoints} إن لم يخطئ أبدًا، وإلا {points}.`
  String rules_what_do_you_know(
    String strikes,
    String cleanPoints,
    String points,
  ) {
    return Intl.message(
      'سؤال له إجابات كثيرة، ويذكر المتسابقان الإجابات بالتناوب.\nلا يوجد وقت محدد، والحكم ينتقل إلى السؤال التالي متى شاء.\nلكل متسابق تجاوز واحد في السؤال: إن لم تكن لديه إجابة ينتقل الدور لمنافسه دون خطأ.\nلكل متسابق $strikes أخطاء في السؤال، وبآخرها يفوز منافسه: $cleanPoints إن لم يخطئ أبدًا، وإلا $points.',
      name: 'rules_what_do_you_know',
      desc: '',
      args: [strikes, cleanPoints, points],
    );
  }

  /// `اقرأ السؤال، واضغط «صحيح» لكل إجابة صحيحة أو «خطأ» للخطأ، ويتبدل الدور تلقائيًا. وإن طلب المتسابق التجاوز فاضغط «تجاوز» (مرة واحدة لكل متسابق). انتقل إلى السؤال التالي متى رأيت.`
  String get referee_what_do_you_know {
    return Intl.message(
      'اقرأ السؤال، واضغط «صحيح» لكل إجابة صحيحة أو «خطأ» للخطأ، ويتبدل الدور تلقائيًا. وإن طلب المتسابق التجاوز فاضغط «تجاوز» (مرة واحدة لكل متسابق). انتقل إلى السؤال التالي متى رأيت.',
      name: 'referee_what_do_you_know',
      desc: '',
      args: [],
    );
  }

  /// `تُعرض أول آية في صفحة، ويكتب كل متسابق سرًا عدد آيات الصفحة خلال {time}.\nمن أصاب العدد أخذ {points}، وإلا فالأقرب.\nإن أصاب الاثنان أخذها الأسرع إجابةً، وإن كتبا العدد الخاطئ نفسه فلا نقطة لأحد.`
  String rules_ayah_number(String time, String points) {
    return Intl.message(
      'تُعرض أول آية في صفحة، ويكتب كل متسابق سرًا عدد آيات الصفحة خلال $time.\nمن أصاب العدد أخذ $points، وإلا فالأقرب.\nإن أصاب الاثنان أخذها الأسرع إجابةً، وإن كتبا العدد الخاطئ نفسه فلا نقطة لأحد.',
      name: 'rules_ayah_number',
      desc: '',
      args: [time, points],
    );
  }

  /// `اقرأ الآية للمتسابقين، وبعد أن يكتبا العدد اضغط «اكشف الإجابات».`
  String get referee_ayah_number {
    return Intl.message(
      'اقرأ الآية للمتسابقين، وبعد أن يكتبا العدد اضغط «اكشف الإجابات».',
      name: 'referee_ayah_number',
      desc: '',
      args: [],
    );
  }

  /// `فئة لها عدد معروف من الآيات يظهر للمتسابقَين، والمزايدة علنية وبالتناوب: يبدأ أحدهما (عشوائيًا في أول سؤال، ثم بالتبادل) ثم يرد الآخر.\nكل مزايدة يجب أن تزيد على الأخيرة وتعيد العدّاد {bid}، ومن زايد على العدد الكلي انتهت المزايدة له.\nيمكن للمتسابق أن يقول «تفضّل» فيسرد صاحب أعلى مزايدة، وكذلك عند انتهاء الوقت.\nيذكر ما زايد عليه خلال {recite}: إن أكمل أخذ نقطة لما دون ٢٠، ونقطتين من ٢٠، و٣ من ٣٠، وهكذا؛ وإلا أخذ منافسه {points}.`
  String rules_auction(String bid, String recite, String points) {
    return Intl.message(
      'فئة لها عدد معروف من الآيات يظهر للمتسابقَين، والمزايدة علنية وبالتناوب: يبدأ أحدهما (عشوائيًا في أول سؤال، ثم بالتبادل) ثم يرد الآخر.\nكل مزايدة يجب أن تزيد على الأخيرة وتعيد العدّاد $bid، ومن زايد على العدد الكلي انتهت المزايدة له.\nيمكن للمتسابق أن يقول «تفضّل» فيسرد صاحب أعلى مزايدة، وكذلك عند انتهاء الوقت.\nيذكر ما زايد عليه خلال $recite: إن أكمل أخذ نقطة لما دون ٢٠، ونقطتين من ٢٠، و٣ من ٣٠، وهكذا؛ وإلا أخذ منافسه $points.',
      name: 'rules_auction',
      desc: '',
      args: [bid, recite, points],
    );
  }

  /// `أعلن الفئة وتابع المزايدة، ويمكنك إغلاقها بـ «أغلق المزايدة». ثم اضغط «صحيح» إن أكمل المتسابق ما زايد عليه أو «خطأ» إن أخطأ.`
  String get referee_auction {
    return Intl.message(
      'أعلن الفئة وتابع المزايدة، ويمكنك إغلاقها بـ «أغلق المزايدة». ثم اضغط «صحيح» إن أكمل المتسابق ما زايد عليه أو «خطأ» إن أخطأ.',
      name: 'referee_auction',
      desc: '',
      args: [],
    );
  }

  /// `تُعرض بداية مشتركة بين عدة مواضع، ولا يوجد جرس: أي متسابق يجيب مباشرة بصوته.\nالإجابة الصحيحة خلال {fast} = {fastPoints}، وحتى {slow} = {slowPoints}، وبعدها لا يأخذ أحد شيئًا.\nلكل متسابق {strikes} أخطاء، وبعدها لا يحق له الإجابة.`
  String rules_similar(
    String fast,
    String fastPoints,
    String slow,
    String slowPoints,
    String strikes,
  ) {
    return Intl.message(
      'تُعرض بداية مشتركة بين عدة مواضع، ولا يوجد جرس: أي متسابق يجيب مباشرة بصوته.\nالإجابة الصحيحة خلال $fast = $fastPoints، وحتى $slow = $slowPoints، وبعدها لا يأخذ أحد شيئًا.\nلكل متسابق $strikes أخطاء، وبعدها لا يحق له الإجابة.',
      name: 'rules_similar',
      desc: '',
      args: [fast, fastPoints, slow, slowPoints, strikes],
    );
  }

  /// `اقرأ البداية، وعندما يجيب أحدهما اضغط «صحيح» أو «خطأ» تحت اسمه.`
  String get referee_similar {
    return Intl.message(
      'اقرأ البداية، وعندما يجيب أحدهما اضغط «صحيح» أو «خطأ» تحت اسمه.',
      name: 'referee_similar',
      desc: '',
      args: [],
    );
  }

  /// `السؤال مخفي عن المتسابقين والجمهور، والحكم يقرؤه بصوته.\nأول من يضغط الجرس خلال {time} يجيب، والإجابة الصحيحة {points}.\nإن أخطأ يظهر السؤال كاملًا للجميع ويجيب منافسه، وإن أخطأ هو أيضًا فلا نقطة.`
  String rules_buzzer(String time, String points) {
    return Intl.message(
      'السؤال مخفي عن المتسابقين والجمهور، والحكم يقرؤه بصوته.\nأول من يضغط الجرس خلال $time يجيب، والإجابة الصحيحة $points.\nإن أخطأ يظهر السؤال كاملًا للجميع ويجيب منافسه، وإن أخطأ هو أيضًا فلا نقطة.',
      name: 'rules_buzzer',
      desc: '',
      args: [time, points],
    );
  }

  /// `اقرأ السؤال بصوت واضح (يظهر لك وحدك)، ثم احكم بـ «صحيح» أو «خطأ» على من ضغط أولًا.`
  String get referee_buzzer {
    return Intl.message(
      'اقرأ السؤال بصوت واضح (يظهر لك وحدك)، ثم احكم بـ «صحيح» أو «خطأ» على من ضغط أولًا.',
      name: 'referee_buzzer',
      desc: '',
      args: [],
    );
  }

  /// `للحكم في كل الفقرات`
  String get rules_referee_general_title {
    return Intl.message(
      'للحكم في كل الفقرات',
      name: 'rules_referee_general_title',
      desc: '',
      args: [],
    );
  }

  /// `يمكنك دائمًا «سؤال بديل» لتبديل السؤال، ويظهر للمتسابقين أنه بديل، وإن كان محسومًا تُلغى نقاطه.\nويمكنك دائمًا «السؤال التالي»، وإن لم يُحسم السؤال فلا نقطة لأحد.\nأنت من يبدأ المباراة بعد دخول المتسابقَين.`
  String get rules_referee_general {
    return Intl.message(
      'يمكنك دائمًا «سؤال بديل» لتبديل السؤال، ويظهر للمتسابقين أنه بديل، وإن كان محسومًا تُلغى نقاطه.\nويمكنك دائمًا «السؤال التالي»، وإن لم يُحسم السؤال فلا نقطة لأحد.\nأنت من يبدأ المباراة بعد دخول المتسابقَين.',
      name: 'rules_referee_general',
      desc: '',
      args: [],
    );
  }

  /// `لا مزايدات بعد: ابدأ المزايدة`
  String get match_bid_none {
    return Intl.message(
      'لا مزايدات بعد: ابدأ المزايدة',
      name: 'match_bid_none',
      desc: '',
      args: [],
    );
  }

  /// `أعلى مزايدة: {bid} لـ {name}`
  String match_bid_high(String bid, String name) {
    return Intl.message(
      'أعلى مزايدة: $bid لـ $name',
      name: 'match_bid_high',
      desc: '',
      args: [bid, name],
    );
  }

  /// `مزايدتك الأعلى: {bid}، بانتظار منافسك`
  String match_bid_you_high(String bid) {
    return Intl.message(
      'مزايدتك الأعلى: $bid، بانتظار منافسك',
      name: 'match_bid_you_high',
      desc: '',
      args: [bid],
    );
  }

  /// `أكثر من {n}`
  String match_bid_more_than(String n) {
    return Intl.message(
      'أكثر من $n',
      name: 'match_bid_more_than',
      desc: '',
      args: [n],
    );
  }

  /// `زايِد`
  String get match_bid_raise {
    return Intl.message('زايِد', name: 'match_bid_raise', desc: '', args: []);
  }

  /// `تفضّل، اسرد أنت`
  String get match_bid_pass {
    return Intl.message(
      'تفضّل، اسرد أنت',
      name: 'match_bid_pass',
      desc: '',
      args: [],
    );
  }

  /// `كل مزايدة تعيد العدّاد دقيقة، وعند انتهائه يسرد صاحب أعلى مزايدة`
  String get match_bid_hint {
    return Intl.message(
      'كل مزايدة تعيد العدّاد دقيقة، وعند انتهائه يسرد صاحب أعلى مزايدة',
      name: 'match_bid_hint',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد جرس: أجب بصوتك مباشرة`
  String get match_similar_speak {
    return Intl.message(
      'لا يوجد جرس: أجب بصوتك مباشرة',
      name: 'match_similar_speak',
      desc: '',
      args: [],
    );
  }

  /// `استنفدت محاولاتك الثلاث`
  String get match_similar_out {
    return Intl.message(
      'استنفدت محاولاتك الثلاث',
      name: 'match_similar_out',
      desc: '',
      args: [],
    );
  }

  /// `احكم على من أجاب منهما`
  String get match_similar_referee {
    return Intl.message(
      'احكم على من أجاب منهما',
      name: 'match_similar_referee',
      desc: '',
      args: [],
    );
  }

  /// `سؤال الحسم`
  String get match_tiebreak_chip {
    return Intl.message(
      'سؤال الحسم',
      name: 'match_tiebreak_chip',
      desc: '',
      args: [],
    );
  }

  /// `إعداد المباراة`
  String get setup_title {
    return Intl.message(
      'إعداد المباراة',
      name: 'setup_title',
      desc: '',
      args: [],
    );
  }

  /// `المباراة غير منشورة: لن يدخلها المتسابقون حتى تنشرها. اختر أسئلة كل فقرة أو اتركها لتُختار عشوائيًا.`
  String get setup_draft_note {
    return Intl.message(
      'المباراة غير منشورة: لن يدخلها المتسابقون حتى تنشرها. اختر أسئلة كل فقرة أو اتركها لتُختار عشوائيًا.',
      name: 'setup_draft_note',
      desc: '',
      args: [],
    );
  }

  /// `{n} من {total}`
  String setup_count(String n, String total) {
    return Intl.message(
      '$n من $total',
      name: 'setup_count',
      desc: '',
      args: [n, total],
    );
  }

  /// `الباقي عشوائي`
  String get setup_random_rest {
    return Intl.message(
      'الباقي عشوائي',
      name: 'setup_random_rest',
      desc: '',
      args: [],
    );
  }

  /// `من البنك`
  String get setup_from_bank {
    return Intl.message(
      'من البنك',
      name: 'setup_from_bank',
      desc: '',
      args: [],
    );
  }

  /// `توليد`
  String get setup_generate {
    return Intl.message('توليد', name: 'setup_generate', desc: '', args: []);
  }

  /// `سؤال جديد`
  String get setup_new {
    return Intl.message('سؤال جديد', name: 'setup_new', desc: '', args: []);
  }

  /// `لا أسئلة محفوظة لهذه الفقرة. جرّب «توليد».`
  String get setup_bank_empty {
    return Intl.message(
      'لا أسئلة محفوظة لهذه الفقرة. جرّب «توليد».',
      name: 'setup_bank_empty',
      desc: '',
      args: [],
    );
  }

  /// `إضافة ({n})`
  String setup_add_selected(String n) {
    return Intl.message(
      'إضافة ($n)',
      name: 'setup_add_selected',
      desc: '',
      args: [n],
    );
  }

  /// `اكتملت أسئلة هذه الفقرة`
  String get setup_full {
    return Intl.message(
      'اكتملت أسئلة هذه الفقرة',
      name: 'setup_full',
      desc: '',
      args: [],
    );
  }

  /// `نشر المباراة`
  String get setup_publish {
    return Intl.message(
      'نشر المباراة',
      name: 'setup_publish',
      desc: '',
      args: [],
    );
  }

  /// `بعد النشر يستطيع المتسابقان الدخول برقم المباراة`
  String get setup_publish_hint {
    return Intl.message(
      'بعد النشر يستطيع المتسابقان الدخول برقم المباراة',
      name: 'setup_publish_hint',
      desc: '',
      args: [],
    );
  }

  /// `نص السؤال`
  String get setup_prompt {
    return Intl.message('نص السؤال', name: 'setup_prompt', desc: '', args: []);
  }

  /// `الإجابة`
  String get setup_answer {
    return Intl.message('الإجابة', name: 'setup_answer', desc: '', args: []);
  }

  /// `الآيات (سورة:آية، مفصولة بفواصل)`
  String get setup_refs {
    return Intl.message(
      'الآيات (سورة:آية، مفصولة بفواصل)',
      name: 'setup_refs',
      desc: '',
      args: [],
    );
  }

  /// `رقم الصفحة (١–٦٠٤)`
  String get setup_page {
    return Intl.message(
      'رقم الصفحة (١–٦٠٤)',
      name: 'setup_page',
      desc: '',
      args: [],
    );
  }

  /// `إضافة`
  String get setup_add {
    return Intl.message('إضافة', name: 'setup_add', desc: '', args: []);
  }

  /// `صفحة {page}`
  String setup_page_label(String page) {
    return Intl.message(
      'صفحة $page',
      name: 'setup_page_label',
      desc: '',
      args: [page],
    );
  }

  /// `لم ينشر الحكم هذه المباراة بعد`
  String get match_err_not_published {
    return Intl.message(
      'لم ينشر الحكم هذه المباراة بعد',
      name: 'match_err_not_published',
      desc: '',
      args: [],
    );
  }

  /// `{n} ثانية`
  String rules_secs(String n) {
    return Intl.message('$n ثانية', name: 'rules_secs', desc: '', args: [n]);
  }

  /// `دقيقة`
  String get rules_minute {
    return Intl.message('دقيقة', name: 'rules_minute', desc: '', args: []);
  }

  /// `نقطة`
  String get rules_point1 {
    return Intl.message('نقطة', name: 'rules_point1', desc: '', args: []);
  }

  /// `نقطتان`
  String get rules_point2 {
    return Intl.message('نقطتان', name: 'rules_point2', desc: '', args: []);
  }

  /// `{n} نقاط`
  String rules_points(String n) {
    return Intl.message('$n نقاط', name: 'rules_points', desc: '', args: [n]);
  }

  /// `لا يوجد تعادل: إن تساوت النقاط في النهاية يُطرح سؤال حسم من الفقرة الأخيرة حتى يتقدم أحدهما.`
  String get rules_overview_tiebreak {
    return Intl.message(
      'لا يوجد تعادل: إن تساوت النقاط في النهاية يُطرح سؤال حسم من الفقرة الأخيرة حتى يتقدم أحدهما.',
      name: 'rules_overview_tiebreak',
      desc: '',
      args: [],
    );
  }

  /// `تجاوز (مرة واحدة)`
  String get match_pass_turn {
    return Intl.message(
      'تجاوز (مرة واحدة)',
      name: 'match_pass_turn',
      desc: '',
      args: [],
    );
  }

  /// `تجاوز لـ {name}`
  String match_pass_for(String name) {
    return Intl.message(
      'تجاوز لـ $name',
      name: 'match_pass_for',
      desc: '',
      args: [name],
    );
  }

  /// `تجاوز`
  String get match_passed {
    return Intl.message('تجاوز', name: 'match_passed', desc: '', args: []);
  }

  /// `السرد`
  String get round_sard {
    return Intl.message('السرد', name: 'round_sard', desc: '', args: []);
  }

  /// `قل آخر كلمة في هذه الآية`
  String get round_hint_sard {
    return Intl.message(
      'قل آخر كلمة في هذه الآية',
      name: 'round_hint_sard',
      desc: '',
      args: [],
    );
  }

  /// `تُعرض أول كلمة من آية، وإن شاركتها آيات أخرى في بدايتها تُعرض كلمتان أو أكثر حتى تتميز.\nيقول المتسابق آخر كلمة في الآية مباشرة بصوته، ومن أصاب أخذ {points}.\nلكل متسابق {strikes} محاولات، وإن انتهت {time} فلا نقطة لأحد.`
  String rules_sard(String points, String strikes, String time) {
    return Intl.message(
      'تُعرض أول كلمة من آية، وإن شاركتها آيات أخرى في بدايتها تُعرض كلمتان أو أكثر حتى تتميز.\nيقول المتسابق آخر كلمة في الآية مباشرة بصوته، ومن أصاب أخذ $points.\nلكل متسابق $strikes محاولات، وإن انتهت $time فلا نقطة لأحد.',
      name: 'rules_sard',
      desc: '',
      args: [points, strikes, time],
    );
  }

  /// `اقرأ بداية الآية، وعندما يجيب أحدهما اضغط «صحيح» أو «خطأ» تحت اسمه.`
  String get referee_sard {
    return Intl.message(
      'اقرأ بداية الآية، وعندما يجيب أحدهما اضغط «صحيح» أو «خطأ» تحت اسمه.',
      name: 'referee_sard',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد جرس: قل آخر كلمة في الآية بصوتك`
  String get match_sard_speak {
    return Intl.message(
      'لا يوجد جرس: قل آخر كلمة في الآية بصوتك',
      name: 'match_sard_speak',
      desc: '',
      args: [],
    );
  }

  /// `استنفدت محاولاتك`
  String get match_sard_out {
    return Intl.message(
      'استنفدت محاولاتك',
      name: 'match_sard_out',
      desc: '',
      args: [],
    );
  }

  /// `الآية (سورة:آية)`
  String get setup_sard_ayah {
    return Intl.message(
      'الآية (سورة:آية)',
      name: 'setup_sard_ayah',
      desc: '',
      args: [],
    );
  }

  /// `يمين يسار`
  String get round_right_left {
    return Intl.message(
      'يمين يسار',
      name: 'round_right_left',
      desc: '',
      args: [],
    );
  }

  /// `هل هذه الآية في الصفحة اليمنى أم اليسرى؟`
  String get round_hint_right_left {
    return Intl.message(
      'هل هذه الآية في الصفحة اليمنى أم اليسرى؟',
      name: 'round_hint_right_left',
      desc: '',
      args: [],
    );
  }

  /// `لكل متسابق دوره: {count} بدايات آيات تظهر واحدة تلو الأخرى، وكل بداية لا تشاركها آية أخرى.\nيحدد المتسابق خلال {time} هل الآية في الصفحة اليمنى أم اليسرى، وإن انتهى الوقت لا تُحتسب.\nلا يعرف المتسابق نتيجته حتى تنتهي بداياته، ثم يأتي دور منافسه.\nصاحب الإجابات الصحيحة الأكثر يأخذ {points}، وعند التساوي لا نقطة لأحد.`
  String rules_right_left(String count, String time, String points) {
    return Intl.message(
      'لكل متسابق دوره: $count بدايات آيات تظهر واحدة تلو الأخرى، وكل بداية لا تشاركها آية أخرى.\nيحدد المتسابق خلال $time هل الآية في الصفحة اليمنى أم اليسرى، وإن انتهى الوقت لا تُحتسب.\nلا يعرف المتسابق نتيجته حتى تنتهي بداياته، ثم يأتي دور منافسه.\nصاحب الإجابات الصحيحة الأكثر يأخذ $points، وعند التساوي لا نقطة لأحد.',
      name: 'rules_right_left',
      desc: '',
      args: [count, time, points],
    );
  }

  /// `اضغط «ابدأ دور» لكل متسابق حين يكون جاهزًا؛ الإجابات تُحتسب تلقائيًا من هاتفه، وترى أنت الإجابة الصحيحة لكل بداية.`
  String get referee_right_left {
    return Intl.message(
      'اضغط «ابدأ دور» لكل متسابق حين يكون جاهزًا؛ الإجابات تُحتسب تلقائيًا من هاتفه، وترى أنت الإجابة الصحيحة لكل بداية.',
      name: 'referee_right_left',
      desc: '',
      args: [],
    );
  }

  /// `يمين`
  String get rl_right {
    return Intl.message('يمين', name: 'rl_right', desc: '', args: []);
  }

  /// `يسار`
  String get rl_left {
    return Intl.message('يسار', name: 'rl_left', desc: '', args: []);
  }

  /// `استعد: دورك ({count} بدايات، {time} لكل منها)`
  String rl_get_ready(String count, String time) {
    return Intl.message(
      'استعد: دورك ($count بدايات، $time لكل منها)',
      name: 'rl_get_ready',
      desc: '',
      args: [count, time],
    );
  }

  /// `دور {name}، بانتظار أن يبدأ الحكم`
  String rl_waiting_run(String name) {
    return Intl.message(
      'دور $name، بانتظار أن يبدأ الحكم',
      name: 'rl_waiting_run',
      desc: '',
      args: [name],
    );
  }

  /// `دور {name}: {n} من {total}`
  String rl_running_other(String name, String n, String total) {
    return Intl.message(
      'دور $name: $n من $total',
      name: 'rl_running_other',
      desc: '',
      args: [name, n, total],
    );
  }

  /// `{n} من {total}`
  String rl_progress(String n, String total) {
    return Intl.message(
      '$n من $total',
      name: 'rl_progress',
      desc: '',
      args: [n, total],
    );
  }

  /// `ابدأ دور {name}`
  String rl_start_run(String name) {
    return Intl.message(
      'ابدأ دور $name',
      name: 'rl_start_run',
      desc: '',
      args: [name],
    );
  }

  /// `الإجابة: {side} · صفحة {page} · {surah} {ayah}`
  String rl_key(String side, String page, String surah, String ayah) {
    return Intl.message(
      'الإجابة: $side · صفحة $page · $surah $ayah',
      name: 'rl_key',
      desc: '',
      args: [side, page, surah, ayah],
    );
  }

  /// `{name}: {right} صحيحة من {total}`
  String rl_result(String name, String right, String total) {
    return Intl.message(
      '$name: $right صحيحة من $total',
      name: 'rl_result',
      desc: '',
      args: [name, right, total],
    );
  }

  /// `الآيات (عدد زوجي، ١٢ عادةً)`
  String get setup_rl_ayahs {
    return Intl.message(
      'الآيات (عدد زوجي، ١٢ عادةً)',
      name: 'setup_rl_ayahs',
      desc: '',
      args: [],
    );
  }

  /// `خط المصحف`
  String get quran_font {
    return Intl.message('خط المصحف', name: 'quran_font', desc: '', args: []);
  }

  /// `خط حفص (مجمع الملك فهد)`
  String get font_hafs {
    return Intl.message(
      'خط حفص (مجمع الملك فهد)',
      name: 'font_hafs',
      desc: '',
      args: [],
    );
  }

  /// `كالمصحف المطبوع`
  String get font_hafs_note {
    return Intl.message(
      'كالمصحف المطبوع',
      name: 'font_hafs_note',
      desc: '',
      args: [],
    );
  }

  /// `الأميري`
  String get font_amiri {
    return Intl.message('الأميري', name: 'font_amiri', desc: '', args: []);
  }

  /// `نوتو نسخ`
  String get font_noto {
    return Intl.message('نوتو نسخ', name: 'font_noto', desc: '', args: []);
  }

  /// `عام`
  String get group_default {
    return Intl.message('عام', name: 'group_default', desc: '', args: []);
  }

  /// `بدون مجموعة`
  String get group_default_note {
    return Intl.message(
      'بدون مجموعة',
      name: 'group_default_note',
      desc: '',
      args: [],
    );
  }

  /// `حفظ صفحة {page} في`
  String group_save_title(String page) {
    return Intl.message(
      'حفظ صفحة $page في',
      name: 'group_save_title',
      desc: '',
      args: [page],
    );
  }

  /// `مجموعة جديدة`
  String get group_new {
    return Intl.message('مجموعة جديدة', name: 'group_new', desc: '', args: []);
  }

  /// `اسم المجموعة`
  String get group_name {
    return Intl.message('اسم المجموعة', name: 'group_name', desc: '', args: []);
  }

  /// `مثل: ختمة التهجد`
  String get group_name_hint {
    return Intl.message(
      'مثل: ختمة التهجد',
      name: 'group_name_hint',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء`
  String get group_create {
    return Intl.message('إنشاء', name: 'group_create', desc: '', args: []);
  }

  /// `إنشاء وحفظ`
  String get group_create_save {
    return Intl.message(
      'إنشاء وحفظ',
      name: 'group_create_save',
      desc: '',
      args: [],
    );
  }

  /// `حذف المجموعة`
  String get group_delete {
    return Intl.message(
      'حذف المجموعة',
      name: 'group_delete',
      desc: '',
      args: [],
    );
  }

  /// `ستُنقل صفحات «{name}» إلى «عام».`
  String group_delete_body(String name) {
    return Intl.message(
      'ستُنقل صفحات «$name» إلى «عام».',
      name: 'group_delete_body',
      desc: '',
      args: [name],
    );
  }

  /// `لا صفحات في هذه المجموعة بعد`
  String get group_empty {
    return Intl.message(
      'لا صفحات في هذه المجموعة بعد',
      name: 'group_empty',
      desc: '',
      args: [],
    );
  }

  /// `حُفظت صفحة {page} في «{group}»`
  String page_saved_in(String page, String group) {
    return Intl.message(
      'حُفظت صفحة $page في «$group»',
      name: 'page_saved_in',
      desc: '',
      args: [page, group],
    );
  }

  /// `أنت تبدأ المزايدة`
  String get match_bid_your_open {
    return Intl.message(
      'أنت تبدأ المزايدة',
      name: 'match_bid_your_open',
      desc: '',
      args: [],
    );
  }

  /// `{name} يبدأ المزايدة`
  String match_bid_wait_open(String name) {
    return Intl.message(
      '$name يبدأ المزايدة',
      name: 'match_bid_wait_open',
      desc: '',
      args: [name],
    );
  }

  /// `الفقرات وعدد الأسئلة`
  String get setup_rounds_title {
    return Intl.message(
      'الفقرات وعدد الأسئلة',
      name: 'setup_rounds_title',
      desc: '',
      args: [],
    );
  }

  /// `اختر فقرة واحدة على الأقل وعدد أسئلة كل فقرة (٤ لكل فقرة افتراضيًا).`
  String get setup_rounds_hint {
    return Intl.message(
      'اختر فقرة واحدة على الأقل وعدد أسئلة كل فقرة (٤ لكل فقرة افتراضيًا).',
      name: 'setup_rounds_hint',
      desc: '',
      args: [],
    );
  }

  /// `المجموع: {n}`
  String setup_rounds_total(String n) {
    return Intl.message(
      'المجموع: $n',
      name: 'setup_rounds_total',
      desc: '',
      args: [n],
    );
  }

  /// `اختر فقرة واحدة على الأقل`
  String get match_err_no_rounds {
    return Intl.message(
      'اختر فقرة واحدة على الأقل',
      name: 'match_err_no_rounds',
      desc: '',
      args: [],
    );
  }

  /// `عدد الأسئلة أكبر من المسموح`
  String get match_err_too_many {
    return Intl.message(
      'عدد الأسئلة أكبر من المسموح',
      name: 'match_err_too_many',
      desc: '',
      args: [],
    );
  }

  /// `حفظ`
  String get setup_count_save {
    return Intl.message('حفظ', name: 'setup_count_save', desc: '', args: []);
  }

  /// `أقصى مزايدة: {max}`
  String match_bid_max(String max) {
    return Intl.message(
      'أقصى مزايدة: $max',
      name: 'match_bid_max',
      desc: '',
      args: [max],
    );
  }

  /// `مزايدة {bid} تساوي {points} إن أكملتها`
  String match_bid_worth(String bid, String points) {
    return Intl.message(
      'مزايدة $bid تساوي $points إن أكملتها',
      name: 'match_bid_worth',
      desc: '',
      args: [bid, points],
    );
  }

  /// `نقطة`
  String get match_bid_points1 {
    return Intl.message('نقطة', name: 'match_bid_points1', desc: '', args: []);
  }

  /// `نقطتين`
  String get match_bid_points2 {
    return Intl.message(
      'نقطتين',
      name: 'match_bid_points2',
      desc: '',
      args: [],
    );
  }

  /// `{n} نقاط`
  String match_bid_points(String n) {
    return Intl.message(
      '$n نقاط',
      name: 'match_bid_points',
      desc: '',
      args: [n],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

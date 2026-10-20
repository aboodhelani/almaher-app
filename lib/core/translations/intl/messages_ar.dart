// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(version) => "الإصدار ${version}";

  static String m1(count) => "${count} آية";

  static String m2(name) => "ستُنقل صفحات «${name}» إلى «عام».";

  static String m3(page) => "حفظ صفحة ${page} في";

  static String m4(page) => "تابع القراءة · صفحة ${page}";

  static String m5(name) => "حذف ${name}؟";

  static String m6(count) => "${count} سورة محمّلة";

  static String m7(said, total) => "مفتاح الإجابة (${said} من ${total})";

  static String m8(count) => "العدد الكلي: ${count}";

  static String m9(bid, name) => "أعلى مزايدة: ${bid} لـ ${name}";

  static String m10(max) => "أقصى مزايدة: ${max}";

  static String m11(n) => "أكثر من ${n}";

  static String m12(n) => "${n} نقاط";

  static String m13(count) => "مزايدتك: ${count}، بانتظار الحكم";

  static String m14(name) => "${name} يبدأ المزايدة";

  static String m15(bid, points) => "مزايدة ${bid} تساوي ${points} إن أكملتها";

  static String m16(bid) => "مزايدتك الأعلى: ${bid}، بانتظار منافسك";

  static String m17(wrong, name) => "أخطأ ${wrong}، يجيب الآن ${name}";

  static String m18(name) => "${name} ضغط الجرس";

  static String m19(name, count) => "${name} يسرد الآن: ${count}";

  static String m20(surah, page, count) => "صفحة ${page} (${surah}) · ${count}";

  static String m21(name) => "تجاوز لـ ${name}";

  static String m22(count) => "${count} نقاط";

  static String m23(round, rounds, q, qs, n, total) =>
      "الفقرة ${round} من ${rounds} · السؤال ${q} من ${qs} · (${n}/${total})";

  static String m24(current, total) => "السؤال ${current} من ${total}";

  static String m25(round, rounds, q, qs) =>
      "الفقرة ${round} من ${rounds} · السؤال ${q} من ${qs}";

  static String m26(value) => "${value} ث";

  static String m27(n) => "ابدأ المباراة (${n} سؤالًا)";

  static String m28(name) => "دور ${name}";

  static String m29(name) => "الفائز: ${name}";

  static String m30(count) => "قيمة السؤال الآن: ${count} نقاط";

  static String m31(name) => "أنت ${name}";

  static String m32(count) => "أنت تسرد الآن: ${count}";

  static String m33(page) => "حُفظت الصفحة ${page}";

  static String m34(page, group) => "حُفظت صفحة ${page} في «${group}»";

  static String m35(page) => "أُزيلت الصفحة ${page} من المحفوظات";

  static String m36(name) => "تلعب باسم ${name}";

  static String m37(name) => "ضد ${name}";

  static String m38(rate) => "نسبة الفوز ${rate}٪";

  static String m39(percent) => "جارٍ التحميل ${percent}";

  static String m40(count, time) =>
      "استعد: دورك (${count} بدايات، ${time} لكل منها)";

  static String m41(side, page, surah, ayah) =>
      "الإجابة: ${side} · صفحة ${page} · ${surah} ${ayah}";

  static String m42(n, total) => "${n} من ${total}";

  static String m43(name, right, total) =>
      "${name}: ${right} صحيحة من ${total}";

  static String m44(name, n, total) => "دور ${name}: ${n} من ${total}";

  static String m45(name) => "ابدأ دور ${name}";

  static String m46(name) => "دور ${name}، بانتظار أن يبدأ الحكم";

  static String m47(strikes) =>
      "أجيبا بالتناوب: لكل متسابق ${strikes} أخطاء وتجاوز واحد";

  static String m48(bid, recite, points) =>
      "فئة لها عدد معروف من الآيات يظهر للمتسابقَين، والمزايدة علنية وبالتناوب: يبدأ أحدهما (عشوائيًا في أول سؤال، ثم بالتبادل) ثم يرد الآخر.\nكل مزايدة يجب أن تزيد على الأخيرة وتعيد العدّاد ${bid}، ومن زايد على العدد الكلي انتهت المزايدة له.\nيمكن للمتسابق أن يقول «تفضّل» فيسرد صاحب أعلى مزايدة، وكذلك عند انتهاء الوقت.\nيذكر ما زايد عليه خلال ${recite}: إن أكمل أخذ نقطة لما دون ٢٠، ونقطتين من ٢٠، و٣ من ٣٠، وهكذا؛ وإلا أخذ منافسه ${points}.";

  static String m49(time, points) =>
      "تُعرض أول آية في صفحة، ويكتب كل متسابق سرًا عدد آيات الصفحة خلال ${time}.\nمن أصاب العدد أخذ ${points}، وإلا فالأقرب.\nإن أصاب الاثنان أخذها الأسرع إجابةً، وإن كتبا العدد الخاطئ نفسه فلا نقطة لأحد.";

  static String m50(time, points) =>
      "السؤال مخفي عن المتسابقين والجمهور، والحكم يقرؤه بصوته.\nأول من يضغط الجرس خلال ${time} يجيب، والإجابة الصحيحة ${points}.\nإن أخطأ يظهر السؤال كاملًا للجميع ويجيب منافسه، وإن أخطأ هو أيضًا فلا نقطة.";

  static String m51(rounds, perRound) =>
      "متسابقان وحكم، والمباراة ${rounds} فقرات في كل منها ${perRound} أسئلة.\nيُعدّ الحكم المباراة ويختار أسئلتها أو يتركها عشوائية، ثم ينشرها ليدخل المتسابقان برقمها.\nالعبوا في نفس المكان، أو عن بُعد بالصوت والصورة.";

  static String m52(n) => "${n} نقاط";

  static String m53(count, time, points) =>
      "لكل متسابق دوره: ${count} بدايات آيات تظهر واحدة تلو الأخرى، وكل بداية لا تشاركها آية أخرى.\nيحدد المتسابق خلال ${time} هل الآية في الصفحة اليمنى أم اليسرى، وإن انتهى الوقت لا تُحتسب.\nلا يعرف المتسابق نتيجته حتى تنتهي بداياته، ثم يأتي دور منافسه.\nصاحب الإجابات الصحيحة الأكثر يأخذ ${points}، وعند التساوي لا نقطة لأحد.";

  static String m54(points, strikes, time) =>
      "تُعرض أول كلمة من آية، وإن شاركتها آيات أخرى في بدايتها تُعرض كلمتان أو أكثر حتى تتميز.\nيقول المتسابق آخر كلمة في الآية مباشرة بصوته، ومن أصاب أخذ ${points}.\nلكل متسابق ${strikes} محاولات، وإن انتهت ${time} فلا نقطة لأحد.";

  static String m55(n) => "${n} ثانية";

  static String m56(fast, fastPoints, slow, slowPoints, strikes) =>
      "تُعرض بداية مشتركة بين عدة مواضع، ولا يوجد جرس: أي متسابق يجيب مباشرة بصوته.\nالإجابة الصحيحة خلال ${fast} = ${fastPoints}، وحتى ${slow} = ${slowPoints}، وبعدها لا يأخذ أحد شيئًا.\nلكل متسابق ${strikes} أخطاء، وبعدها لا يحق له الإجابة.";

  static String m57(strikes, cleanPoints, points) =>
      "سؤال له إجابات كثيرة، ويذكر المتسابقان الإجابات بالتناوب.\nلا يوجد وقت محدد، والحكم ينتقل إلى السؤال التالي متى شاء.\nلكل متسابق تجاوز واحد في السؤال: إن لم تكن لديه إجابة ينتقل الدور لمنافسه دون خطأ.\nلكل متسابق ${strikes} أخطاء في السؤال، وبآخرها يفوز منافسه: ${cleanPoints} إن لم يخطئ أبدًا، وإلا ${points}.";

  static String m58(count) => "${count} صفحة محفوظة";

  static String m59(n) => "إضافة (${n})";

  static String m60(n, total) => "${n} من ${total}";

  static String m61(page) => "صفحة ${page}";

  static String m62(n) => "المجموع: ${n}";

  static String m63(count) =>
      "لا توجد آية تشترك معها في ${count} كلمات متتالية أو أكثر";

  static String m64(count) => "${count} كلمات";

  static String m65(page) => "ص ${page}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("عن التطبيق والخصوصية"),
        "about_subtitle": MessageLookupByLibrary.simpleMessage(
            "سياسة الخصوصية ومصادر المحتوى"),
        "about_tagline": MessageLookupByLibrary.simpleMessage(
            "مصحف للقراءة والتجويد، ومسابقة للحفّاظ"),
        "about_version": m0,
        "app_name": MessageLookupByLibrary.simpleMessage("الماهر"),
        "appearance": MessageLookupByLibrary.simpleMessage("المظهر"),
        "arabic": MessageLookupByLibrary.simpleMessage("العربية"),
        "auth_email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "auth_err_email_taken": MessageLookupByLibrary.simpleMessage(
            "هذا البريد مسجّل بالفعل، سجّل الدخول"),
        "auth_err_generic": MessageLookupByLibrary.simpleMessage(
            "تعذر إكمال الطلب، حاول مرة أخرى"),
        "auth_err_invalid_credentials": MessageLookupByLibrary.simpleMessage(
            "البريد أو كلمة المرور غير صحيحة"),
        "auth_err_invalid_email":
            MessageLookupByLibrary.simpleMessage("البريد الإلكتروني غير صحيح"),
        "auth_err_name": MessageLookupByLibrary.simpleMessage(
            "اكتب اسمًا من حرفين على الأقل"),
        "auth_err_weak_password": MessageLookupByLibrary.simpleMessage(
            "كلمة المرور ٦ أحرف على الأقل"),
        "auth_gate_subtitle": MessageLookupByLibrary.simpleMessage(
            "سجّل الدخول أو أنشئ حسابًا لتلعب وتُحفظ نتائجك. القراءة متاحة للجميع دون حساب."),
        "auth_gate_title":
            MessageLookupByLibrary.simpleMessage("المسابقة تحتاج حسابًا"),
        "auth_login": MessageLookupByLibrary.simpleMessage("دخول"),
        "auth_login_title":
            MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "auth_name":
            MessageLookupByLibrary.simpleMessage("الاسم الظاهر للمنافسين"),
        "auth_password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "auth_register": MessageLookupByLibrary.simpleMessage("إنشاء الحساب"),
        "auth_register_title":
            MessageLookupByLibrary.simpleMessage("حساب جديد"),
        "auth_to_login":
            MessageLookupByLibrary.simpleMessage("لديك حساب؟ سجّل الدخول"),
        "auth_to_register":
            MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟ أنشئ حسابًا"),
        "ayah_label": MessageLookupByLibrary.simpleMessage("آية"),
        "ayahs_count": m1,
        "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "dark_mode": MessageLookupByLibrary.simpleMessage("الوضع الليلي"),
        "dark_mode_subtitle":
            MessageLookupByLibrary.simpleMessage("خلفية سوداء ونص أبيض"),
        "delete_account": MessageLookupByLibrary.simpleMessage("حذف الحساب"),
        "delete_account_body": MessageLookupByLibrary.simpleMessage(
            "سيُحذف حسابك نهائيًا، وتبقى مبارياتك السابقة في السجل دون اسمك. أدخل كلمة المرور للتأكيد."),
        "delete_account_confirm":
            MessageLookupByLibrary.simpleMessage("حذف نهائي"),
        "delete_account_done":
            MessageLookupByLibrary.simpleMessage("تم حذف حسابك"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "failed_to_load_quran":
            MessageLookupByLibrary.simpleMessage("تعذر تحميل المصحف"),
        "font_amiri": MessageLookupByLibrary.simpleMessage("الأميري"),
        "font_hafs":
            MessageLookupByLibrary.simpleMessage("خط حفص (مجمع الملك فهد)"),
        "font_hafs_note":
            MessageLookupByLibrary.simpleMessage("كالمصحف المطبوع"),
        "font_noto": MessageLookupByLibrary.simpleMessage("نوتو نسخ"),
        "game_sounds": MessageLookupByLibrary.simpleMessage("أصوات المسابقة"),
        "game_sounds_subtitle": MessageLookupByLibrary.simpleMessage(
            "الجرس، الإجابة الصحيحة والخاطئة، والثواني الأخيرة"),
        "group_create": MessageLookupByLibrary.simpleMessage("إنشاء"),
        "group_create_save": MessageLookupByLibrary.simpleMessage("إنشاء وحفظ"),
        "group_default": MessageLookupByLibrary.simpleMessage("عام"),
        "group_default_note":
            MessageLookupByLibrary.simpleMessage("بدون مجموعة"),
        "group_delete": MessageLookupByLibrary.simpleMessage("حذف المجموعة"),
        "group_delete_body": m2,
        "group_empty": MessageLookupByLibrary.simpleMessage(
            "لا صفحات في هذه المجموعة بعد"),
        "group_name": MessageLookupByLibrary.simpleMessage("اسم المجموعة"),
        "group_name_hint":
            MessageLookupByLibrary.simpleMessage("مثل: ختمة التهجد"),
        "group_new": MessageLookupByLibrary.simpleMessage("مجموعة جديدة"),
        "group_save_title": m3,
        "home_continue": m4,
        "home_greeting": MessageLookupByLibrary.simpleMessage("السلام عليكم"),
        "home_more": MessageLookupByLibrary.simpleMessage("المزيد"),
        "home_play": MessageLookupByLibrary.simpleMessage("المسابقة"),
        "home_play_now": MessageLookupByLibrary.simpleMessage("العب الآن"),
        "home_play_subtitle":
            MessageLookupByLibrary.simpleMessage("تحدَّ حافظًا آخر بوجود حكم"),
        "home_read": MessageLookupByLibrary.simpleMessage("قراءة القرآن"),
        "home_read_subtitle": MessageLookupByLibrary.simpleMessage(
            "المصحف مع التجويد والمتشابهات والبحث"),
        "home_rounds":
            MessageLookupByLibrary.simpleMessage("سبع فقرات · ٢٨ سؤالًا"),
        "home_settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
        "home_start_reading":
            MessageLookupByLibrary.simpleMessage("ابدأ القراءة"),
        "home_tajweed_guide":
            MessageLookupByLibrary.simpleMessage("دليل التجويد"),
        "juz": MessageLookupByLibrary.simpleMessage("الجزء"),
        "language": MessageLookupByLibrary.simpleMessage("اللغة"),
        "leaderboard": MessageLookupByLibrary.simpleMessage("لوحة المتصدرين"),
        "leaderboard_empty": MessageLookupByLibrary.simpleMessage(
            "لا توجد نتائج بعد، كن أول المتصدرين"),
        "library": MessageLookupByLibrary.simpleMessage("التفاسير والتلاوات"),
        "library_bundled": MessageLookupByLibrary.simpleMessage("مضمّن"),
        "library_delete": MessageLookupByLibrary.simpleMessage("حذف"),
        "library_delete_confirm": m5,
        "library_download": MessageLookupByLibrary.simpleMessage("تحميل"),
        "library_download_all":
            MessageLookupByLibrary.simpleMessage("تحميل الكل"),
        "library_download_failed": MessageLookupByLibrary.simpleMessage(
            "تعذّر التحميل. حاول مرة أخرى."),
        "library_downloaded": MessageLookupByLibrary.simpleMessage("محمّل"),
        "library_in_use": MessageLookupByLibrary.simpleMessage("مستخدم"),
        "library_offline": MessageLookupByLibrary.simpleMessage(
            "تعذّر تحميل القائمة. تحقق من اتصالك بالإنترنت."),
        "library_reciters": MessageLookupByLibrary.simpleMessage("القراء"),
        "library_search":
            MessageLookupByLibrary.simpleMessage("ابحث بالاسم أو اللغة"),
        "library_subtitle": MessageLookupByLibrary.simpleMessage(
            "حمّل تفسيرًا أو ترجمة أو قارئًا لتستخدمه دون إنترنت"),
        "library_surahs_count": m6,
        "library_tafsirs": MessageLookupByLibrary.simpleMessage("التفاسير"),
        "library_translations":
            MessageLookupByLibrary.simpleMessage("الترجمات"),
        "library_use": MessageLookupByLibrary.simpleMessage("استخدام"),
        "light_mode": MessageLookupByLibrary.simpleMessage("الوضع الفاتح"),
        "lobby_subtitle":
            MessageLookupByLibrary.simpleMessage("اختر دورك وابدأ المنافسة"),
        "lobby_title": MessageLookupByLibrary.simpleMessage("جاهز للتحدي؟"),
        "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
        "match_adjust_scores":
            MessageLookupByLibrary.simpleMessage("تعديل النقاط"),
        "match_answer_key": m7,
        "match_answer_label": MessageLookupByLibrary.simpleMessage("الإجابة"),
        "match_answered": MessageLookupByLibrary.simpleMessage("أجاب"),
        "match_answered_first": MessageLookupByLibrary.simpleMessage("الأسرع"),
        "match_answering_now":
            MessageLookupByLibrary.simpleMessage("يجيب الآن"),
        "match_auction_total": m8,
        "match_ayah_number_prompt":
            MessageLookupByLibrary.simpleMessage("ما رقم هذه الآية في سورتها؟"),
        "match_bid_high": m9,
        "match_bid_hint": MessageLookupByLibrary.simpleMessage(
            "كل مزايدة تعيد العدّاد دقيقة، وعند انتهائه يسرد صاحب أعلى مزايدة"),
        "match_bid_max": m10,
        "match_bid_more_than": m11,
        "match_bid_none": MessageLookupByLibrary.simpleMessage(
            "لا مزايدات بعد: ابدأ المزايدة"),
        "match_bid_pass":
            MessageLookupByLibrary.simpleMessage("تفضّل، اسرد أنت"),
        "match_bid_points": m12,
        "match_bid_points1": MessageLookupByLibrary.simpleMessage("نقطة"),
        "match_bid_points2": MessageLookupByLibrary.simpleMessage("نقطتين"),
        "match_bid_raise": MessageLookupByLibrary.simpleMessage("زايِد"),
        "match_bid_sent": m13,
        "match_bid_wait_open": m14,
        "match_bid_worth": m15,
        "match_bid_you_high": m16,
        "match_bid_your_open":
            MessageLookupByLibrary.simpleMessage("أنت تبدأ المزايدة"),
        "match_cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "match_close_bids":
            MessageLookupByLibrary.simpleMessage("أغلق المزايدة"),
        "match_code": MessageLookupByLibrary.simpleMessage("رمز المباراة"),
        "match_code_copied":
            MessageLookupByLibrary.simpleMessage("تم نسخ رمز المباراة"),
        "match_correct": MessageLookupByLibrary.simpleMessage("صحيح"),
        "match_create": MessageLookupByLibrary.simpleMessage("إنشاء مباراة"),
        "match_draw": MessageLookupByLibrary.simpleMessage("تعادل"),
        "match_enter_by_id":
            MessageLookupByLibrary.simpleMessage("دخول المباراة"),
        "match_err_already_answered":
            MessageLookupByLibrary.simpleMessage("أرسلت إجابتك بالفعل"),
        "match_err_already_player":
            MessageLookupByLibrary.simpleMessage("أنت متسابق في هذه المباراة"),
        "match_err_already_referee":
            MessageLookupByLibrary.simpleMessage("أنت الحكم في هذه المباراة"),
        "match_err_closed": MessageLookupByLibrary.simpleMessage(
            "انتهت المباراة السابقة أو أُغلقت"),
        "match_err_code_taken": MessageLookupByLibrary.simpleMessage(
            "هذا الرقم مستخدم لمباراة جارية"),
        "match_err_full":
            MessageLookupByLibrary.simpleMessage("المباراة مكتملة بالمتسابقين"),
        "match_err_generic":
            MessageLookupByLibrary.simpleMessage("حدث خطأ، حاول مرة أخرى"),
        "match_err_invalid_answer":
            MessageLookupByLibrary.simpleMessage("رقم غير صحيح"),
        "match_err_invalid_code": MessageLookupByLibrary.simpleMessage(
            "رقم المباراة من ٣ إلى ٢٠ حرفًا أو رقمًا بلا مسافات"),
        "match_err_login_required":
            MessageLookupByLibrary.simpleMessage("سجّل الدخول للعب"),
        "match_err_name": MessageLookupByLibrary.simpleMessage("اكتب اسمك"),
        "match_err_no_rounds":
            MessageLookupByLibrary.simpleMessage("اختر فقرة واحدة على الأقل"),
        "match_err_not_found":
            MessageLookupByLibrary.simpleMessage("لا توجد مباراة بهذا الرمز"),
        "match_err_not_published": MessageLookupByLibrary.simpleMessage(
            "لم ينشر الحكم هذه المباراة بعد"),
        "match_err_players_missing":
            MessageLookupByLibrary.simpleMessage("لم ينضم المتسابقان بعد"),
        "match_err_role_taken":
            MessageLookupByLibrary.simpleMessage("هذا الدور مأخوذ"),
        "match_err_time_up":
            MessageLookupByLibrary.simpleMessage("انتهى الوقت"),
        "match_err_too_many":
            MessageLookupByLibrary.simpleMessage("عدد الأسئلة أكبر من المسموح"),
        "match_err_unreachable":
            MessageLookupByLibrary.simpleMessage("تعذر الاتصال بالخادم"),
        "match_final_score":
            MessageLookupByLibrary.simpleMessage("النتيجة النهائية"),
        "match_find": MessageLookupByLibrary.simpleMessage("ابحث لي عن مباراة"),
        "match_finish": MessageLookupByLibrary.simpleMessage("إنهاء المباراة"),
        "match_got_point": MessageLookupByLibrary.simpleMessage("نقطة"),
        "match_handed_over": m17,
        "match_id_hint_empty": MessageLookupByLibrary.simpleMessage(
            "اتركه فارغًا ليختار الخادم لك مباراة مفتوحة"),
        "match_id_hint_set": MessageLookupByLibrary.simpleMessage(
            "ستدخل هذه المباراة بالضبط، وتُنشأ بهذا الرقم إن لم تكن موجودة"),
        "match_id_optional":
            MessageLookupByLibrary.simpleMessage("رقم المباراة (اختياري)"),
        "match_id_placeholder":
            MessageLookupByLibrary.simpleMessage("رقم المباراة"),
        "match_join": MessageLookupByLibrary.simpleMessage("الانضمام لمباراة"),
        "match_leave": MessageLookupByLibrary.simpleMessage("خروج"),
        "match_listen_hint":
            MessageLookupByLibrary.simpleMessage("يظهر نص السؤال بعد انتهائه"),
        "match_listen_question":
            MessageLookupByLibrary.simpleMessage("استمع للسؤال من الحكم"),
        "match_locked_out":
            MessageLookupByLibrary.simpleMessage("أخطأت، الفرصة للمنافس"),
        "match_manual_point":
            MessageLookupByLibrary.simpleMessage("إنهاء السؤال يدويًا"),
        "match_mode": MessageLookupByLibrary.simpleMessage("طريقة اللعب"),
        "match_mode_remote": MessageLookupByLibrary.simpleMessage("عن بُعد"),
        "match_mode_remote_desc":
            MessageLookupByLibrary.simpleMessage("كل واحد من جهازه"),
        "match_mode_same_room":
            MessageLookupByLibrary.simpleMessage("في نفس المكان"),
        "match_mode_same_room_desc":
            MessageLookupByLibrary.simpleMessage("الجميع في مكان واحد"),
        "match_name_hint":
            MessageLookupByLibrary.simpleMessage("مثال: عبدالله"),
        "match_new": MessageLookupByLibrary.simpleMessage("مباراة جديدة"),
        "match_next": MessageLookupByLibrary.simpleMessage("السؤال التالي"),
        "match_no_point": MessageLookupByLibrary.simpleMessage("بلا نقطة"),
        "match_no_timer": MessageLookupByLibrary.simpleMessage("بلا وقت"),
        "match_other_buzzed": m18,
        "match_other_recites": m19,
        "match_page_answer": m20,
        "match_pass_for": m21,
        "match_pass_turn":
            MessageLookupByLibrary.simpleMessage("تجاوز (مرة واحدة)"),
        "match_passed": MessageLookupByLibrary.simpleMessage("تجاوز"),
        "match_players_ready":
            MessageLookupByLibrary.simpleMessage("المتسابقان جاهزان"),
        "match_points_chip": m22,
        "match_press_buzzer":
            MessageLookupByLibrary.simpleMessage("اضغط الجرس للإجابة"),
        "match_progress": m23,
        "match_question_done": MessageLookupByLibrary.simpleMessage("انتهى"),
        "match_question_of": m24,
        "match_recite_fail": MessageLookupByLibrary.simpleMessage("لم ينجح"),
        "match_recite_ok": MessageLookupByLibrary.simpleMessage("نجح"),
        "match_remote_media_soon": MessageLookupByLibrary.simpleMessage(
            "الصوت والصورة بين المتسابقين في المرحلة القادمة"),
        "match_replace": MessageLookupByLibrary.simpleMessage("سؤال بديل"),
        "match_replace_body": MessageLookupByLibrary.simpleMessage(
            "سيُستبدل هذا السؤال بسؤال آخر من نفس الفقرة، ويظهر للمتسابقين أنه سؤال بديل. إن احتُسبت له نقاط فستُلغى."),
        "match_replace_do": MessageLookupByLibrary.simpleMessage("بدّل السؤال"),
        "match_replace_title":
            MessageLookupByLibrary.simpleMessage("تبديل السؤال؟"),
        "match_replaced_chip":
            MessageLookupByLibrary.simpleMessage("سؤال بديل"),
        "match_reveal": MessageLookupByLibrary.simpleMessage("اكشف الإجابات"),
        "match_role_player": MessageLookupByLibrary.simpleMessage("متسابق"),
        "match_role_player1":
            MessageLookupByLibrary.simpleMessage("المتسابق الأول"),
        "match_role_player2":
            MessageLookupByLibrary.simpleMessage("المتسابق الثاني"),
        "match_role_player_desc":
            MessageLookupByLibrary.simpleMessage("تجيب وتنافس على النقاط"),
        "match_role_referee": MessageLookupByLibrary.simpleMessage("الحكم"),
        "match_role_referee_desc":
            MessageLookupByLibrary.simpleMessage("تدير الأسئلة وتحكم الإجابات"),
        "match_round_ayah_number":
            MessageLookupByLibrary.simpleMessage("رقم الآيات"),
        "match_round_of": m25,
        "match_sard_out":
            MessageLookupByLibrary.simpleMessage("استنفدت محاولاتك"),
        "match_sard_speak": MessageLookupByLibrary.simpleMessage(
            "لا يوجد جرس: قل آخر كلمة في الآية بصوتك"),
        "match_seats": MessageLookupByLibrary.simpleMessage("المقاعد"),
        "match_seconds": m26,
        "match_send": MessageLookupByLibrary.simpleMessage("إرسال"),
        "match_share_code": MessageLookupByLibrary.simpleMessage(
            "شارك الرمز ليدخل الآخرون نفس المباراة"),
        "match_similar_out":
            MessageLookupByLibrary.simpleMessage("استنفدت محاولاتك الثلاث"),
        "match_similar_referee":
            MessageLookupByLibrary.simpleMessage("احكم على من أجاب منهما"),
        "match_similar_speak": MessageLookupByLibrary.simpleMessage(
            "لا يوجد جرس: أجب بصوتك مباشرة"),
        "match_start": m27,
        "match_start_ayah_number":
            MessageLookupByLibrary.simpleMessage("ابدأ فقرة رقم الآيات"),
        "match_strike": MessageLookupByLibrary.simpleMessage("خطأ"),
        "match_tap_to_copy": MessageLookupByLibrary.simpleMessage("اضغط للنسخ"),
        "match_tiebreak_chip":
            MessageLookupByLibrary.simpleMessage("سؤال الحسم"),
        "match_turn_of": m28,
        "match_vs": MessageLookupByLibrary.simpleMessage("ضد"),
        "match_wait_referee_next":
            MessageLookupByLibrary.simpleMessage("بانتظار الحكم للسؤال التالي"),
        "match_wait_referee_start":
            MessageLookupByLibrary.simpleMessage("بانتظار الحكم ليبدأ"),
        "match_wait_reveal": MessageLookupByLibrary.simpleMessage(
            "تم الإرسال، بانتظار كشف الإجابات"),
        "match_waiting_answer": MessageLookupByLibrary.simpleMessage("…"),
        "match_waiting_buzz":
            MessageLookupByLibrary.simpleMessage("بانتظار من يضغط الجرس"),
        "match_waiting_players": MessageLookupByLibrary.simpleMessage(
            "بانتظار انضمام المتسابقَين بالرمز"),
        "match_waiting_seat":
            MessageLookupByLibrary.simpleMessage("بانتظار الانضمام"),
        "match_winner": m29,
        "match_winner_chip": MessageLookupByLibrary.simpleMessage("الفائز"),
        "match_worth": m30,
        "match_wrong": MessageLookupByLibrary.simpleMessage("خطأ"),
        "match_you_are": m31,
        "match_you_buzzed": MessageLookupByLibrary.simpleMessage("أجب الآن!"),
        "match_you_recite": m32,
        "match_you_short": MessageLookupByLibrary.simpleMessage("أنت"),
        "match_your_answer": MessageLookupByLibrary.simpleMessage("رقم الآية"),
        "match_your_bid": MessageLookupByLibrary.simpleMessage("مزايدتك"),
        "match_your_chance":
            MessageLookupByLibrary.simpleMessage("أخطأ منافسك، أجب الآن"),
        "match_your_name": MessageLookupByLibrary.simpleMessage("اسمك"),
        "match_your_role": MessageLookupByLibrary.simpleMessage("دورك"),
        "match_your_turn": MessageLookupByLibrary.simpleMessage("دورك الآن"),
        "meccan": MessageLookupByLibrary.simpleMessage("مكية"),
        "media_camera": MessageLookupByLibrary.simpleMessage("الكاميرا"),
        "media_connecting": MessageLookupByLibrary.simpleMessage(
            "جارٍ الاتصال بالصوت والصورة…"),
        "media_failed":
            MessageLookupByLibrary.simpleMessage("تعذر الاتصال بالصوت والصورة"),
        "media_mic": MessageLookupByLibrary.simpleMessage("الميكروفون"),
        "media_not_here": MessageLookupByLibrary.simpleMessage("لم ينضم بعد"),
        "media_retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
        "medinan": MessageLookupByLibrary.simpleMessage("مدنية"),
        "more_downloads": MessageLookupByLibrary.simpleMessage("المزيد…"),
        "page": MessageLookupByLibrary.simpleMessage("صفحة"),
        "page_saved": m33,
        "page_saved_in": m34,
        "page_unsaved": m35,
        "playing_as": m36,
        "privacy_account_body": MessageLookupByLibrary.simpleMessage(
            "للعب في المسابقة نحفظ بريدك الإلكتروني واسمك وكلمة مرورك مشفّرة، ونتائج مبارياتك لعرض إحصاءاتك ولوحة المتصدرين. لا نبيع بياناتك ولا نشاركها مع أي جهة."),
        "privacy_account_title":
            MessageLookupByLibrary.simpleMessage("حساب المسابقة"),
        "privacy_delete_body": MessageLookupByLibrary.simpleMessage(
            "يمكنك حذف حسابك في أي وقت من صفحة حسابك، فيُحذف بريدك واسمك وكلمة مرورك، وتبقى نتائج المباريات دون اسمك."),
        "privacy_delete_title":
            MessageLookupByLibrary.simpleMessage("حذف بياناتك"),
        "privacy_media_body": MessageLookupByLibrary.simpleMessage(
            "في المباريات عن بُعد يُبث الصوت والصورة مباشرة بين المشاركين فقط عند تشغيلك لهما، ولا يُسجَّل أو يُحفظ أي منهما."),
        "privacy_media_title":
            MessageLookupByLibrary.simpleMessage("الصوت والصورة"),
        "privacy_reading_body": MessageLookupByLibrary.simpleMessage(
            "المصحف والبحث والتجويد والتفاسير والتلاوات تعمل دون تسجيل. الصفحات المحفوظة وآخر صفحة قرأتها وما تحمّله من تفاسير وتلاوات تبقى على جهازك فقط."),
        "privacy_reading_title":
            MessageLookupByLibrary.simpleMessage("القراءة دون حساب"),
        "privacy_title": MessageLookupByLibrary.simpleMessage("سياسة الخصوصية"),
        "profile_draws": MessageLookupByLibrary.simpleMessage("تعادل"),
        "profile_losses": MessageLookupByLibrary.simpleMessage("خسارة"),
        "profile_matches": MessageLookupByLibrary.simpleMessage("مباريات"),
        "profile_no_matches":
            MessageLookupByLibrary.simpleMessage("لم تلعب أي مباراة بعد"),
        "profile_points": MessageLookupByLibrary.simpleMessage("نقاط"),
        "profile_recent": MessageLookupByLibrary.simpleMessage("آخر المباريات"),
        "profile_title": MessageLookupByLibrary.simpleMessage("حسابي"),
        "profile_vs": m37,
        "profile_win_rate": m38,
        "profile_wins": MessageLookupByLibrary.simpleMessage("فوز"),
        "quran": MessageLookupByLibrary.simpleMessage("القرآن الكريم"),
        "quran_font": MessageLookupByLibrary.simpleMessage("خط المصحف"),
        "reader_more": MessageLookupByLibrary.simpleMessage("المزيد"),
        "recitation": MessageLookupByLibrary.simpleMessage("الاستماع"),
        "recitation_download_surah":
            MessageLookupByLibrary.simpleMessage("حمّل السورة للاستماع"),
        "recitation_downloading": m39,
        "recitation_play_from":
            MessageLookupByLibrary.simpleMessage("استمع من هذه الآية"),
        "recitation_reciter": MessageLookupByLibrary.simpleMessage("القارئ"),
        "referee_auction": MessageLookupByLibrary.simpleMessage(
            "أعلن الفئة وتابع المزايدة، ويمكنك إغلاقها بـ «أغلق المزايدة». ثم اضغط «صحيح» إن أكمل المتسابق ما زايد عليه أو «خطأ» إن أخطأ."),
        "referee_ayah_number": MessageLookupByLibrary.simpleMessage(
            "اقرأ الآية للمتسابقين، وبعد أن يكتبا العدد اضغط «اكشف الإجابات»."),
        "referee_buzzer": MessageLookupByLibrary.simpleMessage(
            "اقرأ السؤال بصوت واضح (يظهر لك وحدك)، ثم احكم بـ «صحيح» أو «خطأ» على من ضغط أولًا."),
        "referee_right_left": MessageLookupByLibrary.simpleMessage(
            "اضغط «ابدأ دور» لكل متسابق حين يكون جاهزًا؛ الإجابات تُحتسب تلقائيًا من هاتفه، وترى أنت الإجابة الصحيحة لكل بداية."),
        "referee_sard": MessageLookupByLibrary.simpleMessage(
            "اقرأ بداية الآية، وعندما يجيب أحدهما اضغط «صحيح» أو «خطأ» تحت اسمه."),
        "referee_similar": MessageLookupByLibrary.simpleMessage(
            "اقرأ البداية، وعندما يجيب أحدهما اضغط «صحيح» أو «خطأ» تحت اسمه."),
        "referee_tools": MessageLookupByLibrary.simpleMessage("أدوات الحكم"),
        "referee_tools_hint":
            MessageLookupByLibrary.simpleMessage("نقطة يدوية وتعديل النتيجة"),
        "referee_what_do_you_know": MessageLookupByLibrary.simpleMessage(
            "اقرأ السؤال، واضغط «صحيح» لكل إجابة صحيحة أو «خطأ» للخطأ، ويتبدل الدور تلقائيًا. وإن طلب المتسابق التجاوز فاضغط «تجاوز» (مرة واحدة لكل متسابق). انتقل إلى السؤال التالي متى رأيت."),
        "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
        "rl_get_ready": m40,
        "rl_key": m41,
        "rl_left": MessageLookupByLibrary.simpleMessage("يسار"),
        "rl_progress": m42,
        "rl_result": m43,
        "rl_right": MessageLookupByLibrary.simpleMessage("يمين"),
        "rl_running_other": m44,
        "rl_start_run": m45,
        "rl_waiting_run": m46,
        "round_auction": MessageLookupByLibrary.simpleMessage("المزاد"),
        "round_ayah_number": MessageLookupByLibrary.simpleMessage("رقم الآيات"),
        "round_buzzer": MessageLookupByLibrary.simpleMessage("الجرس"),
        "round_hint_auction": MessageLookupByLibrary.simpleMessage(
            "زايِد علنًا على عدد ما تستطيع ذكره، وصاحب المزايدة الأعلى يسرد"),
        "round_hint_ayah_number": MessageLookupByLibrary.simpleMessage(
            "هذه أول آية في الصفحة: كم آية في هذه الصفحة؟"),
        "round_hint_buzzer":
            MessageLookupByLibrary.simpleMessage("أول من يضغط الجرس يجيب"),
        "round_hint_right_left": MessageLookupByLibrary.simpleMessage(
            "هل هذه الآية في الصفحة اليمنى أم اليسرى؟"),
        "round_hint_sard":
            MessageLookupByLibrary.simpleMessage("قل آخر كلمة في هذه الآية"),
        "round_hint_similar": MessageLookupByLibrary.simpleMessage(
            "أجب مباشرة بصوتك إن عرفت العبارة المشتركة"),
        "round_hint_what_do_you_know": m47,
        "round_right_left": MessageLookupByLibrary.simpleMessage("يمين يسار"),
        "round_sard": MessageLookupByLibrary.simpleMessage("السرد"),
        "round_similar": MessageLookupByLibrary.simpleMessage("المتشابهات"),
        "round_what_do_you_know":
            MessageLookupByLibrary.simpleMessage("ماذا تعرف"),
        "rules_auction": m48,
        "rules_ayah_number": m49,
        "rules_buzzer": m50,
        "rules_minute": MessageLookupByLibrary.simpleMessage("دقيقة"),
        "rules_overview": m51,
        "rules_overview_tiebreak": MessageLookupByLibrary.simpleMessage(
            "لا يوجد تعادل: إن تساوت النقاط في النهاية يُطرح سؤال حسم من الفقرة الأخيرة حتى يتقدم أحدهما."),
        "rules_overview_title":
            MessageLookupByLibrary.simpleMessage("المباراة"),
        "rules_players": MessageLookupByLibrary.simpleMessage("للمتسابق"),
        "rules_point1": MessageLookupByLibrary.simpleMessage("نقطة"),
        "rules_point2": MessageLookupByLibrary.simpleMessage("نقطتان"),
        "rules_points": m52,
        "rules_referee": MessageLookupByLibrary.simpleMessage("دور الحكم"),
        "rules_referee_general": MessageLookupByLibrary.simpleMessage(
            "يمكنك دائمًا «سؤال بديل» لتبديل السؤال، ويظهر للمتسابقين أنه بديل، وإن كان محسومًا تُلغى نقاطه.\nويمكنك دائمًا «السؤال التالي»، وإن لم يُحسم السؤال فلا نقطة لأحد.\nأنت من يبدأ المباراة بعد دخول المتسابقَين."),
        "rules_referee_general_title":
            MessageLookupByLibrary.simpleMessage("للحكم في كل الفقرات"),
        "rules_right_left": m53,
        "rules_sard": m54,
        "rules_secs": m55,
        "rules_similar": m56,
        "rules_title": MessageLookupByLibrary.simpleMessage("طريقة اللعب"),
        "rules_what_do_you_know": m57,
        "save_page": MessageLookupByLibrary.simpleMessage("حفظ الصفحة"),
        "saved_count": m58,
        "saved_pages": MessageLookupByLibrary.simpleMessage("الصفحات المحفوظة"),
        "saved_pages_empty":
            MessageLookupByLibrary.simpleMessage("لا توجد صفحات محفوظة بعد"),
        "saved_pages_empty_hint": MessageLookupByLibrary.simpleMessage(
            "اضغط زر الحفظ أعلى صفحة المصحف لتعود إليها لاحقًا"),
        "search": MessageLookupByLibrary.simpleMessage("بحث"),
        "search_all_surahs": MessageLookupByLibrary.simpleMessage("كل السور"),
        "search_ayah": MessageLookupByLibrary.simpleMessage("الآية"),
        "search_failed": MessageLookupByLibrary.simpleMessage("تعذر البحث"),
        "search_full_match":
            MessageLookupByLibrary.simpleMessage("مطابقة تامة"),
        "search_hint":
            MessageLookupByLibrary.simpleMessage("ابحث عن سورة أو آية"),
        "search_in_surah_hint":
            MessageLookupByLibrary.simpleMessage("رقم الآية أو كلمات منها"),
        "search_in_surah_start_hint": MessageLookupByLibrary.simpleMessage(
            "اكتب رقم آية للانتقال إليها،\nأو كلمات للبحث داخل هذه السورة."),
        "search_no_results":
            MessageLookupByLibrary.simpleMessage("لا توجد نتائج"),
        "search_partial_match":
            MessageLookupByLibrary.simpleMessage("مطابقة جزئية"),
        "search_start_hint": MessageLookupByLibrary.simpleMessage(
            "اكتب اسم سورة أو كلمات من آية.\nاكتب بالتشكيل لتظهر المطابقة التامة."),
        "search_surahs": MessageLookupByLibrary.simpleMessage("السور"),
        "search_tashkeel_keyboard":
            MessageLookupByLibrary.simpleMessage("لوحة التشكيل"),
        "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
        "settings_competition":
            MessageLookupByLibrary.simpleMessage("المسابقة"),
        "settings_reading":
            MessageLookupByLibrary.simpleMessage("القراءة والاستماع"),
        "setup_add": MessageLookupByLibrary.simpleMessage("إضافة"),
        "setup_add_selected": m59,
        "setup_answer": MessageLookupByLibrary.simpleMessage("الإجابة"),
        "setup_bank_empty": MessageLookupByLibrary.simpleMessage(
            "لا أسئلة محفوظة لهذه الفقرة. جرّب «توليد»."),
        "setup_count": m60,
        "setup_count_save": MessageLookupByLibrary.simpleMessage("حفظ"),
        "setup_draft_note": MessageLookupByLibrary.simpleMessage(
            "المباراة غير منشورة: لن يدخلها المتسابقون حتى تنشرها. اختر أسئلة كل فقرة أو اتركها لتُختار عشوائيًا."),
        "setup_from_bank": MessageLookupByLibrary.simpleMessage("من البنك"),
        "setup_full":
            MessageLookupByLibrary.simpleMessage("اكتملت أسئلة هذه الفقرة"),
        "setup_generate": MessageLookupByLibrary.simpleMessage("توليد"),
        "setup_new": MessageLookupByLibrary.simpleMessage("سؤال جديد"),
        "setup_page":
            MessageLookupByLibrary.simpleMessage("رقم الصفحة (١–٦٠٤)"),
        "setup_page_label": m61,
        "setup_prompt": MessageLookupByLibrary.simpleMessage("نص السؤال"),
        "setup_publish": MessageLookupByLibrary.simpleMessage("نشر المباراة"),
        "setup_publish_hint": MessageLookupByLibrary.simpleMessage(
            "بعد النشر يستطيع المتسابقان الدخول برقم المباراة"),
        "setup_random_rest":
            MessageLookupByLibrary.simpleMessage("الباقي عشوائي"),
        "setup_refs": MessageLookupByLibrary.simpleMessage(
            "الآيات (سورة:آية، مفصولة بفواصل)"),
        "setup_rl_ayahs":
            MessageLookupByLibrary.simpleMessage("الآيات (عدد زوجي، ١٢ عادةً)"),
        "setup_rounds_hint": MessageLookupByLibrary.simpleMessage(
            "اختر فقرة واحدة على الأقل وعدد أسئلة كل فقرة (٤ لكل فقرة افتراضيًا)."),
        "setup_rounds_title":
            MessageLookupByLibrary.simpleMessage("الفقرات وعدد الأسئلة"),
        "setup_rounds_total": m62,
        "setup_sard_ayah":
            MessageLookupByLibrary.simpleMessage("الآية (سورة:آية)"),
        "setup_title": MessageLookupByLibrary.simpleMessage("إعداد المباراة"),
        "sheet_tab_similar":
            MessageLookupByLibrary.simpleMessage("المتشابهات والتجويد"),
        "sheet_tab_tafsir":
            MessageLookupByLibrary.simpleMessage("التفسير والترجمة"),
        "similar_ayahs":
            MessageLookupByLibrary.simpleMessage("الآيات المتشابهة"),
        "similar_colors":
            MessageLookupByLibrary.simpleMessage("تلوين الآيات المتشابهة"),
        "similar_colors_subtitle": MessageLookupByLibrary.simpleMessage(
            "تمييز الآيات المكررة والعبارات المشتركة بين الآيات"),
        "similar_failed": MessageLookupByLibrary.simpleMessage(
            "تعذر البحث عن الآيات المتشابهة"),
        "similar_full": MessageLookupByLibrary.simpleMessage("تطابق تام"),
        "similar_min_words":
            MessageLookupByLibrary.simpleMessage("أقل عدد كلمات للتشابه"),
        "similar_min_words_subtitle": MessageLookupByLibrary.simpleMessage(
            "عدد الكلمات المتتالية المشتركة ليعد تشابهًا جزئيًا"),
        "similar_none": m63,
        "similar_partial": MessageLookupByLibrary.simpleMessage("تشابه جزئي"),
        "similar_words": m64,
        "sources_body": MessageLookupByLibrary.simpleMessage(
            "نص المصحف: مشروع تنزيل (tanzil.net) برواية حفص.\nالتفاسير والترجمات والتلاوات: alquran.cloud وislamic.network.\nالتفسير الميسر: مجمع الملك فهد لطباعة المصحف الشريف.\nالخطوط: Amiri Quran وIBM Plex Sans Arabic برخصة SIL OFL."),
        "sources_title": MessageLookupByLibrary.simpleMessage("مصادر المحتوى"),
        "splash_tagline": MessageLookupByLibrary.simpleMessage(
            "رفيقك في تلاوة القرآن ومراجعته"),
        "surah_filter_hint":
            MessageLookupByLibrary.simpleMessage("اسم السورة أو رقمها"),
        "surah_none":
            MessageLookupByLibrary.simpleMessage("لا توجد سورة بهذا الاسم"),
        "surah_page_short": m65,
        "surahs_index": MessageLookupByLibrary.simpleMessage("فهرس السور"),
        "tafsir": MessageLookupByLibrary.simpleMessage("التفسير"),
        "tajweed": MessageLookupByLibrary.simpleMessage("التجويد"),
        "tajweed_colors":
            MessageLookupByLibrary.simpleMessage("تلوين أحكام التجويد"),
        "tajweed_colors_subtitle": MessageLookupByLibrary.simpleMessage(
            "تلوين الحروف في المصحف حسب أحكام التجويد"),
        "tajweed_details":
            MessageLookupByLibrary.simpleMessage("أحكام التجويد"),
        "tajweed_duration": MessageLookupByLibrary.simpleMessage("المدة"),
        "tajweed_example": MessageLookupByLibrary.simpleMessage("مثال"),
        "tajweed_guide":
            MessageLookupByLibrary.simpleMessage("دليل ألوان التجويد"),
        "tajweed_guide_subtitle": MessageLookupByLibrary.simpleMessage(
            "معنى كل لون ومدته ومثال عليه"),
        "tajweed_letters": MessageLookupByLibrary.simpleMessage("الحرف"),
        "tajweed_no_rules": MessageLookupByLibrary.simpleMessage(
            "لا توجد أحكام ملونة في هذه الآية"),
        "tajweed_position": MessageLookupByLibrary.simpleMessage("الموضع"),
        "tajweed_unavailable":
            MessageLookupByLibrary.simpleMessage("تعذر تحميل أحكام التجويد"),
        "text_unavailable":
            MessageLookupByLibrary.simpleMessage("تعذّر عرض النص"),
        "translation": MessageLookupByLibrary.simpleMessage("الترجمة"),
        "undo": MessageLookupByLibrary.simpleMessage("تراجع"),
        "you_label": MessageLookupByLibrary.simpleMessage("(أنت)")
      };
}

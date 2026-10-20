import 'tajweed_rule.dart';

/// A rule applied to `text.substring(start, end)` of one ayah.
class TajweedSpanModel {
  final int start;
  final int end;
  final TajweedRule rule;

  const TajweedSpanModel({
    required this.start,
    required this.end,
    required this.rule,
  });
}

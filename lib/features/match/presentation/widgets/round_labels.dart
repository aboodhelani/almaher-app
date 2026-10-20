import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../domain/models/match_state_model.dart';

String roundName(S s, RoundType t) => switch (t) {
  RoundType.whatDoYouKnow => s.round_what_do_you_know,
  RoundType.ayahNumber => s.round_ayah_number,
  RoundType.auction => s.round_auction,
  RoundType.similar => s.round_similar,
  RoundType.sard => s.round_sard,
  RoundType.rightLeft => s.round_right_left,
  RoundType.buzzer => s.round_buzzer,
};

String roundIcon(RoundType t) => switch (t) {
  RoundType.whatDoYouKnow => 'round_what_do_you_know.svg',
  RoundType.ayahNumber => 'round_ayah_number.svg',
  RoundType.auction => 'round_auction.svg',
  RoundType.similar => 'round_similar.svg',
  RoundType.sard => 'round_sard.svg',
  RoundType.rightLeft => 'round_right_left.svg',
  RoundType.buzzer => 'round_buzzer.svg',
};

/// What players are asked to do, under the question.
String roundInstruction(S s, RoundType t, {int strikes = 3}) => switch (t) {
  RoundType.whatDoYouKnow => s.round_hint_what_do_you_know(
    strikes.toArabicDigits,
  ),
  RoundType.ayahNumber => s.round_hint_ayah_number,
  RoundType.auction => s.round_hint_auction,
  RoundType.similar => s.round_hint_similar,
  RoundType.sard => s.round_hint_sard,
  RoundType.rightLeft => s.round_hint_right_left,
  RoundType.buzzer => s.round_hint_buzzer,
};

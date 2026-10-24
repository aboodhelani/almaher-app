import '../../../../core/translations/l10n.dart';

/// The user-facing message for a server error code.
String matchErrorText(S s, String code) => switch (code) {
  'unreachable' || 'timeout' => s.match_err_unreachable,
  'match_not_found' => s.match_err_not_found,
  'not_published' => s.match_err_not_published,
  'match_closed' => s.match_err_closed,
  'role_taken' => s.match_err_role_taken,
  'match_full' => s.match_err_full,
  'invalid_code' => s.match_err_invalid_code,
  'code_taken' => s.match_err_code_taken,
  'name_required' => s.match_err_name,
  'players_missing' => s.match_err_players_missing,
  'time_up' => s.match_err_time_up,
  'already_answered' => s.match_err_already_answered,
  'invalid_answer' => s.match_err_invalid_answer,
  'login_required' => s.match_err_login_required,
  'already_player' => s.match_err_already_player,
  'already_referee' => s.match_err_already_referee,
  'already_finished' => s.match_err_already_finished,
  'no_rounds' => s.match_err_no_rounds,
  'too_many_questions' || 'invalid_count' => s.match_err_too_many,
  _ => s.match_err_generic,
};

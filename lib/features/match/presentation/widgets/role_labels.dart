import '../../../../core/translations/l10n.dart';
import '../../domain/models/match_enums.dart';

String roleLabel(S s, MatchRole role) => switch (role) {
  MatchRole.player1 => s.match_role_player1,
  MatchRole.player2 => s.match_role_player2,
  MatchRole.referee => s.match_role_referee,
};

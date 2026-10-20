import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/game_theme.dart';
import '../../../../core/translations/l10n.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/match_bloc.dart';
import 'game_rules_page.dart';
import '../widgets/game_kit.dart';
import '../widgets/match_error_text.dart';
import '../widgets/match_lobby_form.dart';
import '../widgets/match_room_view.dart';
import '../widgets/match_sound_effects.dart';

/// The competition: the create/join form, then the match room, on the dark
/// game stage whatever the reading theme.
class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: gameTheme,
      child: const MatchSoundEffects(child: _MatchScreen()),
    );
  }
}

class _MatchScreen extends StatelessWidget {
  const _MatchScreen();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocConsumer<MatchBloc, MatchState>(
      listener: (context, state) {
        final error = switch (state) {
          MatchIdle(:final error) => error,
          MatchInRoom(:final error) => error,
          _ => null,
        };
        if (error == null) return;
        if (error == 'login_required') {
          context.read<AuthBloc>().add(const AuthSessionExpired());
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(matchErrorText(s, error))));
        if (state is MatchInRoom) {
          context.read<MatchBloc>().add(const MatchErrorShown());
        }
      },
      builder: (context, state) {
        final inRoom = state is MatchInRoom;
        final round = state is MatchInRoom ? state.match.round : null;
        return PopScope(
          // Leaving a live match takes a tap on "leave".
          canPop: !inRoom,
          child: GameStage(
            glow: round == null ? null : roundColor(round.type),
            child: Scaffold(
              appBar: AppBar(
                forceMaterialTransparency: true,
                title: Text(s.home_play),
                automaticallyImplyLeading: !inRoom,
                actions: [
                  IconButton(
                    tooltip: s.rules_title,
                    icon: const Icon(Icons.info_outline_rounded),
                    onPressed: () => GameRulesPage.open(context),
                  ),
                  if (inRoom)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextButton.icon(
                        onPressed: () =>
                            context.read<MatchBloc>().add(const MatchLeft()),
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: Text(s.match_leave),
                      ),
                    ),
                ],
              ),
              body: SafeArea(
                top: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: switch (state) {
                    MatchInRoom(:final match) => MatchRoomView(
                      key: const ValueKey('room'),
                      match: match,
                    ),
                    _ => MatchLobbyForm(
                      key: const ValueKey('lobby'),
                      busy: state is MatchConnecting,
                    ),
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

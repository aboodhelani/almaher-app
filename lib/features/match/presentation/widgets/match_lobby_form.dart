import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../domain/models/match_enums.dart';
import '../bloc/match_bloc.dart';
import 'game_kit.dart';
import '../../../../core/router/app_route_enum.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// Enter a match: a name, player or referee, and optionally a match ID.
/// With an ID the user goes to that exact match; without one the server
/// matches them.
class MatchLobbyForm extends StatefulWidget {
  final bool busy;

  const MatchLobbyForm({super.key, required this.busy});

  @override
  State<MatchLobbyForm> createState() => _MatchLobbyFormState();
}

class _MatchLobbyFormState extends State<MatchLobbyForm> {
  final _code = TextEditingController();
  JoinRole _role = JoinRole.player;
  MatchMode _mode = MatchMode.sameRoom;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  bool get _canSubmit => !widget.busy && _userName.isNotEmpty;

  /// Players play under their account's name.
  String get _userName => context.read<AuthBloc>().state.user?.name ?? '';

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<MatchBloc>().add(
      MatchEnterRequested(
        name: _userName,
        role: _role,
        mode: _mode,
        code: _code.text.trim().isEmpty ? null : _code.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final hasCode = _code.text.trim().isNotEmpty;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 32.h),
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: GameColors.panel,
              boxShadow: [
                BoxShadow(
                  color: GameColors.whatDoYouKnow.withValues(alpha: 0.5),
                  blurRadius: 40,
                ),
              ],
            ),
            child: AppLogo(size: 76.r),
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          s.lobby_title,
          textAlign: TextAlign.center,
          style: AppTextStyle.xxxLarge.copyWith(
            color: GameColors.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          s.lobby_subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyle.medium.copyWith(color: GameColors.textMuted),
        ),
        SizedBox(height: 24.h),
        const _AccountCard(),
        _Label(s.match_your_role),
        Row(
          children: [
            Expanded(
              child: _ChoiceCard(
                icon: Icons.sports_esports_rounded,
                title: s.match_role_player,
                subtitle: s.match_role_player_desc,
                gradient: GameColors.pair(
                  GameColors.player1,
                  GameColors.player1End,
                ),
                selected: _role == JoinRole.player,
                onTap: () => setState(() => _role = JoinRole.player),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ChoiceCard(
                icon: Icons.gavel_rounded,
                title: s.match_role_referee,
                subtitle: s.match_role_referee_desc,
                gradient: GameColors.pair(
                  GameColors.referee,
                  GameColors.refereeEnd,
                ),
                selected: _role == JoinRole.referee,
                onTap: () => setState(() => _role = JoinRole.referee),
              ),
            ),
          ],
        ),
        _Label(s.match_id_optional),
        TextField(
          controller: _code,
          maxLength: 20,
          // IDs are digits and Latin letters: type them left to right.
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.visiblePassword,
          autocorrect: false,
          textInputAction: TextInputAction.go,
          onSubmitted: (_) {
            if (_canSubmit) _submit();
          },
          onChanged: (_) => setState(() {}),
          textAlign: TextAlign.center,
          style: AppTextStyle.xxLarge.copyWith(
            color: GameColors.text,
            fontWeight: FontWeight.w700,
            letterSpacing: 4,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: s.match_id_placeholder,
            hintStyle: AppTextStyle.medium.copyWith(
              color: GameColors.textSubtle,
              letterSpacing: 0,
            ),
            prefixIcon: const Icon(Icons.tag_rounded),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 6.w, top: 6.h),
          child: Row(
            children: [
              Icon(
                hasCode ? Icons.login_rounded : Icons.shuffle_rounded,
                size: 14.r,
                color: GameColors.textSubtle,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  hasCode ? s.match_id_hint_set : s.match_id_hint_empty,
                  style: AppTextStyle.xSmall.copyWith(
                    color: GameColors.textSubtle,
                  ),
                ),
              ),
            ],
          ),
        ),
        _Label(s.match_mode),
        Row(
          children: [
            Expanded(
              child: _ChoiceCard(
                icon: Icons.groups_rounded,
                title: s.match_mode_same_room,
                subtitle: s.match_mode_same_room_desc,
                gradient: GameColors.pair(
                  GameColors.similar,
                  GameColors.ayahNumber,
                ),
                selected: _mode == MatchMode.sameRoom,
                compact: true,
                onTap: () => setState(() => _mode = MatchMode.sameRoom),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ChoiceCard(
                icon: Icons.wifi_rounded,
                title: s.match_mode_remote,
                subtitle: s.match_mode_remote_desc,
                gradient: GameColors.pair(
                  GameColors.whatDoYouKnow,
                  GameColors.buzzer,
                ),
                selected: _mode == MatchMode.remote,
                compact: true,
                onTap: () => setState(() => _mode = MatchMode.remote),
              ),
            ),
          ],
        ),
        SizedBox(height: 28.h),
        GameButton(
          label: hasCode ? s.match_enter_by_id : s.match_find,
          icon: hasCode ? Icons.login_rounded : Icons.bolt_rounded,
          busy: widget.busy,
          onPressed: _canSubmit ? _submit : null,
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(6.w, 20.h, 6.w, 8.h),
      child: Text(
        text,
        style: AppTextStyle.small.copyWith(
          color: GameColors.textMuted,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// A selectable card that lights up in its [gradient] when [selected].
class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final glow = gradient.colors.first;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(compact ? 12.r : 14.r),
        decoration: BoxDecoration(
          color: selected ? null : GameColors.panel,
          gradient: selected ? gradient : null,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.5)
                : GameColors.panelBorder,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: glow.withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(compact ? 6.r : 8.r),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.22)
                        : glow.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    size: compact ? 18.r : 22.r,
                    color: selected ? Colors.white : glow,
                  ),
                ),
                const Spacer(),
                AnimatedOpacity(
                  opacity: selected ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 20.r,
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 8.h : 12.h),
            Text(
              title,
              style: (compact ? AppTextStyle.medium : AppTextStyle.large)
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            Text(
              subtitle,
              style: AppTextStyle.xSmall.copyWith(
                color: selected
                    ? Colors.white.withValues(alpha: 0.85)
                    : GameColors.textSubtle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Who is playing (the signed-in account), with a way to the profile.
class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final name = context.watch<AuthBloc>().state.user?.name ?? '';
    return Material(
      color: GameColors.panel,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () => Navigator.pushNamed(context, AppRouteEnum.profile.name),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              PlayerAvatar(role: MatchRole.player1, name: name, size: 44.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.playing_as(name),
                      style: AppTextStyle.medium.copyWith(
                        color: GameColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${s.profile_title} · ${s.leaderboard}',
                      style: AppTextStyle.xSmall.copyWith(
                        color: GameColors.textSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

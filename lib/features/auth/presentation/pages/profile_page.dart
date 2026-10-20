import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/brand_colors.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/styles/game_theme.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../match/domain/models/match_enums.dart';
import '../../../match/presentation/widgets/game_kit.dart';
import '../../../../core/utils/injections.dart';
import '../../domain/models/user_model.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_page.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';

/// The player's account: totals, recent matches and the leaderboard.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  /// Asks for the password, deletes the account and goes home signed out.
  Future<void> _confirmDelete(BuildContext context) async {
    final deleted = await showDialog<bool>(
      context: context,
      builder: (_) => const _DeleteAccountDialog(),
    );
    if (deleted != true || !context.mounted) return;
    final s = S.of(context);
    final messenger = ScaffoldMessenger.of(context);
    context.read<AuthBloc>().add(const AuthLogoutRequested());
    Navigator.of(context).popUntil((r) => r.isFirst);
    messenger.showSnackBar(SnackBar(content: Text(s.delete_account_done)));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final user = context.watch<AuthBloc>().state.user;
    return Theme(
      data: gameTheme,
      child: DefaultTabController(
        length: 2,
        child: GameStage(
          child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              title: Text(s.profile_title),
              actions: [
                PopupMenuButton<bool>(
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (delete) {
                    if (delete) {
                      _confirmDelete(context);
                      return;
                    }
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                    Navigator.of(context).popUntil((r) => r.isFirst);
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: false,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.logout_rounded),
                        title: Text(s.logout),
                      ),
                    ),
                    PopupMenuItem(
                      value: true,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.person_remove_outlined,
                          color: GameColors.wrong,
                        ),
                        title: Text(
                          s.delete_account,
                          style: const TextStyle(color: GameColors.wrong),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final stats = state.profile?.stats ?? const PlayerStatsModel();
                return RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<ProfileBloc>();
                    bloc.add(const ProfileRequested());
                    await bloc.stream.firstWhere((s) => !s.loading);
                  },
                  child: NestedScrollView(
                    headerSliverBuilder: (context, _) => [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
                          child: Column(
                            children: [
                              PlayerAvatar(
                                role: MatchRole.player1,
                                name: user?.name,
                                size: 76.r,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                user?.name ?? '',
                                style: AppTextStyle.xxLarge.copyWith(
                                  color: GameColors.text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                user?.email ?? '',
                                textDirection: TextDirection.ltr,
                                style: AppTextStyle.small.copyWith(
                                  color: GameColors.textSubtle,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              _StatsGrid(stats: stats),
                              SizedBox(height: 12.h),
                              _WinRate(stats: stats),
                              SizedBox(height: 8.h),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: GameColors.panel,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: TabBar(
                              dividerHeight: 0,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                gradient: GameColors.promo,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              labelColor: Colors.white,
                              unselectedLabelColor: GameColors.textMuted,
                              labelStyle: AppTextStyle.medium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              tabs: [
                                Tab(text: s.profile_recent),
                                Tab(text: s.leaderboard),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    body: state.loading && state.profile == null
                        ? const Center(child: CircularProgressIndicator())
                        : TabBarView(
                            children: [
                              _RecentList(
                                recent: state.profile?.recent ?? const [],
                              ),
                              _Leaderboard(rows: state.board, me: user?.id),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final PlayerStatsModel stats;

  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final items = [
      (s.profile_matches, stats.matches, GameColors.whatDoYouKnow),
      (s.profile_wins, stats.wins, GameColors.correct),
      (s.profile_losses, stats.losses, GameColors.wrong),
      (s.profile_points, stats.points, GameColors.ayahNumber),
    ];
    return Row(
      children: [
        for (final (label, value, color) in items) ...[
          if (label != items.first.$1) SizedBox(width: 8.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Column(
                children: [
                  Text(
                    '$value',
                    style: AppTextStyle.xxLarge.copyWith(
                      color: GameColors.text,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    label,
                    style: AppTextStyle.xSmall.copyWith(
                      color: GameColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _WinRate extends StatelessWidget {
  final PlayerStatsModel stats;

  const _WinRate({required this.stats});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.profile_win_rate(stats.winRate.toArabicDigits),
          style: AppTextStyle.small.copyWith(
            color: GameColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: stats.winRate / 100,
            minHeight: 8,
            color: GameColors.correct,
            backgroundColor: GameColors.panel,
          ),
        ),
      ],
    );
  }
}

class _RecentList extends StatelessWidget {
  final List<RecentMatchModel> recent;

  const _RecentList({required this.recent});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (recent.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 60.h),
          Center(
            child: Text(
              s.profile_no_matches,
              style: AppTextStyle.medium.copyWith(color: GameColors.textMuted),
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 32.h),
      itemCount: recent.length,
      separatorBuilder: (_, _) => SizedBox(height: 8.h),
      itemBuilder: (context, i) {
        final m = recent[i];
        final (label, color) = switch (m.result) {
          MatchOutcome.win => (s.profile_wins, GameColors.correct),
          MatchOutcome.draw => (s.profile_draws, GameColors.gold),
          MatchOutcome.loss => (s.profile_losses, GameColors.wrong),
        };
        final d = m.finishedAt.toLocal();
        return GamePanel(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          radius: 18.r,
          child: Row(
            children: [
              GameChip(label: label, color: color, solid: true),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.profile_vs(m.opponent),
                      style: AppTextStyle.medium.copyWith(
                        color: GameColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${d.day.toArabicDigits}/${d.month.toArabicDigits}/${d.year.toArabicDigits}',
                      style: AppTextStyle.xSmall.copyWith(
                        color: GameColors.textSubtle,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${m.myScore} - ${m.opponentScore}',
                textDirection: TextDirection.ltr,
                style: AppTextStyle.xLarge.copyWith(
                  color: GameColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Leaderboard extends StatelessWidget {
  final List<LeaderboardRowModel> rows;
  final String? me;

  const _Leaderboard({required this.rows, required this.me});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (rows.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 60.h),
          Center(
            child: Text(
              s.leaderboard_empty,
              style: AppTextStyle.medium.copyWith(color: GameColors.textMuted),
            ),
          ),
        ],
      );
    }
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 32.h),
      itemCount: rows.length,
      separatorBuilder: (_, _) => SizedBox(height: 8.h),
      itemBuilder: (context, i) {
        final r = rows[i];
        final mine = r.userId == me;
        final medal = switch (r.rank) {
          1 => GameColors.gold,
          2 => Brand.navy200,
          3 => Brand.gold700,
          _ => null,
        };
        return GamePanel(
          tint: mine ? GameColors.player1 : null,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          radius: 18.r,
          child: Row(
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: medal ?? GameColors.panelStrong,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${r.rank}',
                  style: AppTextStyle.medium.copyWith(
                    color: medal != null
                        ? GameColors.stageBottom
                        : GameColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  mine ? '${r.name} ${s.you_label}' : r.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.medium.copyWith(
                    color: GameColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _Mini(
                label: s.profile_wins,
                value: r.stats.wins,
                color: GameColors.correct,
              ),
              SizedBox(width: 10.w),
              _Mini(
                label: s.profile_points,
                value: r.stats.points,
                color: GameColors.ayahNumber,
              ),
              SizedBox(width: 10.w),
              _Mini(
                label: s.profile_matches,
                value: r.stats.matches,
                color: GameColors.textMuted,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Mini extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _Mini({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: AppTextStyle.medium.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        Text(
          label,
          style: AppTextStyle.xSmall.copyWith(color: GameColors.textSubtle),
        ),
      ],
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await sl<DeleteAccountUseCase>().call(_password.text);
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _busy = false;
        _error = authErrorText(S.of(context), f.errorMessage);
      }),
      (_) => Navigator.of(context).pop(true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return AlertDialog(
      title: Text(s.delete_account),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(s.delete_account_body),
          SizedBox(height: 14.h),
          TextField(
            controller: _password,
            obscureText: true,
            autofocus: true,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
              hintText: s.auth_password,
              errorText: _error,
            ),
            onSubmitted: (_) => _busy ? null : _delete(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: Text(s.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: GameColors.wrong),
          onPressed: _busy ? null : _delete,
          child: _busy
              ? SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(s.delete_account_confirm),
        ),
      ],
    );
  }
}

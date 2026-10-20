import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../../../core/utils/arabic_numbers.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../domain/models/match_state_model.dart';
import '../bloc/match_bloc.dart';
import 'game_kit.dart';
import 'round_labels.dart';

/// The referee prepares a draft match: which rounds it plays and how many
/// questions each, the questions per round (from the bank, generated, or
/// written), then publishes it so players can enter. Rounds left short are
/// filled at random when the match starts.
class MatchSetupView extends StatelessWidget {
  final MatchStateModel match;

  const MatchSetupView({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameBanner(
          icon: Icons.edit_note_rounded,
          color: GameColors.referee,
          text: s.setup_draft_note,
        ),
        SizedBox(height: 12.h),
        _RoundsPicker(match: match),
        for (final type in match.rounds) ...[
          SizedBox(height: 12.h),
          _RoundSetup(match: match, type: type),
        ],
        SizedBox(height: 18.h),
        GameButton(
          label: s.setup_publish,
          icon: Icons.rocket_launch_rounded,
          onPressed: () {
            HapticFeedback.mediumImpact();
            context.read<MatchBloc>().add(const MatchPublishRequested());
          },
        ),
        SizedBox(height: 8.h),
        Text(
          s.setup_publish_hint,
          textAlign: TextAlign.center,
          style: AppTextStyle.xSmall.copyWith(color: GameColors.textSubtle),
        ),
      ],
    );
  }
}

/// Which rounds the match plays and how many questions each: 4 of every
/// round by default; at least one round stays on.
class _RoundsPicker extends StatelessWidget {
  final MatchStateModel match;

  const _RoundsPicker({required this.match});

  Map<RoundType, int> get _counts => {
    for (final t in match.availableRounds)
      if (match.countFor(t) > 0) t: match.countFor(t),
  };

  void _set(BuildContext context, RoundType type, int count) {
    HapticFeedback.selectionClick();
    final counts = _counts;
    if (count > 0) {
      counts[type] = count;
    } else {
      counts.remove(type);
    }
    context.read<MatchBloc>().add(MatchRoundCountsSet(counts));
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final counts = _counts;
    final total = counts.values.fold(0, (a, n) => a + n);
    return GamePanel(
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  s.setup_rounds_title,
                  style: AppTextStyle.large.copyWith(
                    color: GameColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GameChip(
                label: s.setup_rounds_total(total.toArabicDigits),
                color: GameColors.gold,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            s.setup_rounds_hint,
            style: AppTextStyle.xSmall.copyWith(color: GameColors.textSubtle),
          ),
          for (final type in match.availableRounds)
            _RoundCountRow(
              type: type,
              count: counts[type] ?? 0,
              // The last round on can't be turned off.
              canTurnOff: counts.length > 1,
              max: [
                match.maxPerRound,
                match.maxQuestions - total + (counts[type] ?? 0),
              ].reduce((a, b) => a < b ? a : b),
              onChanged: (n) => _set(context, type, n),
              defaultCount: match.perRound,
            ),
        ],
      ),
    );
  }
}

class _RoundCountRow extends StatelessWidget {
  final RoundType type;
  final int count;
  final int max;
  final int defaultCount;
  final bool canTurnOff;
  final ValueChanged<int> onChanged;

  const _RoundCountRow({
    required this.type,
    required this.count,
    required this.max,
    required this.defaultCount,
    required this.canTurnOff,
    required this.onChanged,
  });

  Future<void> _typeCount(BuildContext context) async {
    final n = await showDialog<int>(
      context: context,
      builder: (_) => _CountDialog(type: type, initial: count, max: max),
    );
    if (n != null && n != count) onChanged(n);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final on = count > 0;
    final color = roundColor(type);
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        children: [
          Checkbox(
            value: on,
            activeColor: color,
            onChanged: on && !canTurnOff
                ? null
                : (v) => onChanged(v == true ? defaultCount.clamp(1, max) : 0),
          ),
          Container(
            width: 28.r,
            height: 28.r,
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: on ? color : GameColors.panel,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AppSvg(
              roundIcon(type),
              size: 18.r,
              color: on ? onColor(color) : GameColors.textSubtle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              roundName(s, type),
              style: AppTextStyle.medium.copyWith(
                color: on ? GameColors.text : GameColors.textSubtle,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (on) ...[
            IconButton(
              icon: const Icon(Icons.remove_rounded),
              color: GameColors.text,
              visualDensity: VisualDensity.compact,
              onPressed: count > 1 ? () => onChanged(count - 1) : null,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () => _typeCount(context),
              child: Container(
                constraints: BoxConstraints(minWidth: 40.w),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: color),
                ),
                alignment: Alignment.center,
                child: Text(
                  count.toArabicDigits,
                  style: AppTextStyle.medium.copyWith(
                    color: GameColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_rounded),
              color: GameColors.text,
              visualDensity: VisualDensity.compact,
              onPressed: count < max ? () => onChanged(count + 1) : null,
            ),
          ],
        ],
      ),
    );
  }
}

/// Types a round's question count (1 to [max]).
class _CountDialog extends StatefulWidget {
  final RoundType type;
  final int initial;
  final int max;

  const _CountDialog({
    required this.type,
    required this.initial,
    required this.max,
  });

  @override
  State<_CountDialog> createState() => _CountDialogState();
}

class _CountDialogState extends State<_CountDialog> {
  late final _controller = TextEditingController(text: '${widget.initial}');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? get _value {
    final n = int.tryParse(toWesternDigits(_controller.text.trim()));
    return n == null || n < 1 || n > widget.max ? null : n;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final value = _value;
    return AlertDialog(
      backgroundColor: GameColors.stageTop,
      title: Text(roundName(s, widget.type)),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textDirection: TextDirection.ltr,
        decoration: InputDecoration(
          hintText: '${1.toArabicDigits}–${widget.max.toArabicDigits}',
        ),
        onChanged: (_) => setState(() {}),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.match_cancel),
        ),
        FilledButton(
          onPressed: value == null ? null : () => Navigator.pop(context, value),
          child: Text(s.setup_count_save),
        ),
      ],
    );
  }
}

class _RoundSetup extends StatelessWidget {
  final MatchStateModel match;
  final RoundType type;

  const _RoundSetup({required this.match, required this.type});

  List<QuestionModel> get _chosen => match.setup[type] ?? const [];

  int get _count => match.countFor(type);

  void _save(BuildContext context, List<Map<String, dynamic>> bodies) =>
      context.read<MatchBloc>().add(MatchRoundQuestionsSet(type, bodies));

  void _add(BuildContext context, List<Map<String, dynamic>> more) => _save(
    context,
    [..._chosen.map((q) => q.toBody()), ...more].take(_count).toList(),
  );

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final color = roundColor(type);
    final chosen = _chosen;
    final left = _count - chosen.length;
    return GamePanel(
      tint: color,
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                padding: EdgeInsets.all(7.r),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: AppSvg(
                  roundIcon(type),
                  size: 20.r,
                  color: onColor(color),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  roundName(s, type),
                  style: AppTextStyle.large.copyWith(
                    color: GameColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GameChip(
                label: s.setup_count(
                  chosen.length.toArabicDigits,
                  _count.toArabicDigits,
                ),
                color: chosen.length >= _count ? GameColors.correct : color,
                solid: chosen.length >= _count,
              ),
            ],
          ),
          for (var i = 0; i < chosen.length; i++)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: _ChosenTile(
                question: chosen[i],
                type: type,
                onRemove: () => _save(context, [
                  for (var j = 0; j < chosen.length; j++)
                    if (j != i) chosen[j].toBody(),
                ]),
              ),
            ),
          if (left > 0) ...[
            if (chosen.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Text(
                  s.setup_random_rest,
                  style: AppTextStyle.xSmall.copyWith(
                    color: GameColors.textSubtle,
                  ),
                ),
              ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _SmallAction(
                  icon: Icons.inventory_2_outlined,
                  label: s.setup_from_bank,
                  onTap: () async {
                    final picked = await _PickSheet.show(
                      context,
                      type,
                      left,
                      false,
                    );
                    if (picked != null && context.mounted) {
                      _add(context, picked);
                    }
                  },
                ),
                _SmallAction(
                  icon: Icons.auto_awesome_rounded,
                  label: s.setup_generate,
                  onTap: () async {
                    final picked = await _PickSheet.show(
                      context,
                      type,
                      left,
                      true,
                    );
                    if (picked != null && context.mounted) {
                      _add(context, picked);
                    }
                  },
                ),
                _SmallAction(
                  icon: Icons.add_rounded,
                  label: s.setup_new,
                  onTap: () async {
                    final body = await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (_) => _NewQuestionDialog(type: type),
                    );
                    if (body != null && context.mounted) _add(context, [body]);
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

String _title(S s, RoundType type, QuestionModel q) =>
    type == RoundType.ayahNumber && q.meta['page'] != null
    ? '${s.setup_page_label((q.meta['page'] as num).toInt().toArabicDigits)} · ${q.prompt}'
    : q.prompt;

class _ChosenTile extends StatelessWidget {
  final QuestionModel question;
  final RoundType type;
  final VoidCallback onRemove;

  const _ChosenTile({
    required this.question,
    required this.type,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(12.w, 8.h, 4.w, 8.h),
      decoration: BoxDecoration(
        color: GameColors.panel,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title(s, type, question),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.small.copyWith(
                    color: GameColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (question.answer case final a? when a.isNotEmpty)
                  Text(
                    a,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.xSmall.copyWith(
                      color: GameColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            color: GameColors.textMuted,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SmallAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
      ),
    );
  }
}

/// Bank or generated questions of a round; pops with the picked ones.
class _PickSheet extends StatefulWidget {
  final RoundType type;
  final int max;
  final bool generated;

  const _PickSheet({
    required this.type,
    required this.max,
    required this.generated,
  });

  static Future<List<Map<String, dynamic>>?> show(
    BuildContext context,
    RoundType type,
    int max,
    bool generated,
  ) {
    final bloc = context.read<MatchBloc>();
    return showModalBottomSheet<List<Map<String, dynamic>>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: GameColors.stageTop,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _PickSheet(type: type, max: max, generated: generated),
      ),
    );
  }

  @override
  State<_PickSheet> createState() => _PickSheetState();
}

class _PickSheetState extends State<_PickSheet> {
  late final _questions = context.read<MatchBloc>().setupQuestions(
    widget.type,
    generated: widget.generated,
  );
  final Set<int> _picked = {};

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final color = roundColor(widget.type);
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.75,
      child: FutureBuilder(
        future: _questions,
        builder: (context, snap) {
          final result = snap.data;
          if (result == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = result.fold((_) => <QuestionModel>[], (l) => l);
          return Column(
            children: [
              Text(
                '${roundName(s, widget.type)} · ${widget.generated ? s.setup_generate : s.setup_from_bank}',
                style: AppTextStyle.large.copyWith(
                  color: GameColors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.r),
                          child: Text(
                            s.setup_bank_empty,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.medium.copyWith(
                              color: GameColors.textMuted,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        itemCount: list.length,
                        separatorBuilder: (_, _) => SizedBox(height: 8.h),
                        itemBuilder: (context, i) {
                          final on = _picked.contains(i);
                          final full = _picked.length >= widget.max;
                          return GestureDetector(
                            onTap: on || !full
                                ? () => setState(
                                    () =>
                                        on ? _picked.remove(i) : _picked.add(i),
                                  )
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: on
                                    ? color.withValues(alpha: 0.2)
                                    : GameColors.panel,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: on ? color : GameColors.panelBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    on
                                        ? Icons.check_circle_rounded
                                        : Icons.circle_outlined,
                                    color: on ? color : GameColors.textSubtle,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _title(s, widget.type, list[i]),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyle.small.copyWith(
                                            color: GameColors.text,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (list[i].answer case final a?
                                            when a.isNotEmpty)
                                          Text(
                                            a,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyle.xSmall.copyWith(
                                              color: GameColors.textMuted,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                  child: GameButton(
                    label: s.setup_add_selected(_picked.length.toArabicDigits),
                    icon: Icons.playlist_add_rounded,
                    onPressed: _picked.isEmpty
                        ? null
                        : () => Navigator.pop(context, [
                            for (final i in _picked.toList()..sort())
                              list[i].toBody(),
                          ]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A question the referee writes; the fields depend on the round.
class _NewQuestionDialog extends StatefulWidget {
  final RoundType type;

  const _NewQuestionDialog({required this.type});

  @override
  State<_NewQuestionDialog> createState() => _NewQuestionDialogState();
}

class _NewQuestionDialogState extends State<_NewQuestionDialog> {
  final _prompt = TextEditingController();
  final _answer = TextEditingController();
  final _refs = TextEditingController();
  final _page = TextEditingController();

  @override
  void dispose() {
    for (final c in [_prompt, _answer, _refs, _page]) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _isSard => widget.type == RoundType.sard;
  bool get _isRightLeft => widget.type == RoundType.rightLeft;
  bool get _needsPrompt =>
      widget.type != RoundType.ayahNumber && !_isSard && !_isRightLeft;
  bool get _needsAnswer =>
      widget.type == RoundType.similar || widget.type == RoundType.buzzer;
  bool get _needsRefs =>
      widget.type != RoundType.ayahNumber && widget.type != RoundType.buzzer;

  /// `2:255، 3:18` → refs (Arabic digits and commas accepted).
  List<Map<String, int>>? get _parsedRefs {
    final parts = toWesternDigits(
      _refs.text,
    ).split(RegExp(r'[,،\s]+')).where((p) => p.isNotEmpty);
    final refs = <Map<String, int>>[];
    for (final p in parts) {
      final m = RegExp(r'^(\d+)[:：](\d+)$').firstMatch(p);
      if (m == null) return null;
      refs.add({'surah': int.parse(m[1]!), 'ayah': int.parse(m[2]!)});
    }
    return refs;
  }

  Map<String, dynamic>? get _body {
    if (widget.type == RoundType.ayahNumber) {
      final page = int.tryParse(toWesternDigits(_page.text.trim()));
      return page == null || page < 1 || page > 604 ? null : {'page': page};
    }
    if (_isRightLeft) {
      // يمين يسار: an even number of ayahs, half for each player.
      final refs = _parsedRefs;
      return refs == null || refs.isEmpty || refs.length.isOdd
          ? null
          : {'refs': refs};
    }
    if (_isSard) {
      // السرد is built from its ayah (opening words and last word).
      final refs = _parsedRefs;
      return refs == null || refs.length != 1 ? null : {'refs': refs};
    }
    final prompt = _prompt.text.trim();
    if (prompt.isEmpty) return null;
    final answer = _answer.text.trim();
    if (_needsAnswer && answer.isEmpty) return null;
    final refs = _needsRefs ? _parsedRefs : const <Map<String, int>>[];
    if (refs == null) return null;
    if (_needsRefs &&
        refs.length < (widget.type == RoundType.similar ? 2 : 1)) {
      return null;
    }
    return {
      'prompt': prompt,
      if (answer.isNotEmpty) 'answer': answer,
      'refs': refs,
    };
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final body = _body;
    InputDecoration field(String label) => InputDecoration(labelText: label);
    return AlertDialog(
      backgroundColor: GameColors.stageTop,
      title: Text('${s.setup_new} · ${roundName(s, widget.type)}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_needsPrompt)
              TextField(
                controller: _page,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                decoration: field(s.setup_page),
                onChanged: (_) => setState(() {}),
              ),
            if (_needsPrompt)
              TextField(
                controller: _prompt,
                maxLines: 3,
                minLines: 1,
                decoration: field(s.setup_prompt),
                onChanged: (_) => setState(() {}),
              ),
            if (_needsAnswer) ...[
              SizedBox(height: 10.h),
              TextField(
                controller: _answer,
                decoration: field(s.setup_answer),
                onChanged: (_) => setState(() {}),
              ),
            ],
            if (_needsRefs) ...[
              SizedBox(height: 10.h),
              TextField(
                controller: _refs,
                textDirection: TextDirection.ltr,
                decoration: _isRightLeft
                    ? field(s.setup_rl_ayahs)
                    : _isSard
                    ? field(s.setup_sard_ayah).copyWith(hintText: '2:255')
                    : field(s.setup_refs).copyWith(hintText: '2:255, 3:18'),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.match_cancel),
        ),
        FilledButton(
          onPressed: body == null ? null : () => Navigator.pop(context, body),
          child: Text(s.setup_add),
        ),
      ],
    );
  }
}

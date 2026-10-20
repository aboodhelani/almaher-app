import 'package:flutter/material.dart';

import '../../../../core/styles/tajweed_palette.dart';
import '../../domain/models/tajweed_span_model.dart';

/// Splits [text] into spans coloured by [spans] (inner spans win over the
/// outer ones they sit in), with optional [backgrounds] painted behind
/// `[start, end)` ranges (later ones win). Anything not covered uses
/// [baseStyle].
///
/// Only colours change between pieces, so Arabic letters keep joining across
/// colour boundaries.
List<TextSpan> tajweedTextSpans(
  String text,
  List<TajweedSpanModel> spans,
  TextStyle baseStyle,
  Brightness brightness, {
  List<(int, int, Color)> backgrounds = const [],
}) {
  if (spans.isEmpty && backgrounds.isEmpty) {
    return [TextSpan(text: text, style: baseStyle)];
  }

  final colors = List<Color?>.filled(text.length, null);
  for (final span in spans) {
    final color = TajweedPalette.of(span.rule, brightness);
    final end = span.end.clamp(0, text.length);
    for (var i = span.start.clamp(0, end); i < end; i++) {
      colors[i] = color;
    }
  }
  final fills = List<Color?>.filled(text.length, null);
  for (final (start, rawEnd, color) in backgrounds) {
    final end = rawEnd.clamp(0, text.length);
    for (var i = start.clamp(0, end); i < end; i++) {
      fills[i] = color;
    }
  }

  final pieces = <TextSpan>[];
  var start = 0;
  for (var i = 1; i <= text.length; i++) {
    if (i == text.length ||
        colors[i] != colors[start] ||
        fills[i] != fills[start]) {
      final color = colors[start];
      final fill = fills[start];
      pieces.add(
        TextSpan(
          text: text.substring(start, i),
          style: color == null && fill == null
              ? baseStyle
              : baseStyle.copyWith(
                  color: color ?? baseStyle.color,
                  backgroundColor: fill ?? baseStyle.backgroundColor,
                ),
        ),
      );
      start = i;
    }
  }
  return pieces;
}

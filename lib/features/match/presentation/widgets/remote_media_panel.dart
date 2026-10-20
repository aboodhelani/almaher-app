import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../../../core/styles/app_text_style.dart';
import '../../../../core/styles/game_colors.dart';
import '../../../../core/translations/l10n.dart';
import '../../domain/models/match_enums.dart';
import '../../domain/models/match_state_model.dart';
import '../bloc/match_bloc.dart';
import 'game_kit.dart';

/// Remote matches: everyone's camera and voice (a LiveKit room per match).
/// A tile for each seat shows its video, or its avatar glowing while it
/// speaks; this device's mic and camera can be switched off.
class RemoteMediaPanel extends StatefulWidget {
  final MatchStateModel match;

  const RemoteMediaPanel({super.key, required this.match});

  @override
  State<RemoteMediaPanel> createState() => _RemoteMediaPanelState();
}

enum _Status { connecting, connected, failed }

class _RemoteMediaPanelState extends State<RemoteMediaPanel> {
  Room? _room;
  EventsListener<RoomEvent>? _events;
  _Status _status = _Status.connecting;
  bool _mic = true;
  bool _camera = true;

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  void dispose() {
    _events?.dispose();
    _room?.removeListener(_refresh);
    _room?.disconnect();
    _room?.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _connect() async {
    setState(() => _status = _Status.connecting);
    final result = await context.read<MatchBloc>().mediaToken();
    final media = result.fold((_) => null, (m) => m);
    if (media == null) {
      if (mounted) setState(() => _status = _Status.failed);
      return;
    }
    final room = Room(
      roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
    );
    try {
      await room.connect(media.url, media.token);
    } catch (_) {
      await room.dispose();
      if (mounted) setState(() => _status = _Status.failed);
      return;
    }
    if (!mounted) {
      await room.disconnect();
      await room.dispose();
      return;
    }
    _room = room;
    room.addListener(_refresh);
    _events = room.createListener()
      ..on<ActiveSpeakersChangedEvent>((_) => _refresh())
      ..on<TrackSubscribedEvent>((_) => _refresh())
      ..on<TrackUnsubscribedEvent>((_) => _refresh())
      ..on<TrackMutedEvent>((_) => _refresh())
      ..on<TrackUnmutedEvent>((_) => _refresh())
      ..on<LocalTrackPublishedEvent>((_) => _refresh());
    setState(() => _status = _Status.connected);
    // The simulator has no camera; voice still works without one.
    await _setMic(true);
    await _setCamera(true);
  }

  Future<void> _setMic(bool on) async {
    try {
      await _room?.localParticipant?.setMicrophoneEnabled(on);
      if (mounted) setState(() => _mic = on);
    } catch (_) {
      if (mounted) setState(() => _mic = false);
    }
  }

  Future<void> _setCamera(bool on) async {
    try {
      await _room?.localParticipant?.setCameraEnabled(on);
      if (mounted) setState(() => _camera = on);
    } catch (_) {
      if (mounted) setState(() => _camera = false);
    }
  }

  /// The room participant sitting in [role] (identities are seat names).
  Participant? _participant(MatchRole role) {
    final room = _room;
    if (room == null) return null;
    final local = room.localParticipant;
    if (local?.identity == role.wire) return local;
    for (final p in room.remoteParticipants.values) {
      if (p.identity == role.wire) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    if (_status != _Status.connected) {
      return GamePanel(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            if (_status == _Status.connecting)
              SizedBox(
                width: 18.r,
                height: 18.r,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Icon(
                Icons.videocam_off_rounded,
                color: GameColors.wrong,
                size: 20.r,
              ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                _status == _Status.connecting
                    ? s.media_connecting
                    : s.media_failed,
                style: AppTextStyle.small.copyWith(color: GameColors.textMuted),
              ),
            ),
            if (_status == _Status.failed)
              TextButton(onPressed: _connect, child: Text(s.media_retry)),
          ],
        ),
      );
    }
    return Column(
      children: [
        Row(
          children: [
            for (final role in [
              MatchRole.player1,
              MatchRole.referee,
              MatchRole.player2,
            ]) ...[
              if (role != MatchRole.player1) SizedBox(width: 8.w),
              Expanded(
                child: _Tile(
                  role: role,
                  name: widget.match.participants[role]?.name,
                  participant: _participant(role),
                  isMe: widget.match.you == role,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Toggle(
              on: _mic,
              onIcon: Icons.mic_rounded,
              offIcon: Icons.mic_off_rounded,
              label: s.media_mic,
              onTap: () => _setMic(!_mic),
            ),
            SizedBox(width: 12.w),
            _Toggle(
              on: _camera,
              onIcon: Icons.videocam_rounded,
              offIcon: Icons.videocam_off_rounded,
              label: s.media_camera,
              onTap: () => _setCamera(!_camera),
            ),
          ],
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  final MatchRole role;
  final String? name;
  final Participant? participant;
  final bool isMe;

  const _Tile({
    required this.role,
    required this.name,
    required this.participant,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final p = participant;
    final color = playerColor(role);
    VideoTrack? video;
    if (p != null) {
      for (final pub in p.videoTrackPublications) {
        final track = pub.track;
        if (track is VideoTrack && !pub.muted) {
          video = track;
          break;
        }
      }
    }
    final speaking = p?.isSpeaking ?? false;
    final micOn = p?.isMicrophoneEnabled() ?? false;
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: speaking ? color : color.withValues(alpha: 0.35),
            width: speaking ? 2.5 : 1,
          ),
          boxShadow: speaking
              ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 16)]
              : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (video != null)
              VideoTrackRenderer(
                video,
                fit: VideoViewFit.cover,
                mirrorMode: isMe
                    ? VideoViewMirrorMode.mirror
                    : VideoViewMirrorMode.off,
              )
            else
              Center(
                child: PlayerAvatar(
                  role: role,
                  name: name,
                  online: p != null,
                  size: 44.r,
                ),
              ),
            Positioned(
              left: 6.w,
              right: 6.w,
              bottom: 6.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      micOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                      size: 12.r,
                      color: micOn ? Colors.white : GameColors.wrong,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        p == null ? s.media_not_here : (name ?? ''),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.xSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  final bool on;
  final IconData onIcon;
  final IconData offIcon;
  final String label;
  final VoidCallback onTap;

  const _Toggle({
    required this.on,
    required this.onIcon,
    required this.offIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Material(
        color: on ? GameColors.panelStrong : GameColors.wrong,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 46.r,
            height: 46.r,
            child: Icon(on ? onIcon : offIcon, color: Colors.white, size: 22.r),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// voice_notes_controller.dart
// ChangeNotifier that manages audio playback for the Voice Notes screen.
//
// DESIGN DECISION – DEDICATED PLAYER:
//  The existing MusicController manages a persistent queue of 25 songs and
//  exposes a MiniPlayer that lives above the bottom navigation. Sharing that
//  controller with voice notes would:
//    • Interrupt the song queue state when a voice note plays.
//    • Cause the MiniPlayer to display voice-note UI (wrong context).
//  Therefore a separate AudioPlayer is used. It is disposed when the user
//  navigates away from the Voice Notes tab OR when the app disposes it.
//
//  CONFLICT PREVENTION:
//  When a voice note starts playing we call MusicController.pause() (if the
//  MusicController is reachable via the Provider tree) to stop music first.
//  This is handled in VoiceNotesScreen by pausing before delegating to this
//  controller. See voice_notes_screen.dart for details.
//
//  ERROR HANDLING:
//  If audioUrl is empty (placeholder) the controller never calls setUrl; it
//  immediately enters _VnState.unconfigured. This prevents any crash.
// ---------------------------------------------------------------------------
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

enum VnState {
  idle,
  loading,
  playing,
  paused,
  unconfigured,
  error,
}

class VoiceNotesController extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  String? _activeId;

  VnState _state = VnState.idle;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _errorMessage;
  bool _handlingCompletion = false;

  String? get activeId => _activeId;
  VnState get state => _state;
  Duration get position => _position;
  Duration get duration => _duration;
  String? get errorMessage => _errorMessage;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<bool> get playingStream => _player.playingStream;

  VoiceNotesController() {
    _player.playerStateStream.listen((ps) async {
      if (ps.processingState == ProcessingState.completed) {
        if (_handlingCompletion) return;
        _handlingCompletion = true;

        await _player.pause();
        await _player.seek(Duration.zero);

        _position = Duration.zero;
        _state = VnState.paused;
        notifyListeners();

        _handlingCompletion = false;
        return;
      }

      if (ps.playing) {
        if (_state != VnState.playing) {
          _state = VnState.playing;
          notifyListeners();
        }
      } else if (ps.processingState == ProcessingState.ready) {
        if (_state == VnState.playing) {
          _state = VnState.paused;
          notifyListeners();
        }
      }
    });

    _player.positionStream.listen((pos) {
      _position = pos;
    });

    _player.durationStream.listen((dur) {
      if (dur != null && dur != _duration) {
        _duration = dur;
        notifyListeners();
      }
    });
  }

  Future<void> toggleNote(String id, String audioUrl) async {
    if (_activeId == id) {
      if (_state == VnState.playing) {
        _state = VnState.paused;
        notifyListeners();
        await _player.pause();
      } else if (_state == VnState.paused || _state == VnState.idle) {
        _state = VnState.playing;
        notifyListeners();
        _player.play();
      }
      return;
    }

    await _player.stop();
    _activeId = id;
    _position = Duration.zero;
    _duration = Duration.zero;
    _errorMessage = null;

    if (audioUrl.isEmpty) {
      _state = VnState.unconfigured;
      notifyListeners();
      return;
    }

    _state = VnState.loading;
    notifyListeners();

    try {
      await _player.setUrl(audioUrl);
      _state = VnState.playing;
      notifyListeners();
      _player.play();
    } catch (e) {
      debugPrint('VoiceNotesController error: $e');
      _errorMessage = 'Could not load this voice note.';
      _state = VnState.error;
      notifyListeners();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> stop() async {
    await _player.stop();
    _activeId = null;
    _state = VnState.idle;
    _position = Duration.zero;
    notifyListeners();
  }

  String formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
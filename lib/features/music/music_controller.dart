import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'music_model.dart';

class MusicController extends ChangeNotifier {
  // Audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // List of all songs
  final List<MusicModel> _songs = MusicModel.getSongs();

  // Currently playing song index
  int _currentIndex = 0;

  // Is player visible
  bool _isPlayerVisible = false;

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  List<MusicModel> get songs => _songs;
  int get currentIndex => _currentIndex;
  MusicModel get currentSong => _songs[_currentIndex];
  bool get isPlayerVisible => _isPlayerVisible;

  // Stream getters for UI to listen to
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  // Check if currently playing
  bool get isPlaying => _audioPlayer.playing;

  MusicController() {
    // Listen to player completion to auto-play next song
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });
  }

  // Play a specific song by index
  Future<void> playSong(int index) async {
    try {
      _currentIndex = index;
      _isPlayerVisible = true;

      // Set audio source
      await _audioPlayer.setUrl(_songs[index].audioUrl);

      // Start playing
      await _audioPlayer.play();

      notifyListeners();
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  // Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    notifyListeners();
  }

  // Play next song
  Future<void> next() async {
    if (_currentIndex < _songs.length - 1) {
      await playSong(_currentIndex + 1);
    } else {
      // Loop back to first song
      await playSong(0);
    }
  }

  // Play previous song
  Future<void> previous() async {
    if (_currentIndex > 0) {
      await playSong(_currentIndex - 1);
    } else {
      // Loop to last song
      await playSong(_songs.length - 1);
    }
  }

  // Seek to a specific position
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Show player bottom sheet
  void showPlayer() {
    _isPlayerVisible = true;
    notifyListeners();
  }

  // Hide player bottom sheet
  void hidePlayer() {
    _isPlayerVisible = false;
    notifyListeners();
  }

  // Format duration to mm:ss
  String formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

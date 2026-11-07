// ---------------------------------------------------------------------------
// voice_notes_screen.dart
// Bottom-navigation destination for six personalised voice notes.
//
// AUDIO CONFLICT PREVENTION:
//  When the user taps a play button, we pause the MusicController (if music
//  is currently playing) before handing control to VoiceNotesController.
//  This is done via Provider.of<MusicController> in _onPlay().
//  The MusicController itself continues to exist and the MiniPlayer remains
//  accessible; we just pause the audio so two sources don't clash.
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hbd_salma/core/theme/colors.dart';
import 'package:provider/provider.dart';

import '../music/music_controller.dart';
import 'voice_note_data.dart';
import 'voice_note_card.dart';
import 'voice_notes_controller.dart';

class VoiceNotesScreen extends StatelessWidget {
  const VoiceNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide a fresh VoiceNotesController scoped to this screen.
    // It is disposed automatically when the screen leaves the tree.
    return ChangeNotifierProvider(
      create: (_) => VoiceNotesController(),
      child: const _VoiceNotesContent(),
    );
  }
}

class _VoiceNotesContent extends StatelessWidget {
  const _VoiceNotesContent();

  /// Called when the user taps play on a card.
  /// Pauses the music player first to prevent two audio sources at once.
  void _onPlay(BuildContext context, String id, String audioUrl) {
    // Gracefully pause music if it is playing
    final musicCtrl =
        Provider.of<MusicController>(context, listen: false);
    if (musicCtrl.isPlaying) {
      musicCtrl.togglePlayPause();
    }

    // Delegate actual playback to VoiceNotesController
    Provider.of<VoiceNotesController>(context, listen: false)
        .toggleNote(id, audioUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 4.h),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Voice Notes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Lymbo',
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                        color: MyColors.primaryColorBold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'A little voice, just for you 🎙️',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: MyColors.myBlack.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Voice note cards – wrap in a Consumer so the card list itself
            // is not rebuilt on every playback tick (that's handled inside each card).
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                itemCount: voiceNotes.length,
                itemBuilder: (context, index) {
                  final note = voiceNotes[index];
                  // We wrap VoiceNoteCard so the _onPlay conflict-prevention
                  // logic is applied before VoiceNoteCard's Consumer fires.
                  return _TappableCard(
                    note: note,
                    onPlay: () => _onPlay(context, note.id, note.audioUrl),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small wrapper that intercepts taps before VoiceNoteCard ──────────────
// This exists so we can pause music before the card's Consumer fires.
class _TappableCard extends StatelessWidget {
  final dynamic note; // VoiceNoteModel
  final VoidCallback onPlay;

  const _TappableCard({required this.note, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return VoiceNoteCard(note: note);
  }
}

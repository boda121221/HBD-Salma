// ---------------------------------------------------------------------------
// voice_note_data.dart
// The six predefined voice note entries.
//
// !! TO ADD YOUR VOICE NOTES:
//    Replace each empty audioUrl string with the real hosted URL.
//    The order of entries is the order shown on screen.
// ---------------------------------------------------------------------------

import 'voice_note_model.dart';

/// The six voice note entries displayed on the Voice Notes screen.
const List<VoiceNoteModel> voiceNotes = [
  VoiceNoteModel(
    id: 'vn_hbd',
    title: 'HBD',
    emoji: '🎂',
    subtitle: 'A special birthday message just for you',
    category: VoiceNoteCategory.hbd,
    // TODO: Replace with the actual hosted voice-note URL.
    audioUrl: 'https://cdn.jsdelivr.net/gh/boda121221/our-story-voice-notes@main/Hbd%201.m4a'

  ),

  VoiceNoteModel(
    id: 'vn_happy',
    title: '2026',
    emoji: '😊',
    subtitle: 'Our first year',
    category: VoiceNoteCategory.happy,
    // TODO: Replace with the actual hosted voice-note URL.
    audioUrl: 'https://cdn.jsdelivr.net/gh/boda121221/our-story-voice-notes@main/2026.mp3',
  ),

  VoiceNoteModel(
    id: 'vn_missing_me',
    title: 'Love you Soso',
    emoji: '💕',
    subtitle: 'For the moments you miss me',
    category: VoiceNoteCategory.missingMe,
    // TODO: Replace with the actual hosted voice-note URL.
    audioUrl: 'https://cdn.jsdelivr.net/gh/boda121221/our-story-voice-notes@main/Soso.m4a',
  ),
];

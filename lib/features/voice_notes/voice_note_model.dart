// ---------------------------------------------------------------------------
// voice_note_model.dart
// Model for a single voice note entry on the Voice Notes screen.
//
// HOW TO ADD YOUR OWN VOICE NOTE URLs:
//  1. Open lib/features/voice_notes/voice_note_data.dart
//  2. Find the entry with the matching category name.
//  3. Replace the empty audioUrl string with your hosted URL.
//     Example: 'https://example.com/voice-notes/hbd.mp3'
//  4. The app will automatically switch from "Not configured" state to playback.
//
// SUPPORTED URL TYPES:
//  - Direct MP3/AAC/OGG URLs (recommended).
//  - GitHub raw content URLs work fine.
//  - The URL must be publicly accessible (no login required).
// ---------------------------------------------------------------------------

/// The six emotion categories for voice notes.
enum VoiceNoteCategory {
  hbd,
  happy,
  missingMe,
  support,
  loved,
  sad,
}

class VoiceNoteModel {
  /// Unique identifier used as map keys and widget keys.
  final String id;

  /// Display name shown on the card (e.g. 'HBD', 'Missing Me').
  final String title;

  /// Emoji shown on the card as the main icon.
  final String emoji;

  /// Short subtitle / description shown below the title.
  final String subtitle;

  /// The emotion category this note belongs to.
  final VoiceNoteCategory category;

  /// URL of the audio file.
  /// Set to an empty string if not yet configured.
  /// The card will show a "Not configured yet" state when empty.
  ///
  /// TODO: Replace each empty string in voice_note_data.dart with the actual hosted URL.
  final String audioUrl;

  const VoiceNoteModel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.subtitle,
    required this.category,
    required this.audioUrl,
  });

  /// Returns true if a real URL has been provided.
  bool get isConfigured => audioUrl.isNotEmpty;
}

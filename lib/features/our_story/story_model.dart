// ---------------------------------------------------------------------------
// story_model.dart
// Model for a single card in the "Our Story" screen.
//
// HOW TO ADD YOUR OWN STORY CARDS:
//  1. Open lib/features/our_story/story_data.dart
//  2. Add a new StoryEntry(...) to the storyEntries list.
//  3. Place the image asset in assets/images/story/ and register it in pubspec.yaml.
//
// The FINAL entry in story_data.dart is the special Dreams card (isDreamsCard: true).
// It does NOT flip – it navigates to the Our Dreams screen when tapped.
// ---------------------------------------------------------------------------

class StoryEntry {
  /// Asset path for the front image, e.g. 'assets/images/story/001.jpg'
  final String imagePath;

  /// Title shown on the back of the card.
  final String title;

  /// Optional date string shown on the back (e.g. '25 November 2023').
  final String? date;

  /// Personal note written in Arabic, shown on the back of the card.
  /// Use right-to-left text automatically – handled by the widget.
  final String arabicNote;

  /// When true this card is the special final 'Dreams' card.
  /// It shows a static design and navigates to Our Dreams instead of flipping.
  final bool isDreamsCard;

  const StoryEntry({
    required this.imagePath,
    required this.title,
    this.date,
    required this.arabicNote,
    this.isDreamsCard = false,
  });
}

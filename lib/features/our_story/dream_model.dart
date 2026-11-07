// ---------------------------------------------------------------------------
// dream_model.dart
// Data model for entries on the "Our Dreams" screen.
//
// Each dream belongs to one of two people, expressed via the DreamOwner enum.
// The owner determines the card's colour scheme:
//   her  → pink theme (MyColors.primaryColor)
//   mine → pastel blue theme (MyColors.myPastelBlue)
// ---------------------------------------------------------------------------

/// Who the dream belongs to.
enum DreamOwner {
  /// Salma's dream – uses the main pink theme.
  her,

  /// My dream – uses the complementary pastel blue theme.
  mine,
}

class DreamEntry {
  /// Short description of the dream / wish.
  final String dream;

  /// Who expressed or "owns" this dream.
  final DreamOwner owner;

  /// Optional small emoji or icon character to show beside the text.
  /// e.g. '✈️', '🌊', '🏕️'
  final String? emoji;

  const DreamEntry({
    required this.dream,
    required this.owner,
    this.emoji,
  });
}

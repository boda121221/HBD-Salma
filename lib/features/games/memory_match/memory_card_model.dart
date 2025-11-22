class MemoryCardModel {
  final String id;
  final String emoji;
  bool isFlipped;
  bool isMatched;

  MemoryCardModel({
    required this.id,
    required this.emoji,
    this.isFlipped = false,
    this.isMatched = false,
  });

  MemoryCardModel copyWith({
    String? id,
    String? emoji,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MemoryCardModel(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }

  // Generate pairs of cards
  static List<MemoryCardModel> generateDeck({int pairs = 8}) {
    final emojis = [
      '💕',
      '🎂',
      '🎈',
      '🎁',
      '🌹',
      '💝',
      '🎉',
      '✨',
      '🍰',
      '🎊',
      '💐',
      '🎀',
    ];

    final selectedEmojis = emojis.take(pairs).toList();
    final cards = <MemoryCardModel>[];

    for (int i = 0; i < selectedEmojis.length; i++) {
      cards.add(MemoryCardModel(id: 'card_${i}_a', emoji: selectedEmojis[i]));
      cards.add(MemoryCardModel(id: 'card_${i}_b', emoji: selectedEmojis[i]));
    }

    cards.shuffle();
    return cards;
  }
}

// ============================================
// FILE: models/birthday_fact_model.dart
// ============================================

class BirthdayFactModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String type; // birth, historical, song, movie, fun
  final int? year;

  BirthdayFactModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.type,
    this.year,
  });

  // Get icon based on fact type
  String get iconEmoji {
    switch (type) {
      case 'birth':
        return '🎂';
      case 'historical':
        return '📜';
      case 'song':
        return '🎵';
      case 'movie':
        return '🎬';
      case 'fun':
        return '✨';
      default:
        return '🎉';
    }
  }

  // Get color based on fact type
  List<int> get gradientColors {
    switch (type) {
      case 'birth':
        return [0xFFFF6B9D, 0xFFFFC371]; // Pink to orange
      case 'historical':
        return [0xFF667EEA, 0xFF764BA2]; // Blue to purple
      case 'song':
        return [0xFFF093FB, 0xFFF5576C]; // Purple to pink
      case 'movie':
        return [0xFF4FACFE, 0xFF00F2FE]; // Blue gradient
      case 'fun':
        return [0xFFFA709A, 0xFFFEE140]; // Pink to yellow
      default:
        return [0xFF667EEA, 0xFF764BA2];
    }
  }

  // Static method to get sample facts
  static List<BirthdayFactModel> getSampleFacts() {
    return [
      BirthdayFactModel(
        id: '1',
        title: 'Famous Birthday',
        description:
            'On November 25, 1960, John F. Kennedy Jr. was born, becoming one of America\'s most beloved public figures.',
        imageUrl: 'https://picsum.photos/seed/fact1/600/400',
        type: 'birth',
        year: 1960,
      ),
      BirthdayFactModel(
        id: '2',
        title: 'Historical Milestone',
        description:
            'November 25, 1867: Alfred Nobel patented dynamite, revolutionizing construction and mining industries worldwide.',
        imageUrl: 'https://picsum.photos/seed/fact2/600/400',
        type: 'historical',
        year: 1867,
      ),
      BirthdayFactModel(
        id: '3',
        title: 'Chart-Topping Hit',
        description:
            'In 1975, Queen\'s "Bohemian Rhapsody" hit #1 on the UK charts on November 25, becoming one of the greatest rock songs ever.',
        imageUrl: 'https://picsum.photos/seed/fact3/600/400',
        type: 'song',
        year: 1975,
      ),
      BirthdayFactModel(
        id: '4',
        title: 'Cinema Classic Released',
        description:
            'On November 25, 1992, "Aladdin" was released by Disney, becoming an instant animated classic loved by millions.',
        imageUrl: 'https://picsum.photos/seed/fact4/600/400',
        type: 'movie',
        year: 1992,
      ),
      BirthdayFactModel(
        id: '5',
        title: 'Fun Birthday Fact',
        description:
            'People born on November 25th are Sagittarius! They\'re known for being adventurous, optimistic, and free-spirited.',
        imageUrl: 'https://picsum.photos/seed/fact5/600/400',
        type: 'fun',
      ),
      BirthdayFactModel(
        id: '6',
        title: 'World Record Day',
        description:
            'November 25, 2011: The world\'s largest birthday cake was created in India, weighing 24,000 kg!',
        imageUrl: 'https://picsum.photos/seed/fact6/600/400',
        type: 'fun',
        year: 2011,
      ),
      BirthdayFactModel(
        id: '7',
        title: 'Sports Legend Born',
        description:
            'Ricardo Montalbán, the iconic actor, was born on November 25, 1920, bringing joy to millions through his performances.',
        imageUrl: 'https://picsum.photos/seed/fact7/600/400',
        type: 'birth',
        year: 1920,
      ),
      BirthdayFactModel(
        id: '8',
        title: 'Musical Innovation',
        description:
            'The first jukebox made its debut on November 25, 1889, forever changing how people enjoyed music in public spaces.',
        imageUrl: 'https://picsum.photos/seed/fact8/600/400',
        type: 'historical',
        year: 1889,
      ),
    ];
  }
}

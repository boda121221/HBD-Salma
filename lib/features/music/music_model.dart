class MusicModel {
  final String id;
  final String title;
  final String? artist;
  final String imageUrl;
  final String audioUrl;
  final Duration duration;

  MusicModel({
    required this.id,
    required this.title,
    this.artist,
    required this.imageUrl,
    required this.audioUrl,
    required this.duration,
  });

  // Static list of songs stored locally in the app
  static List<MusicModel> getSongs() {
    return [
      MusicModel(
        id: '1',
        title: 'Die With A Smile',
        artist: 'Lady Gaga & Bruno Mars',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/lady_gaga_bruno_mars_die_with_a_smile.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/lady_gaga_bruno_mars_die_with_a_smile.mp3',
        duration: const Duration(minutes: 4, seconds: 12),
      ),
      MusicModel(
        id: '2',
        title: 'Mafi Menek',
        artist: 'Aziz Maraka',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/mafi_menek.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/aziz_maraka_mafi_mennik.mp3',
        duration: const Duration(minutes: 5, seconds: 6),
      ),
      MusicModel(
        id: '3',
        title: 'Shape of You',
        artist: 'Ed Sheeran',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/ed_sheeran_shape_of_you.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/ed_sheeran_shape_of_you.mp3',
        duration: const Duration(minutes: 4, seconds: 23),
      ),
      MusicModel(
        id: '4',
        title: 'Girls Like You',
        artist: 'Maroon 5',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/maroon_5_girls_like_you_ft_cardi_b.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/maroon_5_girls_like_you_ft_cardi_b.mp3',
        duration: const Duration(minutes: 4, seconds: 30),
      ),
      MusicModel(
        id: '5',
        title: 'Perfect',
        artist: 'Ed Sheeran',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/perfect.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/ed_sheeran_perfect.mp3',
        duration: const Duration(minutes: 4, seconds: 41),
      ),
      MusicModel(
        id: '6',
        title: 'Just The Way You Are',
        artist: 'Bruno Mars',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/just_the_way_you_are.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/bruno_mars_just_the_way_you_are.mp3',
        duration: const Duration(minutes: 3, seconds: 56),
      ),
      MusicModel(
        id: '7',
        title: 'Love Story',
        artist: 'Indila',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/indila_love_story.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/indila_love_story.mp3',
        duration: const Duration(minutes: 4, seconds: 44),
      ),
      MusicModel(
        id: '8',
        title: 'Until I Found You',
        artist: 'Em Beihold',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/until_i_found_you_em_beihold_version.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/until_i_found_you_em_beihold_version.mp3',
        duration: const Duration(minutes: 2, seconds: 56),
      ),
      MusicModel(
        id: '9',
        title: 'Fly Me to the Moon',
        artist: 'Frank Sinatra',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/fly_me_to_the_moon.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/fly_me_to_the_moon.mp3',
        duration: const Duration(minutes: 2, seconds: 27),
      ),
      MusicModel(
        id: '10',
        title: 'A Thousand Years',
        artist: 'Christina Perri',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/thousand_year.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/christina_perri_a_thousand_years.mp3',
        duration: const Duration(minutes: 4, seconds: 47),
      ),
      MusicModel(
        id: '11',
        title: 'Sway',
        artist: 'Michael Bublé',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/michael_bubl%C3%A9_sway.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/michael_bubl%C3%A9_sway.mp3',
        duration: const Duration(minutes: 3, seconds: 10),
      ),
      MusicModel(
        id: '12',
        title: 'Those Eyes',
        artist: 'New West',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/those_eyes.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/those_eyes.mp3',
        duration: const Duration(minutes: 3, seconds: 40),
      ),
      MusicModel(
        id: '13',
        title: 'Bilionera',
        artist: 'Otilia',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/otilia_bilionera.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/otilia_bilionera.mp3',
        duration: const Duration(minutes: 3, seconds: 5),
      ),
      MusicModel(
        id: '14',
        title: 'Dusk Till Dawn',
        artist: 'Zayn ft. Sia',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/zayn_dusk_till_dawn_ft_sia.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/zayn_dusk_till_dawn_ft_sia.mp3',
        duration: const Duration(minutes: 5, seconds: 37),
      ),
      MusicModel(
        id: '15',
        title: 'Ana Meen',
        artist: 'Marilyn & Naama',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/ana_meen.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/ana%20_min_marylin_naama.mp3',
        duration: const Duration(minutes: 3, seconds: 3),
      ),
      MusicModel(
        id: '16',
        title: 'Bloodline',
        artist: 'Ariana Grande',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/blood_line.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/ariana_grande_bloodline.mp3',
        duration: const Duration(minutes: 3, seconds: 37),
      ),
      MusicModel(
        id: '17',
        title: 'Bleeding',
        artist: 'TalkinToYs',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/talkintoys_bleeding.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/talkintoys_bleeding.mp3',
        duration: const Duration(minutes: 3, seconds: 22),
      ),
      MusicModel(
        id: '18',
        title: 'Anxiety',
        artist: 'Doechii',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/anxiety.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/doechii_anxiety.mp3',
        duration: const Duration(minutes: 4, seconds: 11),
      ),
      MusicModel(
        id: '19',
        title: 'Sailor Song',
        artist: 'Gigi Perez',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/sailor_song.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/sailor_song.mp3',
        duration: const Duration(minutes: 3, seconds: 32),
      ),
      MusicModel(
        id: '20',
        title: 'Shower',
        artist: 'Becky G',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/shower.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/becky_g_shower.mp3',
        duration: const Duration(minutes: 3, seconds: 39),
      ),
      MusicModel(
        id: '21',
        title: 'Kalam Eineh',
        artist: 'Sherine',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/sherine_kalam_eineh.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/sherine_kalam_eineh.mp3',
        duration: const Duration(minutes: 3, seconds: 57),
      ),
      MusicModel(
        id: '22',
        title: 'Diamonds',
        artist: 'Rihanna',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/rihanna_diamonds.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/rihanna_diamonds.mp3',
        duration: const Duration(minutes: 4, seconds: 42),
      ),
      MusicModel(
        id: '23',
        title: 'No One Noticed',
        artist: 'The Marías',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/the_mar%C3%ADas_no_one_noticed.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/the_mar%C3%ADas_no_one_noticed.mp3',
        duration: const Duration(minutes: 3, seconds: 57),
      ),
      MusicModel(
        id: '24',
        title: 'Love Me Like You Do',
        artist: 'Ellie Goulding',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/ellie_goulding_love_me_like_you_do.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/ellie_goulding_love_me_like_you_do.mp3',
        duration: const Duration(minutes: 4, seconds: 9),
      ),
      MusicModel(
        id: '25',
        title: 'Wildflower',
        artist: 'Billie Eilish',
        imageUrl:
            'https://raw.githubusercontent.com/bodasayed1/HBD-music/refs/heads/main/images/wildflower.jpg',
        audioUrl:
            'https://github.com/bodasayed1/HBD-music/raw/refs/heads/main/music/billie_eilish_wildflower.mp3',
        duration: const Duration(minutes: 4, seconds: 21),
      ),
    ];
  }
}

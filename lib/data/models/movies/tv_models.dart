class Season {
  final int id;
  final String name;
  final int? number;
  final String? posterUrl;
  final String? overview;
  final String? airDate;
  final int? episodeCount;

  Season({
    required this.id,
    required this.name,
    this.number,
    this.posterUrl,
    this.overview,
    this.airDate,
    this.episodeCount,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      posterUrl: json['poster_url'],
      overview: json['overview'],
      airDate: json['air_date'],
      episodeCount: json['episode_count'],
    );
  }
}

class Episode {
  final int id;
  final String name;
  final int episodeNumber;
  final int seasonNumber;
  final int? seasonId;
  final String? tmdbId;
  final String? imdbId;
  final String? thumbnailUrl;
  final String? releaseDate;
  final int? runtimeMinutes;
  final String? overview;
  final List<EpisodeSource>? sources;

  Episode({
    required this.id,
    required this.name,
    required this.episodeNumber,
    required this.seasonNumber,
    this.seasonId,
    this.tmdbId,
    this.imdbId,
    this.thumbnailUrl,
    this.releaseDate,
    this.runtimeMinutes,
    this.overview,
    this.sources,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      episodeNumber: json['episode_number'],
      seasonNumber: json['season_number'],
      seasonId: json['season_id'],
      tmdbId: json['tmdb_id']?.toString(),
      imdbId: json['imdb_id'],
      thumbnailUrl: json['thumbnail_url'],
      releaseDate: json['release_date'],
      runtimeMinutes: json['runtime_minutes'],
      overview: json['overview'],
      sources: json['sources'] != null
          ? (json['sources'] as List)
          .map((source) => EpisodeSource.fromJson(source))
          .toList()
          : null,
    );
  }
}

class EpisodeSource {
  final int sourceId;
  final String name;
  final String type; // sub, buy, free, etc.
  final String region;
  final String? iosUrl;
  final String? androidUrl;
  final String? webUrl;
  final String format;
  final double? price;

  EpisodeSource({
    required this.sourceId,
    required this.name,
    required this.type,
    required this.region,
    this.iosUrl,
    this.androidUrl,
    this.webUrl,
    required this.format,
    this.price,
  });

  factory EpisodeSource.fromJson(Map<String, dynamic> json) {
    return EpisodeSource(
      sourceId: json['source_id'],
      name: json['name'],
      type: json['type'],
      region: json['region'],
      iosUrl: json['ios_url'],
      androidUrl: json['android_url'],
      webUrl: json['web_url'],
      format: json['format'] ?? '',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
    );
  }
}
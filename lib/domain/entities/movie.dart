class StreamingSource {
  final String id;
  final String name;
  final String type; // sub, buy, free, etc.
  final String region;
  final String webUrl;
  final String format;
  final String? price;

  StreamingSource({
    required this.id,
    required this.name,
    required this.type,
    required this.region,
    required this.webUrl,
    required this.format,
    this.price,
  });
}

class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String poster;
  final String? plot;
  final String? runtime;
  final String? genre;
  final String? director;
  final String? actors;
  final String? imdbRating;
  final bool isInWatchlist;

  // Watchmode specific fields
  final String? watchmodeId;
  final List<StreamingSource>? streamingSources;
  final String? type; // 'movie', 'tv_series', 'tv_miniseries', 'tv_special', etc.

  Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
    this.plot,
    this.runtime,
    this.genre,
    this.director,
    this.actors,
    this.imdbRating,
    this.isInWatchlist = false,
    this.watchmodeId,
    this.streamingSources,
    this.type,
  });
}
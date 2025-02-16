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
  });
}
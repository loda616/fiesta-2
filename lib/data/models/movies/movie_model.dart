import 'package:injectable/injectable.dart';
import '../../../domain/entities/movie.dart';
import '../watchmode_models.dart' as watchmode;

@injectable
class MovieModel extends Movie {
  MovieModel({
    required String imdbId,
    required String title,
    required String year,
    required String poster,
    String? plot,
    String? runtime,
    String? genre,
    String? director,
    String? actors,
    String? imdbRating,
    bool isInWatchlist = false,
    String? watchmodeId,
    List<StreamingSource>? streamingSources,
    String? type,
    String? trailer,
    String? backdrop,
    List<String>? genreNames,
    String? releaseDate,
    double? userRating,
    int? runtimeMinutes,
  }) : super(
    imdbId: imdbId,
    title: title,
    year: year,
    poster: poster,
    plot: plot,
    runtime: runtime,
    genre: genre,
    director: director,
    actors: actors,
    imdbRating: imdbRating,
    isInWatchlist: isInWatchlist,
    watchmodeId: watchmodeId,
    streamingSources: streamingSources,
    type: type,
    trailer: trailer,
    backdrop: backdrop,
    genreNames: genreNames,
    releaseDate: releaseDate,
    userRating: userRating,
    runtimeMinutes: runtimeMinutes,
  );

  // Add a copyWith method to create a new instance with updated fields
  MovieModel copyWith({
    String? imdbId,
    String? title,
    String? year,
    String? poster,
    String? plot,
    String? runtime,
    String? genre,
    String? director,
    String? actors,
    String? imdbRating,
    bool? isInWatchlist,
    String? watchmodeId,
    List<StreamingSource>? streamingSources,
    String? type,
    String? trailer,
    String? backdrop,
    List<String>? genreNames,
    String? releaseDate,
    double? userRating,
    int? runtimeMinutes,
  }) {
    return MovieModel(
      imdbId: imdbId ?? this.imdbId,
      title: title ?? this.title,
      year: year ?? this.year,
      poster: poster ?? this.poster,
      plot: plot ?? this.plot,
      runtime: runtime ?? this.runtime,
      genre: genre ?? this.genre,
      director: director ?? this.director,
      actors: actors ?? this.actors,
      imdbRating: imdbRating ?? this.imdbRating,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      watchmodeId: watchmodeId ?? this.watchmodeId,
      streamingSources: streamingSources ?? this.streamingSources,
      type: type ?? this.type,
      trailer: trailer ?? this.trailer,
      backdrop: backdrop ?? this.backdrop,
      genreNames: genreNames ?? this.genreNames,
      releaseDate: releaseDate ?? this.releaseDate,
      userRating: userRating ?? this.userRating,
      runtimeMinutes: runtimeMinutes ?? this.runtimeMinutes,
    );
  }

  // Original fromJson method for OMDB (keep for backward compatibility)
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      imdbId: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      poster: json['Poster'] != 'N/A' ? json['Poster'] : '',
      plot: json['Plot'],
      runtime: json['Runtime'],
      genre: json['Genre'],
      director: json['Director'],
      actors: json['Actors'],
      imdbRating: json['imdbRating'],
      watchmodeId: json['watchmodeId'],
      trailer: json['trailer'],
      backdrop: json['backdrop'],
    );
  }

  // New method for Watchmode search results
  factory MovieModel.fromWatchmodeJson(watchmode.TitleResult result) {
    return MovieModel(
      watchmodeId: result.id.toString(),
      imdbId: result.imdbId ?? '',
      title: result.name,
      year: result.year?.toString() ?? '',
      poster: '', // Basic search doesn't provide poster
      type: result.type,
      // These fields might not be available in search results
      plot: null,
      runtime: null,
      genre: null,
      director: null,
      actors: null,
      imdbRating: null,
    );
  }

  // Method for Watchmode detailed movie info
  factory MovieModel.fromWatchmodeDetailJson(watchmode.TitleDetailsResponse json) {
    // Convert Watchmode streaming sources to our model
    List<StreamingSource>? streamingSources;
    if (json.sources != null) {
      streamingSources = json.sources!.map((source) => StreamingSource(
        id: source.sourceId.toString(),
        name: source.name,
        type: source.type,
        region: source.region,
        webUrl: source.webUrl,
        format: source.format,
        price: source.price?.toString(),
      )).toList();
    }

    // Generate genre string from genre names
    String? genreString;
    if (json.genreNames != null && json.genreNames!.isNotEmpty) {
      genreString = json.genreNames!.join(', ');
    }

    return MovieModel(
      watchmodeId: json.id.toString(),
      imdbId: json.imdbId ?? '',
      title: json.title,
      year: json.year?.toString() ?? '',
      poster: json.poster ?? '',
      plot: json.plotOverview,
      runtime: json.runtimeMinutes != null ? '${json.runtimeMinutes} min' : null,
      genre: genreString,
      // For director and actors, we would need to make separate calls to cast-crew endpoint
      director: null,
      actors: null,
      imdbRating: json.userRating?.toString(),
      streamingSources: streamingSources,
      type: json.type,
      trailer: json.trailer,
      backdrop: json.backdrop,
      genreNames: json.genreNames,
      releaseDate: json.releaseDate,
      userRating: json.userRating,
      runtimeMinutes: json.runtimeMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbId,
      'Title': title,
      'Year': year,
      'Poster': poster,
      'Plot': plot,
      'Runtime': runtime,
      'Genre': genre,
      'Director': director,
      'Actors': actors,
      'imdbRating': imdbRating,
      'watchmodeId': watchmodeId,
      'trailer': trailer,
      'backdrop': backdrop,
    };
  }
}
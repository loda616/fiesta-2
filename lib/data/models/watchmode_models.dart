import 'package:json_annotation/json_annotation.dart';

part 'watchmode_models.g.dart';

// Response classes

@JsonSerializable()
class SearchResponse {
  @JsonKey(name: 'title_results')
  final List<TitleResult>? titleResults;

  @JsonKey(name: 'people_results')
  final List<PersonResult>? peopleResults;

  SearchResponse({this.titleResults, this.peopleResults});

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);
}

@JsonSerializable()
class AutocompleteResponse {
  final List<AutocompleteResult> results;

  AutocompleteResponse({required this.results});

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) =>
      _$AutocompleteResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AutocompleteResponseToJson(this);
}

@JsonSerializable()
class ListTitlesResponse {
  final List<TitleResult> titles;
  final int page;

  @JsonKey(name: 'total_results')
  final int totalResults;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  ListTitlesResponse({
    required this.titles,
    required this.page,
    required this.totalResults,
    required this.totalPages,
  });

  factory ListTitlesResponse.fromJson(Map<String, dynamic> json) =>
      _$ListTitlesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListTitlesResponseToJson(this);
}

@JsonSerializable()
class ReleasesResponse {
  final List<ReleaseItem> releases;

  ReleasesResponse({required this.releases});

  factory ReleasesResponse.fromJson(Map<String, dynamic> json) =>
      _$ReleasesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReleasesResponseToJson(this);
}

// Result models

@JsonSerializable()
class TitleResult {
  final int id;
  final String name;
  final String type;
  final int? year;

  @JsonKey(name: 'imdb_id')
  final String? imdbId;

  @JsonKey(name: 'tmdb_id')
  final int? tmdbId;

  @JsonKey(name: 'tmdb_type')
  final String? tmdbType;

  TitleResult({
    required this.id,
    required this.name,
    required this.type,
    this.year,
    this.imdbId,
    this.tmdbId,
    this.tmdbType,
  });

  factory TitleResult.fromJson(Map<String, dynamic> json) =>
      _$TitleResultFromJson(json);

  Map<String, dynamic> toJson() => _$TitleResultToJson(this);
}

@JsonSerializable()
class PersonResult {
  final int id;
  final String name;

  @JsonKey(name: 'main_profession')
  final String? mainProfession;

  @JsonKey(name: 'imdb_id')
  final String? imdbId;

  @JsonKey(name: 'tmdb_id')
  final int? tmdbId;

  PersonResult({
    required this.id,
    required this.name,
    this.mainProfession,
    this.imdbId,
    this.tmdbId,
  });

  factory PersonResult.fromJson(Map<String, dynamic> json) =>
      _$PersonResultFromJson(json);

  Map<String, dynamic> toJson() => _$PersonResultToJson(this);
}

@JsonSerializable()
class AutocompleteResult {
  final String name;
  final double relevance;
  final String type;
  final int id;
  final int? year;

  @JsonKey(name: 'result_type')
  final String resultType;

  @JsonKey(name: 'tmdb_id')
  final int? tmdbId;

  @JsonKey(name: 'tmdb_type')
  final String? tmdbType;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  AutocompleteResult({
    required this.name,
    required this.relevance,
    required this.type,
    required this.id,
    this.year,
    required this.resultType,
    this.tmdbId,
    this.tmdbType,
    this.imageUrl,
  });

  factory AutocompleteResult.fromJson(Map<String, dynamic> json) =>
      _$AutocompleteResultFromJson(json);

  Map<String, dynamic> toJson() => _$AutocompleteResultToJson(this);
}

@JsonSerializable()
class ReleaseItem {
  final int id;
  final String title;
  final String type;

  @JsonKey(name: 'tmdb_id')
  final int? tmdbId;

  @JsonKey(name: 'tmdb_type')
  final String? tmdbType;

  @JsonKey(name: 'imdb_id')
  final String? imdbId;

  @JsonKey(name: 'season_number')
  final int? seasonNumber;

  @JsonKey(name: 'poster_url')
  final String? posterUrl;

  @JsonKey(name: 'source_release_date')
  final String? sourceReleaseDate;

  @JsonKey(name: 'source_id')
  final int sourceId;

  @JsonKey(name: 'source_name')
  final String sourceName;

  @JsonKey(name: 'is_original')
  final int isOriginal;

  ReleaseItem({
    required this.id,
    required this.title,
    required this.type,
    this.tmdbId,
    this.tmdbType,
    this.imdbId,
    this.seasonNumber,
    this.posterUrl,
    this.sourceReleaseDate,
    required this.sourceId,
    required this.sourceName,
    required this.isOriginal,
  });

  factory ReleaseItem.fromJson(Map<String, dynamic> json) =>
      _$ReleaseItemFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseItemToJson(this);
}

// Title details models

@JsonSerializable()
class TitleDetailsResponse {
  final int id;
  final String title;

  @JsonKey(name: 'original_title')
  final String? originalTitle;

  @JsonKey(name: 'plot_overview')
  final String? plotOverview;

  final String type;

  @JsonKey(name: 'runtime_minutes')
  final int? runtimeMinutes;

  final int? year;

  @JsonKey(name: 'end_year')
  final int? endYear;

  @JsonKey(name: 'release_date')
  final String? releaseDate;

  @JsonKey(name: 'imdb_id')
  final String? imdbId;

  @JsonKey(name: 'tmdb_id')
  final int? tmdbId;

  @JsonKey(name: 'tmdb_type')
  final String? tmdbType;

  final List<int>? genres;

  @JsonKey(name: 'genre_names')
  final List<String>? genreNames;

  @JsonKey(name: 'user_rating')
  final double? userRating;

  @JsonKey(name: 'critic_score')
  final int? criticScore;

  @JsonKey(name: 'us_rating')
  final String? usRating;

  final String? poster;
  final String? backdrop;

  @JsonKey(name: 'original_language')
  final String? originalLanguage;

  @JsonKey(name: 'similar_titles')
  final List<int>? similarTitles;

  final List<int>? networks;

  @JsonKey(name: 'network_names')
  final List<String>? networkNames;

  final String? trailer;

  @JsonKey(name: 'trailer_thumbnail')
  final String? trailerThumbnail;

  @JsonKey(name: 'relevance_percentile')
  final double? relevancePercentile;

  final List<StreamingSource>? sources;

  TitleDetailsResponse({
    required this.id,
    required this.title,
    this.originalTitle,
    this.plotOverview,
    required this.type,
    this.runtimeMinutes,
    this.year,
    this.endYear,
    this.releaseDate,
    this.imdbId,
    this.tmdbId,
    this.tmdbType,
    this.genres,
    this.genreNames,
    this.userRating,
    this.criticScore,
    this.usRating,
    this.poster,
    this.backdrop,
    this.originalLanguage,
    this.similarTitles,
    this.networks,
    this.networkNames,
    this.trailer,
    this.trailerThumbnail,
    this.relevancePercentile,
    this.sources,
  });

  factory TitleDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$TitleDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TitleDetailsResponseToJson(this);
}

@JsonSerializable()
class StreamingSource {
  @JsonKey(name: 'source_id')
  final int sourceId;

  final String name;
  final String type;
  final String region;

  @JsonKey(name: 'ios_url')
  final String? iosUrl;

  @JsonKey(name: 'android_url')
  final String? androidUrl;

  @JsonKey(name: 'web_url')
  final String webUrl;

  final String format;
  final dynamic price; // Can be null, String, or double
  final int? seasons;
  final int? episodes;

  StreamingSource({
    required this.sourceId,
    required this.name,
    required this.type,
    required this.region,
    this.iosUrl,
    this.androidUrl,
    required this.webUrl,
    required this.format,
    this.price,
    this.seasons,
    this.episodes,
  });

  factory StreamingSource.fromJson(Map<String, dynamic> json) =>
      _$StreamingSourceFromJson(json);

  Map<String, dynamic> toJson() => _$StreamingSourceToJson(this);
}

@JsonSerializable()
class CastCrewMember {
  @JsonKey(name: 'person_id')
  final int personId;

  final String type; // "Cast" or "Crew"

  @JsonKey(name: 'full_name')
  final String fullName;

  @JsonKey(name: 'headshot_url')
  final String? headshotUrl;

  final String? role;

  @JsonKey(name: 'episode_count')
  final int? episodeCount;

  final int? order;

  CastCrewMember({
    required this.personId,
    required this.type,
    required this.fullName,
    this.headshotUrl,
    this.role,
    this.episodeCount,
    this.order,
  });

  factory CastCrewMember.fromJson(Map<String, dynamic> json) =>
      _$CastCrewMemberFromJson(json);

  Map<String, dynamic> toJson() => _$CastCrewMemberToJson(this);
}

// TV Show models

@JsonSerializable()
class Season {
  final int id;
  final String name;
  final int? number;

  @JsonKey(name: 'poster_url')
  final String? posterUrl;

  final String? overview;

  @JsonKey(name: 'air_date')
  final String? airDate;

  @JsonKey(name: 'episode_count')
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

  factory Season.fromJson(Map<String, dynamic> json) => _$SeasonFromJson(json);
  Map<String, dynamic> toJson() => _$SeasonToJson(this);
}

@JsonSerializable()
class Episode {
  final int id;
  final String name;

  @JsonKey(name: 'episode_number')
  final int episodeNumber;

  @JsonKey(name: 'season_number')
  final int seasonNumber;

  @JsonKey(name: 'season_id')
  final int? seasonId;

  @JsonKey(name: 'tmdb_id')
  final dynamic tmdbId; // Can be int or String

  @JsonKey(name: 'imdb_id')
  final String? imdbId;

  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;

  @JsonKey(name: 'release_date')
  final String? releaseDate;

  @JsonKey(name: 'runtime_minutes')
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

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}

@JsonSerializable()
class EpisodeSource {
  @JsonKey(name: 'source_id')
  final int sourceId;

  final String name;
  final String type;
  final String region;

  @JsonKey(name: 'ios_url')
  final String? iosUrl;

  @JsonKey(name: 'android_url')
  final String? androidUrl;

  @JsonKey(name: 'web_url')
  final String? webUrl;

  final String format;
  final dynamic price; // Can be null, String, or double

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

  factory EpisodeSource.fromJson(Map<String, dynamic> json) =>
      _$EpisodeSourceFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeSourceToJson(this);
}

// Configuration models

@JsonSerializable()
class StreamingSourceInfo {
  final int id;
  final String name;
  final String type;

  @JsonKey(name: 'logo_100px')
  final String? logo100px;

  @JsonKey(name: 'ios_appstore_url')
  final String? iosAppstoreUrl;

  @JsonKey(name: 'android_playstore_url')
  final String? androidPlaystoreUrl;

  @JsonKey(name: 'android_scheme')
  final String? androidScheme;

  @JsonKey(name: 'ios_scheme')
  final String? iosScheme;

  final List<String>? regions;

  StreamingSourceInfo({
    required this.id,
    required this.name,
    required this.type,
    this.logo100px,
    this.iosAppstoreUrl,
    this.androidPlaystoreUrl,
    this.androidScheme,
    this.iosScheme,
    this.regions,
  });

  factory StreamingSourceInfo.fromJson(Map<String, dynamic> json) =>
      _$StreamingSourceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StreamingSourceInfoToJson(this);
}

@JsonSerializable()
class Genre {
  final int id;
  final String name;

  @JsonKey(name: 'tmdb_id')
  final int? tmdbId;

  Genre({
    required this.id,
    required this.name,
    this.tmdbId,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable()
class Region {
  final String country;
  final String name;
  final String? flag;

  @JsonKey(name: 'data_tier')
  final int dataTier;

  @JsonKey(name: 'plan_enabled')
  final bool planEnabled;

  Region({
    required this.country,
    required this.name,
    this.flag,
    required this.dataTier,
    required this.planEnabled,
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);
}

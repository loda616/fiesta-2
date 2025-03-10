import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/watchmode_models.dart';

part 'watchmode_api_client.g.dart';

@injectable
@RestApi(baseUrl: "https://api.watchmode.com/v1")
abstract class WatchmodeApiClient {
  @factoryMethod
  factory WatchmodeApiClient(Dio dio) = _WatchmodeApiClient;

  // Search for movies/TV shows
  @GET("/search/")
  Future<SearchResponse> search({
    @Query("apiKey") required String apiKey,
    @Query("search_field") required String searchField,
    @Query("search_value") required String searchValue,
    @Query("types") String? types,
  });

  // Autocomplete search
  @GET("/autocomplete-search/")
  Future<AutocompleteResponse> autocompleteSearch({
    @Query("apiKey") required String apiKey,
    @Query("search_value") required String searchValue,
    @Query("search_type") int? searchType,
  });

  // Get title details
  @GET("/title/{titleId}/details/")
  Future<TitleDetailsResponse> getTitleDetails({
    @Path("titleId") required String titleId,
    @Query("apiKey") required String apiKey,
    @Query("append_to_response") String? appendToResponse,
  });

  // Get title sources (streaming platforms)
  @GET("/title/{titleId}/sources/")
  Future<List<StreamingSource>> getTitleSources({
    @Path("titleId") required String titleId,
    @Query("apiKey") required String apiKey,
    @Query("regions") String? regions,
  });

  // Get title recommendations/similar titles
  @GET("/title/{titleId}/similar/")
  Future<List<TitleResult>> getSimilarTitles({
    @Path("titleId") required String titleId,
    @Query("apiKey") required String apiKey,
  });

  // Get title cast & crew
  @GET("/title/{titleId}/cast-crew/")
  Future<List<CastCrewMember>> getTitleCastCrew({
    @Path("titleId") required String titleId,
    @Query("apiKey") required String apiKey,
  });

  // Get TV Show seasons
  @GET("/title/{titleId}/seasons/")
  Future<List<Season>> getTitleSeasons({
    @Path("titleId") required String titleId,
    @Query("apiKey") required String apiKey,
  });

  // Get TV Show episodes
  @GET("/title/{titleId}/episodes/")
  Future<List<Episode>> getTitleEpisodes({
    @Path("titleId") required String titleId,
    @Query("apiKey") required String apiKey,
  });

  // Get streaming sources list
  @GET("/sources/")
  Future<List<StreamingSourceInfo>> getSources({
    @Query("apiKey") required String apiKey,
    @Query("types") String? types,
  });

  // Get genres list
  @GET("/genres/")
  Future<List<Genre>> getGenres({
    @Query("apiKey") required String apiKey,
  });

  // Get regions list
  @GET("/regions/")
  Future<List<Region>> getRegions({
    @Query("apiKey") required String apiKey,
  });

  // List titles with filters
  @GET("/list-titles/")
  Future<ListTitlesResponse> listTitles({
    @Query("apiKey") required String apiKey,
    @Query("types") String? types,
    @Query("source_ids") String? sourceIds,
    @Query("genres") String? genres,
    @Query("regions") String? regions,
    @Query("page") int? page,
    @Query("limit") int? limit,
    @Query("sort_by") String? sortBy,
  });

  // Get new streaming releases
  @GET("/releases/")
  Future<ReleasesResponse> getNewReleases({
    @Query("apiKey") required String apiKey,
    @Query("start_date") String? startDate,
    @Query("end_date") String? endDate,
    @Query("source_ids") String? sourceIds,
    @Query("regions") String? regions,
    @Query("page") int? page,
  });
}
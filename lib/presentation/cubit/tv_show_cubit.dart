import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/Watchmode/watchmode_api_source.dart' show WatchmodeApiSource;
import '../../data/models/movies/tv_models.dart';

// TV Show State
abstract class TvShowState {}

class TvShowInitial extends TvShowState {}

class TvShowLoading extends TvShowState {}

class TvShowError extends TvShowState {
  final String message;
  TvShowError(this.message);
}

class TvShowSeasonsLoaded extends TvShowState {
  final List<Season> seasons;
  TvShowSeasonsLoaded(this.seasons);
}

class TvShowEpisodesLoaded extends TvShowState {
  final List<Episode> episodes;
  TvShowEpisodesLoaded(this.episodes);
}

// TV Show Cubit
class TvShowCubit extends Cubit<TvShowState> {
  final WatchmodeApiSource watchmodeApiSource;

  TvShowCubit({required this.watchmodeApiSource}) : super(TvShowInitial());

  Future<void> loadSeasons(String tvShowId) async {
    emit(TvShowLoading());

    try {
      final seasonsJson = await watchmodeApiSource.getTvShowSeasons(tvShowId);
      final seasons = seasonsJson.map((json) => Season.fromJson(json)).toList();

      // Sort seasons by number (if available)
      seasons.sort((a, b) {
        if (a.number == null || b.number == null) {
          return 0;
        }
        return a.number!.compareTo(b.number!);
      });

      emit(TvShowSeasonsLoaded(seasons));
    } catch (e) {
      emit(TvShowError('Failed to load seasons: ${e.toString()}'));
    }
  }

  Future<void> loadEpisodes(String tvShowId, int seasonNumber) async {
    emit(TvShowLoading());

    try {
      final episodesJson = await watchmodeApiSource.getTvShowEpisodes(tvShowId);

      // Filter episodes for the specified season
      final allEpisodes = episodesJson
          .map((json) => Episode.fromJson(json))
          .toList();

      final seasonEpisodes = allEpisodes
          .where((episode) => episode.seasonNumber == seasonNumber)
          .toList();

      // Sort episodes by episode number
      seasonEpisodes.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));

      emit(TvShowEpisodesLoaded(seasonEpisodes));
    } catch (e) {
      emit(TvShowError('Failed to load episodes: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(TvShowInitial());
  }
}
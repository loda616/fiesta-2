// lib/presentation/cubit/search_cubit.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/datasources/search_local_source.dart' show SearchLocalSource;
import '../../../domain/entities/movie.dart' show Movie;
import '../../../domain/usecases/search_use_case.dart' show SearchUseCase;

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase _searchUseCase;
  final SearchLocalSource _searchLocalSource;

  SearchCubit(this._searchUseCase, this._searchLocalSource)
      : super(SearchInitial());

  void resetState() {
    emit(SearchInitial());
  }

  List<String> getSearchHistory() {
    return _searchLocalSource.getSearchHistory();
  }

  Future<void> clearSearchHistory() async {
    await _searchLocalSource.clearSearchHistory();
    emit(SearchInitial());
  }

  Future<void> searchContent(
      String query, {
        String? contentType,
        String? genre,
        String? year,
        String? sortBy,
      }) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await _searchUseCase.execute(
      query,
      contentType: contentType,
    );

    result.fold(
          (failure) => emit(SearchError(failure.message)),
          (movies) {
        // Save search query to history
        _searchLocalSource.addSearchQuery(query);

        // Apply filters if provided
        var filteredMovies = movies;

        if (genre != null && genre != 'All') {
          filteredMovies = filteredMovies
              .where((movie) => movie.genre?.contains(genre) ?? false)
              .toList();
        }

        if (year != null && year != 'All') {
          filteredMovies = filteredMovies
              .where((movie) => movie.year == year)
              .toList();
        }

        // Apply sorting
        if (sortBy != null) {
          switch (sortBy) {
            case 'Rating':
              filteredMovies.sort((a, b) =>
                  (b.imdbRating ?? '0').compareTo(a.imdbRating ?? '0'));
              break;
            case 'Year':
              filteredMovies.sort((a, b) => b.year.compareTo(a.year));
              break;
            case 'Title':
              filteredMovies.sort((a, b) => a.title.compareTo(b.title));
              break;
          }
        }

        emit(SearchLoaded(filteredMovies));
      },
    );
  }
}
# Code Walkthrough for Key Features

## Introduction

This document provides a code-level exploration of the key features in the app, focusing on the Movie Details and Search functionality. We'll examine relevant code snippets and explain how they work together to create a seamless user experience.

## Movie Details Feature

### Fetching Movie Details

The process starts in the `MovieDetailsCubit`:

```dart
// movie_details_cubit.dart
Future<void> loadMovieDetails(String movieId) async {
  emit(MovieDetailsLoading());

  try {
    final movieResult = await getMovieDetails(movieId);

    movieResult.fold(
      (failure) => emit(MovieDetailsError(failure.message)),
      (movie) async {
        _currentMovie = movie;
        _isInWatchlist = movie.isInWatchlist;

        // Get recommendations
        final recommendationsResult = await getMovieRecommendations(
          movie.watchmodeId ?? movie.imdbId
        );

        recommendationsResult.fold(
          (failure) {
            // If recommendations fail, still show the movie
            emit(MovieDetailsLoaded(movie, [], _isInWatchlist));
          },
          (recommendations) {
            emit(MovieDetailsLoaded(movie, recommendations, _isInWatchlist));
          },
        );
      },
    );
  } catch (e) {
    emit(MovieDetailsError(e.toString()));
  }
}
```

This method:
1. Emits a loading state
2. Uses the `GetMovieDetailsUseCase` to fetch movie data
3. Handles success/failure with the `Either` type from Dartz
4. On success, also fetches movie recommendations
5. Finally emits a loaded state with complete data

### Repository Implementation

The `MovieRepositoryImpl` handles data retrieval and conversion:

```dart
// movie_repository_impl.dart
@override
Future<Either<Failure, Movie>> getMovieDetails(String movieId) async {
  try {
    // Determine if we're working with a Watchmode ID or IMDB ID
    String watchmodeId = movieId;

    // If the ID looks like an IMDB ID (starts with 'tt'), try to convert it
    if (movieId.startsWith('tt')) {
      final id = await apiSource.getWatchmodeIdFromImdbId(movieId);
      if (id != null) {
        watchmodeId = id;
      } else {
        return Left(ServerFailure('Movie not found'));
      }
    }

    // Fetch the movie details using the Watchmode ID
    final movie = await apiSource.getMovieDetails(watchmodeId);
    
    // Fetch streaming sources if available
    try {
      final sources = await apiSource.getTitleSources(watchmodeId);
      // Movie implementation handles attaching sources
    } catch (e) {
      // Continue without sources if they fail
      print('Failed to get streaming sources: $e');
    }

    return Right(movie);
  } catch (e) {
    return Left(ServerFailure('Failed to get movie details: ${e.toString()}'));
  }
}
```

This method:
1. Handles ID format conversion between IMDB and Watchmode formats
2. Calls the API source to fetch details
3. Also attempts to fetch streaming sources
4. Returns the result wrapped in an `Either` type
5. Properly handles and transforms errors

### UI Implementation

The UI in `movie_details_page.dart` uses BLoC pattern to respond to state changes:

```dart
// movie_details_page.dart
BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
  builder: (context, state) {
    if (state is MovieDetailsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MovieDetailsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Theme.of(context).colorScheme.error),
            SizedBox(height: 16.h),
            Text(state.message, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            TextButton(
              onPressed: () {
                context.read<MovieDetailsCubit>().loadMovieDetails(widget.movieId);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is MovieDetailsLoaded) {
      final movie = state.movie;
      // UI rendering for loaded state
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: /* Movie backdrop image */,
            ),
            actions: [
              IconButton(
                icon: Icon(state.isInWatchlist ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () {
                  context.read<MovieDetailsCubit>().toggleWatchlist();
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie information
                  // ...
                  
                  // Streaming services section
                  if (movie.streamingSources != null && movie.streamingSources!.isNotEmpty) ...[
                    SizedBox(height: 24.h),
                    StreamingSourcesSection(
                      streamingSources: movie.streamingSources,
                      onSeeAllPressed: () { /* Show all sources */ },
                    ),
                  ],
                  
                  // Movie recommendations
                  SizedBox(height: 24.h),
                  MovieRecommendations(
                    recommendations: state.recommendations,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  },
)
```

This builder:
1. Shows appropriate UI based on current state
2. Displays loading indicator while fetching data
3. Shows error message with retry option on failure
4. Renders complete movie details when loaded
5. Includes reusable components for specific sections

### Streaming Sources Component

The `StreamingSourcesSection` displays available streaming options:

```dart
// streaming_sources_section.dart
Widget _buildSourceItem(BuildContext context, StreamingSource source) {
  final theme = Theme.of(context);

  // Determine chip color based on source type
  Color chipColor;
  IconData iconData;
  switch (source.type) {
    case 'sub':
      chipColor = Colors.blue;
      iconData = Icons.subscriptions;
      break;
    case 'free':
      chipColor = Colors.green;
      iconData = Icons.money_off;
      break;
    // Other cases...
    default:
      chipColor = theme.colorScheme.primary;
      iconData = Icons.play_circle_outline;
  }

  return InkWell(
    onTap: () {
      if (source.webUrl.isNotEmpty) {
        // Launch URL to streaming service
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: chipColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 16.sp, color: chipColor),
          SizedBox(width: 6.w),
          Text(source.name, 
               style: TextStyle(/* Styling */)),
          if (source.price != null && source.price!.isNotEmpty) ...[
            SizedBox(width: 4.w),
            Text('(\$${source.price})', 
                 style: TextStyle(/* Styling */)),
          ],
        ],
      ),
    ),
  );
}
```

This component:
1. Creates visual chips for each streaming source
2. Color-codes by source type (subscription, free, rental)
3. Shows pricing information when available
4. Provides tap interaction to open streaming service
5. Uses responsive design with ScreenUtil

## Search Feature

### Search Tab Implementation

The `search_tab.dart` implements the UI for searching:

```dart
// search_tab.dart
class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _selectedGenre = 'All';
  String _selectedYear = 'All';
  String _sortBy = 'Rating';
  String? _contentType;
  
  // ...

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<SearchCubit>().searchContent(
          query,
          contentType: _contentType,
          genre: _selectedGenre == 'All' ? null : _selectedGenre,
          year: _selectedYear == 'All' ? null : _selectedYear,
          sortBy: _sortBy,
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Find Movies & Shows', style: /* Styling */),
              S
# Search Functionality Workflow

## Overview

The Search feature allows users to discover movies and TV shows through text queries, with additional filtering and sorting capabilities. The implementation follows clean architecture principles to maintain separation of concerns and testability.

## Component Flow

1. **UI Layer** (`search_tab.dart`)
   - Provides search input field with filtering options
   - Implements debouncing to prevent excessive API calls
   - Displays search results in a responsive grid
   - Shows search history when no active search
   - Handles user interactions and filter selections

2. **State Management** (`search_cubit.dart`)
   - Manages states: `SearchInitial`, `SearchLoading`, `SearchLoaded`, `SearchError`
   - Coordinates search execution and history tracking
   - Handles search filtering and sorting logic
   - Communicates with local storage for search history management

3. **Use Case** (`search_use_case.dart`)
   - Acts as intermediary between UI and data layers
   - Enforces business rules for search validation
   - Provides clean API for search operations
   - Handles error conversion with `Either<Failure, List<Movie>>`

4. **Repository Layer** (`search_repository_impl.dart`)
   - Implements repository interface from domain layer
   - Coordinates between remote and local data sources
   - Handles error conversion from network exceptions to domain failures
   - Transforms API models to domain entities

5. **Data Sources**
   - `watchmode_api_client.dart`: Communicates with Watchmode API
   - `search_local_source.dart`: Manages search history in local storage
   - Handles connection issues and API rate limiting

## Key Components

### `search_tab.dart`

Main UI component that:
- Uses Material's `SearchBar` for user input
- Provides `FilterChip` widgets for genre, year, content type, sorting
- Implements `debounce` to prevent excessive API calls during typing
- Displays search results in a responsive grid using `GridView.builder`
- Shows search history when no active search is performed
- Handles empty states and loading indicators

### `filter_dialogs.dart`

Utility component that:
- Provides modal dialogs for selecting filters
- Includes genre selection from predefined list
- Enables year selection (current year and previous 20 years)
- Offers sorting options (Rating, Year, Title)
- Maintains selection state across dialogs

### `responsive_movie_card.dart`

UI component for search results that:
- Displays movie poster with overlay information
- Shows title, year, rating, and type badge
- Adapts to different screen sizes
- Provides visual feedback on interaction
- Handles missing images gracefully

## Data Flow

1. User enters text in search field
2. Input is debounced (500ms delay)
3. `SearchCubit.searchContent()` is called with query and optional filters
4. Cubit emits `SearchLoading` state
5. Search query is added to local history via `SearchLocalSource`
6. Cubit calls `SearchUseCase.execute()` with query and filters
7. Use case validates the query and calls `SearchRepository.searchContent()`
8. Repository calls `WatchmodeApiClient.search()` with API parameters
9. API client makes HTTP request to Watchmode API
10. Response is parsed and transformed through the layers:
    - API client returns raw JSON response
    - Repository converts response to `List<MovieModel>`
    - Models are converted to domain entities (`List<Movie>`)
    - Use case wraps result in `Either<Failure, List<Movie>>`
    - Cubit processes result and applies additional filters/sorting
    - Cubit emits `SearchLoaded` state with filtered movies
11. UI rebuilds based on the new state, displaying results grid
12. If an error occurs at any point, `SearchError` state is emitted

## Search History Management

1. When a successful search completes, query is saved:
   - `SearchCubit` calls `SearchLocalSource.addSearchQuery()`
   - Query is stored in SharedPreferences with key `'search_history'`
   - Maximum of 10 historical queries are maintained (oldest removed first)

2. When search tab is empty:
   - `SearchCubit.getSearchHistory()` retrieves saved queries
   - UI displays list of historical searches
   - User can tap history item to repeat search
   - Clear button removes all history

## Filtering and Sorting

Applied in the `SearchCubit` after API results return:

```dart
// Filter by genre
if (genre != null && genre != 'All') {
  filteredMovies = filteredMovies
      .where((movie) => movie.genre?.contains(genre) ?? false)
      .toList();
}

// Filter by year
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
```

## Debounce Implementation

Prevents excessive API calls while typing:

```dart
Timer? _debounce;

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
```

## Error Handling

- Network errors from the API client are caught and converted to `ServerException`
- Repository layer converts exceptions to domain `Failure` objects
- Use case returns `Left<Failure>` for errors
- Cubit emits `SearchError` state with user-friendly message
- UI displays error view with retry option

## Content Type Filtering

Users can filter by:
- All content types (default)
- Movies only
- TV Shows only

This is implemented by passing the appropriate `types` parameter to the Watchmode API.

## Responsive Design

The search feature adapts to different screen sizes:
- Grid has 2 columns on phones, 3+ on tablets
- Filter chips scroll horizontally on small screens
- Card sizes adapt using Flutter's ScreenUtil
- Text scales appropriately for readability
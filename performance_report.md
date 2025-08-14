# Performance Report

This report provides an evaluation of the application's performance, identifies performance bottlenecks, and offers suggestions for improvement.

---

### Overall Performance Rating: 2/5 (Poor)

The application suffers from several significant performance issues that will lead to a slow and frustrating user experience. The most critical issue is the inefficient use of the Watchmode API, which will cause long loading times and may lead to the application being rate-limited.

---

### Performance Issues and Recommendations

#### 1. Inefficient API Usage (N+1 Query Problem)

- **Location**:
  - `lib/data/datasources/Watchmode/watchmode_api_source.dart` (in `searchMovies` and `getMovieRecommendations` methods)
- **Description**: The application makes an excessive number of API calls. For example, when searching for movies, it first makes a call to get a list of results, and then it makes a separate call for each result to get more details. This is known as the "N+1 query problem."
- **Impact**: This will make the search and recommendation features very slow. It will also consume the API rate limit quickly, which could lead to the application being blocked by the API provider.
- **Recommendation**:
  - **For `searchMovies`**: Instead of fetching details for each movie in the search results, only show the basic information provided by the search API. Then, only fetch the full details when the user selects a specific movie.
  - **For `getMovieRecommendations`**: Check the Watchmode API documentation to see if there is a way to fetch multiple titles by ID in a single call. If not, consider reducing the number of recommendations fetched or implementing a more sophisticated caching strategy.

#### 2. Client-Side Filtering and Sorting

- **Location**: `lib/presentation/cubit/movie_cubit.dart`
- **Description**: The `MovieCubit` fetches a list of movies from the API and then performs filtering and sorting on the client-side.
- **Impact**: This is inefficient, especially for large lists of movies. The application is downloading more data than necessary and using the device's CPU to perform operations that could be done more efficiently by the server.
- **Recommendation**: Check the Watchmode API documentation to see if it supports filtering and sorting parameters. If it does, pass the user's filter and sort preferences to the API and let the server do the work.

#### 3. Inefficient `onRefresh` Handler

- **Location**: `lib/presentation/home/tabs/home_tab.dart`
- **Description**: The `onRefresh` handler in the `HomeTab` triggers two separate data loading methods on the `MovieCubit`. Each of these methods emits a `MovieLoading` state, which can cause the UI to rebuild unnecessarily.
- **Impact**: This can lead to a flickering or janky UI when the user performs a pull-to-refresh action.
- **Recommendation**: Create a single method on the `MovieCubit` that loads all the data for the home screen (e.g., `loadHomeData`). This method should emit a single `MovieLoading` state and then a single `HomeDataLoaded` state containing all the data for the screen.

#### 4. Missing `Equatable` on State Classes

- **Location**: `lib/presentation/cubit/movie_cubit.dart` and other Cubit files.
- **Description**: The state classes (e.g., `MovieSearchLoaded`) do not extend the `Equatable` class.
- **Impact**: The BLoC library relies on the equality operator (`==`) to determine if the state has changed and if the UI should be rebuilt. Without `Equatable`, two different instances of a state class will not be considered equal, even if they have the same data. This can lead to unnecessary widget rebuilds and decreased performance.
- **Recommendation**: All state classes should extend the `Equatable` class and override the `props` getter to include all the properties of the class.

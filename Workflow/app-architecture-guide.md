# App Architecture Guide

## Overview

This Flutter application follows Clean Architecture principles, which divides the codebase into distinct layers with clear responsibilities. This architecture promotes maintainability, testability, and scalability while keeping dependencies flowing inward.

## Architectural Layers

### 1. Presentation Layer (UI)

**Purpose**: Handles UI rendering and user interactions.

**Key Components**:
- **Pages**: Full-screen UI components (e.g., `movie_details_page.dart`, `search_tab.dart`)
- **Widgets**: Reusable UI components (e.g., `movie_card.dart`, `streaming_sources_section.dart`)
- **BLoC/Cubit**: State management for UI components (e.g., `movie_details_cubit.dart`, `search_cubit.dart`)

**Responsibilities**:
- Display data to users
- Respond to user interactions
- Manage UI state through BLoC/Cubit pattern
- Route navigation

### 2. Domain Layer

**Purpose**: Contains business logic and rules independent of other layers.

**Key Components**:
- **Entities**: Core business objects (e.g., `movie.dart`, `user.dart`)
- **Use Cases**: Application-specific business rules (e.g., `get_movie_details_usecase.dart`)
- **Repository Interfaces**: Abstract definitions of data operations (e.g., `movie_repository.dart`)

**Responsibilities**:
- Define core business models with no dependencies on external frameworks
- Implement business logic in use cases
- Specify repository contracts without implementation details
- Convert domain failures using `Either<Failure, T>` pattern from Dartz

### 3. Data Layer

**Purpose**: Provides data from various sources to the domain layer.

**Key Components**:
- **Repository Implementations**: Concrete implementations of repository interfaces (e.g., `movie_repository_impl.dart`)
- **Data Sources**: Classes that retrieve data from specific sources (e.g., `watchmode_api_source.dart`, `search_local_source.dart`)
- **Models**: Data transfer objects for external data (e.g., `movie_model.dart`, `watchmode_models.dart`)

**Responsibilities**:
- Implement repository interfaces from domain layer
- Coordinate between different data sources
- Convert external data formats to domain entities
- Handle caching and persistence
- Manage network requests and responses

## Dependency Flow

Dependencies flow from outer layers to inner layers:
- **Presentation Layer** → depends on → **Domain Layer**
- **Data Layer** → depends on → **Domain Layer**

The Domain Layer has no dependencies on other layers, making it isolated and testable.

## State Management

The application uses the BLoC pattern (specifically Cubit) for state management:

- **Cubits**: Simplified BLoCs that manage state and expose methods to change state
- **States**: Immutable classes representing UI states
- **Events**: Implicitly handled by Cubit methods

Example state flow:
1. UI calls a method on Cubit
2. Cubit executes business logic using use cases
3. Cubit emits a new state based on the result
4. UI rebuilds based on the new state

## Dependency Injection

The application uses the Service Locator pattern (via `get_it` package) for dependency injection:

```dart
// Registering dependencies
final sl = GetIt.instance;

void init() {
  // Cubits
  sl.registerFactory(() => MovieDetailsCubit(
    getMovieDetails: sl(),
    getMovieRecommendations: sl(),
  ));
  
  // Use cases
  sl.registerLazySingleton(() => GetMovieDetailsUseCase(sl()));
  
  // Repositories
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(sl()));
  
  // Data sources
  sl.registerLazySingleton(() => WatchmodeApiSource(sl(), sl(), apiKey));
}
```

## Error Handling

The application implements comprehensive error handling:

1. **Data Layer**: Catches exceptions and converts them to specific exception types
2. **Repository Layer**: Transforms exceptions into domain-specific `Failure` objects
3. **Use Cases**: Return `Either<Failure, T>` to indicate success or failure
4. **Presentation Layer**: Handles failures and shows appropriate UI feedback

## Key Design Patterns

### Repository Pattern

Abstracts data sources behind a common interface:

```dart
// Domain layer - Repository interface
abstract class MovieRepository {
  Future<Either<Failure, Movie>> getMovieDetails(String id);
}

// Data layer - Repository implementation
class MovieRepositoryImpl implements MovieRepository {
  final WatchmodeApiSource apiSource;
  
  MovieRepositoryImpl(this.apiSource);
  
  @override
  Future<Either<Failure, Movie>> getMovieDetails(String id) async {
    try {
      final movie = await apiSource.getMovieDetails(id);
      return Right(movie);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

### Factory Pattern

Used for creating models from different data sources:

```dart
factory MovieModel.fromWatchmodeDetailJson(TitleDetailsResponse json) {
  // Transform API response to domain model
  return MovieModel(
    watchmodeId: json.id.toString(),
    imdbId: json.imdbId ?? '',
    title: json.title,
    // ...other properties
  );
}
```

### Observer Pattern

Implemented via BLoC pattern for reactive UI updates:

```dart
BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
  builder: (context, state) {
    if (state is MovieDetailsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is MovieDetailsLoaded) {
      return _buildMovieDetails(state.movie);
    } else if (state is MovieDetailsError) {
      return ErrorView(message: state.message);
    } else {
      return const SizedBox.shrink();
    }
  },
)
```

## Folder Structure

```
lib/
├── core/
│   ├── errors/
│   ├── theme/
│   ├── usecases/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── cubit/
│   ├── pages/
│   ├── widgets/
│   └── home/
└── main.dart
```

## Key Technologies and Libraries

- **Flutter**: UI framework
- **flutter_bloc**: State management
- **dartz**: Functional programming features (Either type)
- **get_it**: Dependency injection
- **retrofit**: Type-safe HTTP client
- **shared_preferences**: Local storage
- **firebase_auth**: Authentication
- **cloud_firestore**: Cloud database
- **flutter_screenutil**: Responsive design

## Testing Strategy

The clean architecture facilitates testing at each layer:

1. **Domain Layer Tests**: 
   - Test use cases and entities in isolation
   - Mock repositories using interfaces

2. **Data Layer Tests**:
   - Test repositories with mocked data sources
   - Test data sources with mocked HTTP clients

3. **Presentation Layer Tests**:
   - Test BLoCs/Cubits with mocked use cases
   - Widget tests for UI components

## Navigation

The app uses named routes for navigation, defined in a centralized router:

```dart
// Example route definition
static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/movie_details':
      final movieId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => MovieDetailsPage(movieId: movieId),
      );
    // Other routes...
    default:
      return MaterialPageRoute(
        builder: (_) => const NotFoundPage(),
      );
  }
}
```

## Theme Management

The app implements a theme system with light and dark modes:

- `ThemeProvider`: Manages current theme and persistence
- `AppTheme`: Defines theme data for different modes
- Persisted using `LocalStorage` to remember user preference

## Conclusion

This clean architecture approach offers several benefits:

- **Separation of concerns**: Each layer has distinct responsibilities
- **Testability**: Easy to test components in isolation
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: New features can be added without modifying existing code
- **Framework independence**: Core business logic doesn't depend on Flutter

By following these architectural principles, the application maintains a high level of code quality while enabling efficient development and future extensions.
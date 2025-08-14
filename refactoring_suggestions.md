# Refactoring Suggestions

This report outlines areas of the code that could be refactored to improve maintainability, clarity, and overall quality.

---

### 1. Consolidate Dependency Injection Setup

- **Location**: `lib/di/injection.dart` and `lib/core/injection_container.dart`
- **Suggestion**: There are two files for setting up dependency injection. The unused file (`lib/core/injection_container.dart`) should be deleted, and all dependency injection logic should be consolidated into `lib/di/injection.dart`. This will reduce confusion and make the DI setup easier to maintain.

---

### 2. Complete the Streaming Sources Feature

- **Location**: `lib/data/repositories/movie_repository_impl.dart`
- **Suggestion**: The feature to add streaming sources to the `Movie` object is incomplete. The code fetches the sources but does not attach them to the movie. This feature should be completed.

---

### 3. Replace Magic Strings with Constants or Enums

- **Location**:
  - `lib/data/repositories/movie_repository_impl.dart` (for the "tt" prefix)
  - `lib/presentation/cubit/movie_cubit.dart` (for commands like "popular", "watched", etc.)
- **Suggestion**: Replace hardcoded "magic strings" with named constants or enums. This will make the code more readable, less error-prone, and easier to maintain. For example, create a `const imdbIdPrefix = 'tt';` or an enum for the different movie list types.

---

### 4. Improve Accessibility

- **Location**: `lib/main.dart`
- **Suggestion**: The `textScaler` is currently fixed to `TextScaler.linear(1.0)`, which disables font scaling. This is a significant accessibility issue for users who rely on larger font sizes. Remove this line to allow users to control the font size through their device settings.

---

### 5. Enhance Error Handling

- **Location**: `lib/core/errors/error_handler.dart` and `lib/core/errors/failures.dart`
- **Suggestion**:
  - **Handle `ValidationFailure`**: Add a case for `ValidationFailure` in the `ErrorHandler.getMessage` method to provide a more specific error message to the user.
  - **Add `Equatable` to `Failure` classes**: The `Failure` classes should extend `Equatable` to make them easier to work with in tests.
  - **Improve Logging**: The `ErrorHandler` should log the original error object, not just the user-friendly message. This will make it easier for developers to debug issues.

---

### 6. Refactor Data Loading in `HomeTab`

- **Location**: `lib/presentation/home/tabs/home_tab.dart` and `lib/presentation/home/tabs/sections/popular_movies_section.dart`
- **Suggestion**: The data loading for the home screen is fragmented and inefficient.
  - **Centralize data loading**: Create a single method in the `MovieCubit` to load all the data for the home screen.
  - **Load data from the `HomeTab`**: Call this new method from the `HomeTab`'s `initState` (or a similar lifecycle method) to load the data for the entire screen at once. This will provide a better user experience than loading each section individually.

---

### 7. Use Keys in `GridView`

- **Location**: `lib/presentation/home/tabs/sections/popular_movies_section.dart`
- **Suggestion**: Add a `Key` to the `MovieCard` widgets in the `GridView`. This will help Flutter's rendering engine to identify and differentiate the widgets, which can improve performance and prevent unexpected behavior. A `ValueKey` with the movie's ID would be a good choice.

---

### 8. Consider a Code-Generation-Based Router

- **Suggestion**: For better maintainability and type safety, consider migrating from the manual routing implementation to a code-generation-based solution like `auto_route` or `go_router`. This is especially beneficial as the application grows in size and complexity.

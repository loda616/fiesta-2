# Flutter Movie App - Project Architecture and Workflows

## Project Overview

This is a movie and TV show discovery application built with Flutter, following a clean architecture approach. The app allows users to browse, search, and manage a watchlist of movies and TV shows, get details, and find streaming sources. The application uses Firebase for authentication and data storage, and integrates with the Watchmode API for movie and TV show data.

## Architecture

The project follows a clean architecture pattern with separation of concerns:

- **Domain Layer**: Contains business logic, entities, repositories interfaces, and use cases
- **Data Layer**: Implements repositories, manages data sources, and maps data to entities
- **Presentation Layer**: Handles UI, uses BLoC/Cubit pattern for state management
- **Core Layer**: Contains shared utilities, theme, routing, and error handling

## Dependency Injection

The app uses the GetIt package for dependency injection, configured in `injection_container.dart`. This allows for loose coupling between components and easier testing.

## Key Components

- **Authentication**: Firebase Authentication for user management
- **Storage**: Firestore for storing user data, watchlist, and ratings
- **API Integration**: Watchmode API for movie and TV show data
- **State Management**: BLoC/Cubit pattern with flutter_bloc
- **Responsive Design**: Using flutter_screenutil for responsive UI
- **Theme**: Supports light and dark themes
- **Navigation**: Using named routes for navigation between screens

## Workflows

Let's break down the key workflows in the application:

### 1. Authentication Workflow

The authentication flow handles user sign-up, login, and session management.

```
User → Sign Up/Login → Firebase Auth → User Account Creation/Verification → Home Screen
```

**Key Components:**
- `AuthCubit` manages authentication state
- `AuthRepository` interfaces with Firebase
- Login and Registration screens
- Profile management

### 2. Movie Discovery Workflow

This workflow allows users to discover movies through search, browsing popular titles, or recommendations.

```
User → Search/Browse → API Request → Display Results → Select Movie → View Details
```

**Key Components:**
- `MovieCubit` manages movie listings and search
- `WatchmodeApiSource` interfaces with the Watchmode API
- Search screen with filters
- Movie grid and list views

### 3. TV Show Exploration Workflow

Similar to movies, this workflow enables browsing and viewing TV shows with their seasons and episodes.

```
User → Browse Shows → Select Show → View Seasons → Select Season → View Episodes → Episode Details
```

**Key Components:**
- `TvShowCubit` manages TV show data
- Season listing
- Episode details
- Streaming information

### 4. Watchlist Management Workflow

This workflow allows users to maintain a personal watchlist of content they want to watch or have watched.

```
User → Browse Content → Add to Watchlist → View Watchlist → Mark as Watched/Remove
```

**Key Components:**
- `WatchlistRepository` interfaces with Firestore
- Watchlist tab in the bottom navigation
- Watched/Unwatched filtering

### 5. Movie Details Workflow

This workflow shows detailed information about a selected movie or TV show.

```
User → Select Content → View Details → View Recommendations → Find Streaming Sources
```

**Key Components:**
- `MovieDetailsCubit` manages detailed content information
- Movie/Show details screen
- Recommendations section
- Streaming sources section

### 6. Theme Management Workflow

This workflow allows users to switch between light and dark themes.

```
User → Profile → Toggle Theme → Theme Provider → Update UI
```

**Key Components:**
- `ThemeProvider` manages theme state
- `AppTheme` defines theme data
- Theme toggle in profile screen

## Data Flow

1. **API Data Flow**: App → Repository → API Source → External API → Response → Mapping → Entities → UI
2. **Local Data Flow**: App → Repository → Local Source → SharedPreferences/SQLite → Data → Mapping → Entities → UI
3. **Auth Data Flow**: App → Auth Repository → Firebase Auth → Response → User Entity → UI

## Error Handling

The app implements a robust error handling mechanism:
- `Failure` abstract class with specific implementations
- `ErrorHandler` utility for displaying user-friendly error messages
- Error states in Cubits for graceful UI feedback

## Responsive Design

The app uses:
- `flutter_screenutil` for responsive sizing
- Flexible layouts that adapt to different screen sizes
- Adaptive UI components

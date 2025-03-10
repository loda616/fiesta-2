// lib/di/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import '../data/datasources/Watchmode/watchmode_api_client.dart';
import '../data/datasources/Watchmode/watchmode_api_source.dart';
import '../data/datasources/Watchmode/rate_limiter.dart';
import '../data/datasources/search_local_source.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/search_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/search_epository.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/get_movie_details_usecase.dart';
import '../domain/usecases/get_movie_recommendations_usecase.dart';
import '../domain/usecases/get_movies_usecase.dart';
import '../domain/usecases/search_use_case.dart' show SearchUseCase;
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../presentation/cubit/Search/search_cubit.dart' show SearchCubit;
import '../presentation/cubit/auth_cubit.dart';
import '../presentation/cubit/movie_cubit.dart';
import '../presentation/cubit/tv_show_cubit.dart';
import '../presentation/cubit/movie_details_cubit.dart';
import '../core/storage/local_storage.dart';
import '../core/theme/theme_provider.dart';

// Global ServiceLocator
final sl = GetIt.instance;

Future<void> init() async {
  try {
    // External - Third party libraries and services
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(sharedPreferences);
    sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
    sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
    sl.registerSingleton<Dio>(Dio());

    // Core
    sl.registerSingleton<LocalStorage>(LocalStorage(sl<SharedPreferences>()));
    sl.registerSingleton<SearchLocalSource>(SearchLocalSource(sl<SharedPreferences>()));
    sl.registerSingleton<RateLimiter>(RateLimiter());

    // API Client
    sl.registerSingleton<WatchmodeApiClient>(WatchmodeApiClient(sl<Dio>()));
    sl.registerSingleton<WatchmodeApiSource>(
      WatchmodeApiSource(
        sl<WatchmodeApiClient>(),
        sl<RateLimiter>(),
        'wkxtBi0HBskrGYnR4GYbwFhExYY9EyoeZmF36FSO',
      ),
    );

    // Repositories
    sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(
        firebaseAuth: sl<FirebaseAuth>(),
        firestore: sl<FirebaseFirestore>(),
      ),
    );

    sl.registerSingleton<MovieRepository>(
      MovieRepositoryImpl(sl<WatchmodeApiSource>()),
    );

    sl.registerSingleton<SearchRepository>(
      SearchRepositoryImpl(
        sl<WatchmodeApiClient>(),
        sl<RateLimiter>(),
        'wkxtBi0HBskrGYnR4GYbwFhExYY9EyoeZmF36FSO',
      ),
    );

    // Use Cases
    sl.registerSingleton<SignInUseCase>(SignInUseCase(sl<AuthRepository>()));
    sl.registerSingleton<SignUpUseCase>(SignUpUseCase(sl<AuthRepository>()));
    sl.registerSingleton<SignOutUseCase>(SignOutUseCase(sl<AuthRepository>()));
    sl.registerSingleton<GetCurrentUserUseCase>(GetCurrentUserUseCase(sl<AuthRepository>()));
    sl.registerSingleton<GetMoviesUseCase>(GetMoviesUseCase(sl<MovieRepository>()));
    sl.registerSingleton<GetMovieDetailsUseCase>(GetMovieDetailsUseCase(sl<MovieRepository>()));
    sl.registerSingleton<GetMovieRecommendationsUseCase>(GetMovieRecommendationsUseCase(sl<MovieRepository>()));
    sl.registerSingleton<SearchUseCase>(SearchUseCase(sl<SearchRepository>()));

    // Providers/Cubits
    sl.registerSingleton<ThemeProvider>(ThemeProvider(sl<LocalStorage>()));

    sl.registerFactory<AuthCubit>(
          () => AuthCubit(
        signInUseCase: sl<SignInUseCase>(),
        signUpUseCase: sl<SignUpUseCase>(),
        signOutUseCase: sl<SignOutUseCase>(),
        getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
      ),
    );

    sl.registerFactory<MovieCubit>(
          () => MovieCubit(
        getMovies: sl<GetMoviesUseCase>(),
      ),
    );

    sl.registerFactory<TvShowCubit>(
          () => TvShowCubit(
        watchmodeApiSource: sl<WatchmodeApiSource>(),
      ),
    );

    sl.registerFactory<MovieDetailsCubit>(
          () => MovieDetailsCubit(
        getMovieDetails: sl<GetMovieDetailsUseCase>(),
        getMovieRecommendations: sl<GetMovieRecommendationsUseCase>(),
      ),
    );

    sl.registerFactory<SearchCubit>(
          () => SearchCubit(
        sl<SearchUseCase>(),
        sl<SearchLocalSource>(),
      ),
    );

    print('All dependencies registered successfully');
  } catch (e, stackTrace) {
    print('Error during dependency registration: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}
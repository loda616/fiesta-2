// lib/di/injection_container.dart

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    sl.registerLazySingleton<Dio>(() => Dio());

    // Core
    sl.registerLazySingleton<LocalStorage>(() => LocalStorage(sl<SharedPreferences>()));
    sl.registerLazySingleton<SearchLocalSource>(() => SearchLocalSource(sl<SharedPreferences>()));
    sl.registerLazySingleton<RateLimiter>(() => RateLimiter());

    // API Client
    sl.registerLazySingleton<WatchmodeApiClient>(() => WatchmodeApiClient(sl<Dio>()));
    sl.registerLazySingleton<WatchmodeApiSource>(
      () => WatchmodeApiSource(
        sl<WatchmodeApiClient>(),
        sl<RateLimiter>(),
        dotenv.env['API_KEY']!,
      ),
    );

    // Repositories
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        firebaseAuth: sl<FirebaseAuth>(),
        firestore: sl<FirebaseFirestore>(),
      ),
    );

    sl.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(sl<WatchmodeApiSource>()),
    );

    sl.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(
        sl<WatchmodeApiClient>(),
        sl<RateLimiter>(),
        dotenv.env['API_KEY']!,
      ),
    );

    // Use Cases
    sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase(sl<AuthRepository>()));
    sl.registerLazySingleton<GetMoviesUseCase>(() => GetMoviesUseCase(sl<MovieRepository>()));
    sl.registerLazySingleton<GetMovieDetailsUseCase>(() => GetMovieDetailsUseCase(sl<MovieRepository>()));
    sl.registerLazySingleton<GetMovieRecommendationsUseCase>(() => GetMovieRecommendationsUseCase(sl<MovieRepository>()));
    sl.registerLazySingleton<SearchUseCase>(() => SearchUseCase(sl<SearchRepository>()));

    // Providers/Cubits
    sl.registerLazySingleton<ThemeProvider>(() => ThemeProvider(sl<LocalStorage>()));

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
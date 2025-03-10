import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import '../core/theme/theme_provider.dart';
import '../core/storage/local_storage.dart';
import '../data/datasources/Watchmode/watchmode_api_client.dart';
import '../data/datasources/Watchmode/watchmode_api_source.dart';
import '../data/datasources/Watchmode/rate_limiter.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/get_movie_details_usecase.dart';
import '../domain/usecases/get_movie_recommendations_usecase.dart';
import '../domain/usecases/get_movies_usecase.dart';
import '../domain/usecases/sign_in_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';
import '../presentation/cubit/auth_cubit.dart';
import '../presentation/cubit/movie_cubit.dart';
import '../presentation/cubit/movie_details_cubit.dart';
import '../presentation/cubit/tv_show_cubit.dart';
import '../data/datasources/search_local_source.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // Core
  getIt.registerSingleton<LocalStorage>(LocalStorage(getIt<SharedPreferences>()));
  getIt.registerSingleton<ThemeProvider>(ThemeProvider(getIt<LocalStorage>()));
  getIt.registerSingleton<SearchLocalSource>(SearchLocalSource(getIt<SharedPreferences>()));

  // API dependencies
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<WatchmodeApiClient>(WatchmodeApiClient(getIt<Dio>()));
  getIt.registerSingleton<RateLimiter>(RateLimiter());

  // The Watchmode API key as a string
  const watchmodeApiKey = 'wkxtBi0HBskrGYnR4GYbwFhExYY9EyoeZmF36FSO';

  // Data sources
  getIt.registerSingleton<WatchmodeApiSource>(
      WatchmodeApiSource(getIt<WatchmodeApiClient>(), getIt<RateLimiter>(), watchmodeApiKey)
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(firebaseAuth: getIt<FirebaseAuth>(), firestore: getIt<FirebaseFirestore>())
  );

  getIt.registerSingleton<MovieRepository>(
      MovieRepositoryImpl(getIt<WatchmodeApiSource>())
  );

  // Use cases
  getIt.registerSingleton(SignInUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton(SignUpUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton(SignOutUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton(GetCurrentUserUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton(GetMoviesUseCase(getIt<MovieRepository>()));
  getIt.registerSingleton(GetMovieRecommendationsUseCase(getIt<MovieRepository>()));
  getIt.registerSingleton(GetMovieDetailsUseCase(getIt<MovieRepository>()));

  // Cubits
  getIt.registerFactory(() => AuthCubit(
    signInUseCase: getIt<SignInUseCase>(),
    signUpUseCase: getIt<SignUpUseCase>(),
    signOutUseCase: getIt<SignOutUseCase>(),
    getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
  ));

  getIt.registerFactory(() => MovieCubit(
    getMovies: getIt<GetMoviesUseCase>(),
  ));

  getIt.registerFactory(() => MovieDetailsCubit(
    getMovieDetails: getIt<GetMovieDetailsUseCase>(),
    getMovieRecommendations: getIt<GetMovieRecommendationsUseCase>(),
  ));

  getIt.registerFactory(() => TvShowCubit(
    watchmodeApiSource: getIt<WatchmodeApiSource>(),
  ));
}
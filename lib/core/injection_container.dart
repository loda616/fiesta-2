import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/datasources/movie_api_source.dart';
import '../data/datasources/search_local_source.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/get_current_user_usecase.dart' show GetCurrentUserUseCase;
import '../domain/usecases/get_movie_details_usecase.dart' show GetMovieDetailsUseCase;
import '../domain/usecases/get_movie_recommendations_usecase.dart' show GetMovieRecommendationsUseCase;
import '../domain/usecases/get_movies_usecase.dart';
import '../domain/usecases/sign_in_usecase.dart' show SignInUseCase;
import '../domain/usecases/sign_out_usecase.dart' show SignOutUseCase;
import '../domain/usecases/sign_up_usecase.dart' show SignUpUseCase;
import '../presentation/cubit/auth_cubit.dart';
import '../presentation/cubit/movie_cubit.dart';
import 'storage/local_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
        () => AuthCubit(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => MovieCubit(
      getMovies: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GetMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieRecommendationsUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieDetailsUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );

  sl.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => MovieApiSource());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Core
  sl.registerLazySingleton(() => LocalStorage(sl()));
  sl.registerLazySingleton(() => SearchLocalSource(sl()));
}
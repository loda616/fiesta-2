import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Core imports
import 'core/theme/theme_provider.dart';
import 'core/routes/app_router.dart';
import 'core/storage/local_storage.dart';

// Data layer imports
import 'data/datasources/movie_api_source.dart';
import 'data/datasources/search_local_source.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';

// Domain layer imports
import 'domain/usecases/sign_in_usecase.dart' show SignInUseCase;
import 'domain/usecases/sign_out_usecase.dart' show SignOutUseCase;
import 'domain/usecases/sign_up_usecase.dart' show SignUpUseCase;
import 'domain/usecases/get_current_user_usecase.dart' show GetCurrentUserUseCase;
import 'domain/usecases/get_movies_usecase.dart';

// Presentation layer imports
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/movie_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final localStorage = LocalStorage(prefs);
  final searchLocalSource = SearchLocalSource(prefs);

  // Initialize API source
  final movieApiSource = MovieApiSource();

  // Initialize Repository
  final movieRepository = MovieRepositoryImpl(movieApiSource);
  final authRepository = AuthRepositoryImpl(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );

  // Initialize Use Cases
  final getMoviesUseCase = GetMoviesUseCase(movieRepository);
  final signInUseCase = SignInUseCase(authRepository);
  final signUpUseCase = SignUpUseCase(authRepository);
  final signOutUseCase = SignOutUseCase(authRepository);
  final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);

  runApp(MyApp(
    localStorage: localStorage,
    searchLocalSource: searchLocalSource,
    getMoviesUseCase: getMoviesUseCase,
    signInUseCase: signInUseCase,
    signUpUseCase: signUpUseCase,
    signOutUseCase: signOutUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;
  final SearchLocalSource searchLocalSource;
  final GetMoviesUseCase getMoviesUseCase;
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  const MyApp({
    super.key,
    required this.localStorage,
    required this.searchLocalSource,
    required this.getMoviesUseCase,
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design size based on iPhone X
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ThemeProvider(localStorage),
            ),
            Provider<SearchLocalSource>.value(
              value: searchLocalSource,
            ),
            BlocProvider(
              create: (_) => MovieCubit(
                getMovies: getMoviesUseCase,
              ),
            ),
            BlocProvider(
              create: (_) => AuthCubit(
                signInUseCase: signInUseCase,
                signUpUseCase: signUpUseCase,
                signOutUseCase: signOutUseCase,
                getCurrentUserUseCase: getCurrentUserUseCase,
              ),
            ),
          ],
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'WatchList',
                debugShowCheckedModeBanner: false,
                theme: themeProvider.getTheme(context),
                initialRoute: AppRouter.splash,
                onGenerateRoute: AppRouter.onGenerateRoute,
                builder: (context, widget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
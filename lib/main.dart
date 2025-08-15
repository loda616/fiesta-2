// lib/main.dart
import 'package:fiesta/presentation/cubit/Search/search_cubit.dart' show SearchCubit;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Core imports
import 'di/injection.dart' show init, sl;
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/routes/app_router.dart';
import 'di/injection.dart' show init;

// Presentation layer imports
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/movie_cubit.dart';
import 'presentation/cubit/movie_details_cubit.dart';
import 'presentation/cubit/tv_show_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Load environment variables
    await dotenv.load(fileName: "env.txt");

    // Initialize dependency injection
    await init();

    runApp(const MyApp());
  } catch (e) {
    print('Error initializing app: $e');
    // Could show a custom error screen here
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: sl<ThemeProvider>(),
              ),
              BlocProvider<AuthCubit>(
                create: (_) => sl<AuthCubit>(),
              ),
              BlocProvider<MovieCubit>(
                create: (_) => sl<MovieCubit>(),
              ),
              BlocProvider<MovieDetailsCubit>(
                create: (_) => sl<MovieDetailsCubit>(),
              ),
              BlocProvider<TvShowCubit>(
                create: (_) => sl<TvShowCubit>(),
              ),
              BlocProvider<SearchCubit>(
                create: (_) => sl<SearchCubit>(),
              ),
            ],
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  title: 'WatchList',
                  debugShowCheckedModeBanner: false,
                  theme: themeProvider.getTheme(context),
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  initialRoute: AppRouter.splash,
                  onGenerateRoute: AppRouter.onGenerateRoute,
                );
              },
            ),
          );
        },
      );
    } catch (e, stackTrace) {
      print('Error building app: $e');
      print('Stack trace: $stackTrace');
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $e'),
          ),
        ),
      );
    }
  }
}
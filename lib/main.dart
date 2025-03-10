import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Core imports
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/routes/app_router.dart';
import 'di/injection.dart';

// Presentation layer imports
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/movie_cubit.dart';
import 'presentation/cubit/movie_details_cubit.dart';
import 'presentation/cubit/tv_show_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize dependency injection
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => getIt<ThemeProvider>(),
            ),
            BlocProvider(
              create: (_) => getIt<MovieCubit>(),
            ),
            BlocProvider(
              create: (_) => getIt<MovieDetailsCubit>(),
            ),
            BlocProvider(
              create: (_) => getIt<TvShowCubit>(),
            ),
            BlocProvider(
              create: (_) => getIt<AuthCubit>(),
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
                builder: (context, widget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
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
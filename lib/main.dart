import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;
import 'package:provider/provider.dart';

import 'core/injection_container.dart' as di;
import 'core/injection_container.dart';
import 'core/routes/app_router.dart';
import 'core/storage/local_storage.dart';
import 'core/theme/theme_provider.dart';
import 'data/datasources/search_local_source.dart';
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/movie_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
              create: (_) => ThemeProvider(sl<LocalStorage>()),
            ),
            Provider<SearchLocalSource>.value(
              value: sl<SearchLocalSource>(),
            ),
            BlocProvider(
              create: (_) => sl<MovieCubit>(),
            ),
            BlocProvider(
              create: (_) => sl<AuthCubit>(),
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
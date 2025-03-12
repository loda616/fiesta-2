// Update lib/core/routes/app_router.dart

import 'package:flutter/material.dart';
import '../../presentation/home/home_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/register_page.dart';
import '../../presentation/pages/splash_screen.dart';
import '../../presentation/pages/movie_details_page.dart'; // Add this import

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String movieDetails = '/movie_details'; // Add this route

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case movieDetails:
      // Extract the movie ID from arguments
        final movieId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => MovieDetailsPage(movieId: movieId));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
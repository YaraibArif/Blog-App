import 'package:blog_app/screens/onboarding_screen.dart';
import 'package:blog_app/screens/splash_screen.dart';
import 'package:blog_app/screens/splash_screen_stories.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";

import 'providers/auth_provider.dart';
import 'providers/posts_provider.dart';
import 'providers/quotes_provider.dart';

import 'screens/login_screen.dart';
import 'screens/posts_screen.dart';
import 'screens/quotes_screen.dart';
import 'screens/otp_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostsProvider()),
        ChangeNotifierProvider(create: (_) => QuotesProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blog App',

        home: SplashScreen(),

        routes: {
          '/login': (_) => const LoginScreen(),
          '/splash2': (_) => const StoriesSplashScreen(),
          '/posts': (_) => const PostsScreen(),
          '/quotes': (_) => const QuotesScreen(),
        },

        onGenerateRoute: (settings) {
          if (settings.name == '/otp') {
            final user = settings.arguments;
            return MaterialPageRoute(
              builder: (context) => const OtpScreen(),
              settings: settings,
            );
          }
          return null;
        },
      ),
    );
  }
}

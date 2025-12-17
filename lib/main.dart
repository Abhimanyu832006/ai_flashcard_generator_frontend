import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';

import 'providers/flashcard_provider.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLoggedIn = await AuthService.isLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlashcardProvider()),
      ],
      child: FlashcardAIApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class FlashcardAIApp extends StatelessWidget {
  final bool isLoggedIn;

  const FlashcardAIApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Flashcard AI',

  themeMode: ThemeMode.system, // 👈 IMPORTANT

  theme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
  ),

  darkTheme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
  ),

  home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
);

  }
}

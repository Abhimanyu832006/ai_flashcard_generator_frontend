import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/flashcard_provider.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FlashcardProvider())],
      child: const FlashcardAIApp(),
    ),
  );
}

class FlashcardAIApp extends StatelessWidget {
  const FlashcardAIApp({super.key});

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

  home: const HomeScreen(),
);

  }
}

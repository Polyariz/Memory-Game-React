import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/game_screen.dart';
import 'services/game_state.dart';

// Supabase credentials - замените на ваши настоящие
const supabaseUrl = 'https://pwaqksaemuprrnkmmhav.supabase.co';
const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY'; // Замените на ваш ключ

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: 'Memory Game',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7FBFFF),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF242424),
          fontFamily: 'Inter',
        ),
        home: const GameScreen(),
      ),
    );
  }
}

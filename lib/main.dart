import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/screens/todo_screen.dart';
import 'package:todo_app/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Read saved theme before the first frame is built.
  final isDarkMode = await ThemeService.isDarkMode();

  runApp(TodoApp(isDarkMode: isDarkMode));
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  /// Toggle theme in memory and persist the choice with SharedPreferences.
  Future<void> _toggleTheme() async {
    setState(() => _isDarkMode = !_isDarkMode);
    await ThemeService.setDarkMode(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Todo App',
      debugShowCheckedModeBanner: false,
      // MaterialApp switches between lightTheme and darkTheme automatically.
      theme: ThemeService.lightTheme,
      darkTheme: ThemeService.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TodoList(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

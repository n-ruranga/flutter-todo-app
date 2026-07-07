import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_app/screens/todo_screen.dart';

void main() {
  testWidgets('Todo screen shows title and theme toggle', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TodoList(
          isDarkMode: false,
          onToggleTheme: () {},
        ),
      ),
    );

    expect(find.text('Firestore Todo App'), findsOneWidget);
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'ui/screens/main_layout_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wise Care',
      theme: AppTheme.lightTheme,
      home: const MainLayoutScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

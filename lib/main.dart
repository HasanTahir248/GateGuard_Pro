import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/visitors/views/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: VisitorManagementApp()));
}

class VisitorManagementApp extends StatelessWidget {
  const VisitorManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Visitor System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData( /* Your theme data here */ ),
      home: const HomeScreen(),
    );
  }
}
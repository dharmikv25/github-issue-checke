import 'package:flutter/material.dart';
import 'package:githubproject/viewmodel/provider.dart';
import 'package:githubproject/view/homescreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => IProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}

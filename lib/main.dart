
import 'package:calculatorapp/splash_screen.dart/splash.dart';
import 'package:calculatorapp/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => ThemeNotifer(),
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeNotifer>(context);
    return MaterialApp(
        theme: themeProvider.currentTheme,
        debugShowCheckedModeBanner: false,
        title: 'Calculator',
        home: SplashScreen());
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

import 'package:grad_project/screens/pages/splashScreen.dart';
import 'package:grad_project/core/providers/themeProvider.dart';

var kColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color.fromARGB(255, 175, 172, 237),
  primary: const Color.fromARGB(255, 175, 172, 237),
  secondary: Colors.black,
  tertiary: const Color.fromARGB(255, 184, 184, 193),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 0, 0, 100),
  primary: const Color.fromARGB(255, 0, 0, 100),
  secondary: Colors.white,
  tertiary: const Color.fromARGB(255, 82, 82, 165),
);

final lightTheme = ThemeData().copyWith(
  brightness: Brightness.light,
  colorScheme: kColorScheme,
  textTheme: ThemeData().textTheme.copyWith(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: kColorScheme.onSecondaryContainer,
    ),
    bodyLarge: TextStyle(
      color: kColorScheme.secondary,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: kColorScheme.onSecondaryContainer),
  ),
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kColorScheme.primaryContainer,
    foregroundColor: kColorScheme.onPrimaryContainer,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorScheme.primaryContainer,
      foregroundColor: kColorScheme.onPrimaryContainer,
    ),
  ),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: kDarkColorScheme,
  textTheme: ThemeData().textTheme.copyWith(
    titleLarge: TextStyle(
      fontWeight: FontWeight.bold,
      color: kDarkColorScheme.secondary,
    ),
    bodyLarge: TextStyle(
      color: kDarkColorScheme.secondary,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(color: kDarkColorScheme.secondary),
  ),
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kDarkColorScheme.primaryContainer,
    foregroundColor: kDarkColorScheme.onPrimaryContainer,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kDarkColorScheme.primaryContainer,
      foregroundColor: kDarkColorScheme.onPrimaryContainer,
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: SplashScreen(),
    );
  }
}

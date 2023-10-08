import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:sotn_map/models/user-preferences.dart';
import 'package:sotn_map/screens/home-screen.dart';
import 'package:sotn_map/theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await Window.setEffect(effect: WindowEffect.acrylic);

  final userPrefs = UserPreferences();
  await userPrefs.load();

  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow(
    WindowOptions(
      size: Size(userPrefs.screenWidth, userPrefs.screenHeight),
      center: true,
      fullScreen: false,
    ),
    () async {
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runApp(MyApp(userPrefs: userPrefs));
}

class MyApp extends StatelessWidget {
  final UserPreferences userPrefs;

  const MyApp({required this.userPrefs, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: HomeScreen(userPrefs: userPrefs),
    );
  }
}
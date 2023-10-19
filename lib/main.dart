import 'package:chat/Pages/AccountSettingsPage.dart';
import 'package:chat/Pages/HomePage.dart';
import 'package:chat/splash/splash_Scree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Pages/LoginPage.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Himo Chat',
      initialRoute: '/',
      routes: {
        '/' : (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(currentUserId: ""),
        '/setting': (context) => const AccountSettings(),
      },
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

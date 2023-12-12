import 'package:chat/Pages/HomePage.dart';
import 'package:chat/Pages/LoginPage.dart';
import 'package:chat/util/colors.dart';
import 'package:chat/utility/asset_path.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  SharedPreferences? preferences;

  @override
  void initState() {
    redirect();
    super.initState();
  }

  redirect() async {
    preferences = await SharedPreferences.getInstance();
    bool isLoggedIn = await googleSignIn.isSignedIn();
    String? googleId = preferences!.getString("googleId");

    Future.delayed(const Duration(seconds: 3)).then((value) {
      if(isLoggedIn) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: googleId)));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AssetPath().logo, fit: BoxFit.fill),
            const SizedBox(height: 10),
            const Text(
              "Himo Chat",
              style: TextStyle(fontSize: 60.0, color: appTheme, fontFamily: "Signatra"),
            ),
          ],
        ),
      ),
    );
  }
}

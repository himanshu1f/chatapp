import 'package:chat/util/colors.dart';
import 'package:chat/utility/asset_path.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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

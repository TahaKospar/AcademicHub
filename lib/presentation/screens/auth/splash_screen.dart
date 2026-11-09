import 'package:academichub/constants/strings/strings.dart';
import 'package:academichub/presentation/theme/task_status_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(Duration(seconds: 3));
    final pref = await SharedPreferences.getInstance();
    bool isFirstTime = pref.getBool('isFirstTime') ?? true;
    if (!mounted) return;
    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, welcomeScreen);
    } else {
      if (!mounted) return;
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, mainScreen);
      } else {
        Navigator.pushReplacementNamed(context, authScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.adaptiveColor(
        light: Colors.white,
        dark: colors.surfaceDim,
      ),
      body: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo.png"),
              Image.asset("assets/loading.gif"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Academic",
                    style: TextStyle(
                      color: colors.adaptiveColor(
                        light: Colors.black,
                        dark: colors.onSurface,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Hub",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Text(
                "Your Campus Journey In One Place",
                style: TextStyle(
                  color: colors.adaptiveColor(
                    light: Colors.black,
                    dark: colors.onSurface,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

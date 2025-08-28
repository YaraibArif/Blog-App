import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/loader.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo ya image
            Image.asset(
              "assets/images/blog_pic_1.png",
              height: 300,
            ),
            SizedBox(height: 20),
            Text(
              "Blog App",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            SizedBox(height: 50),

        // 👇 Linear loader
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            backgroundColor: Colors.grey[800],
            color: Colors.white,
            minHeight: 5, // thickness
          ),
        ),
          ],
        ),
      ),
    );
  }
}

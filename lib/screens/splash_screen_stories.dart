import 'package:flutter/material.dart';
import 'dart:async';
import '../models/user.dart';

class StoriesSplashScreen extends StatefulWidget {
  const StoriesSplashScreen({super.key});

  @override
  State<StoriesSplashScreen> createState() => _StoriesSplashScreenState();
}

class _StoriesSplashScreenState extends State<StoriesSplashScreen> {
  User? user;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/posts', arguments: user);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Login/OTP
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is User) {
      user = args;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.menu_book_sharp,
                  color: Colors.black,
                  size: 40,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Daily Stories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Your daily stories at a glance",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 40),

              // To show user name
              if (user != null) ...[
                Text(
                  user!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "@${user!.username}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],

              const SizedBox(height: 80),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/posts', arguments: user);
                },
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

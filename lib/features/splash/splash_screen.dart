import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nflzoneofficial/features/authentication/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    // Always navigate to LoginScreen after 5 seconds
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nfl_logo-Photoroom.png',
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.sports_football,
                size: 150,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'NFL OFFICIAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Color(0xFFD50A0A),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

import '../authentication/login.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  final bool isAuthenticated;

  SplashScreen({required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000, // Specify the duration of the animation
      splash: Lottie.asset('assets/event.json'), // Your animation goes here
      splashIconSize: 200, // Adjust the size of the animation
      nextScreen: isAuthenticated != null && isAuthenticated ? HomeScreen() : LoginForm(),
      splashTransition: SplashTransition.slideTransition, // Choose the transition type
      backgroundColor: Colors.white, // Specify the background color
      centered: true, // Center the splash widget
      // splashFit: BoxFit.cover, // Fit the splash widget to cover the screen
      // splashAnimationCurve: Curves.easeInOut, // Set animation curve
      // splashAnimationDuration: Duration(milliseconds: 1500), // Set animation duration

    );
  }
}

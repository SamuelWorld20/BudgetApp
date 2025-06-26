// lib/splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async'; // Required for Timer
import 'package:budgetapp/home_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for fading effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Fade in duration
    );

    // Define the animation curve
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn, // Smooth acceleration
    );

    // Start the animation
    _controller.forward();

    // Navigate to the main app after a delay
    Timer(const Duration(seconds: 3), () { // 3 seconds total splash screen duration
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800), // Transition duration to main app
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Matching the gradient background of the main app
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: FadeTransition( // Apply fade transition to the entire content
          opacity: _animation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon (using a simple money icon for now, you can replace with an actual logo)
                Icon(
                  Icons.account_balance_wallet,
                  size: 120, // Large icon size
                  color: Colors.white.withOpacity(0.9), // Slightly transparent white
                  shadows: const [
                    Shadow(
                      offset: Offset(3.0, 3.0),
                      blurRadius: 6.0,
                      color: Color.fromARGB(100, 0, 0, 0),
                    ),
                  ],
                ),
                const SizedBox(height: 25), // Spacing below icon
                // App Title
                const Text(
                  'Student Budget',
                  style: TextStyle(
                    fontFamily: 'Inter', // Ensure this font is available or use a system font
                    fontSize: 48,
                    fontWeight: FontWeight.w900, // Extra bold
                    color: Colors.white,
                    letterSpacing: 2.0, // Spacing between letters
                    shadows: [
                      Shadow(
                        offset: Offset(4.0, 4.0),
                        blurRadius: 8.0,
                        color: Color.fromARGB(150, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10), // Spacing below title
                // Tagline (optional)
                const Text(
                  'Manage your finances, smarter.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    color: Colors.white70, // Slightly dimmer white
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 60), // Space for a potential loading indicator
                // Optional: CircularProgressIndicator if you have initial loading
                // CircularProgressIndicator(
                //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

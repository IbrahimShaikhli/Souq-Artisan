import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/screens/authentication/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
  static String routeName = "/splash";

}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Adjust the duration as desired
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    navigateToLoginScreen(); // Call the function to navigate after two seconds
  }

  void navigateToLoginScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      _animationController.forward();
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          // MaterialPageRoute(builder: (context) => TestScreen(
          // demoProducts)),
          MaterialPageRoute(builder: (context) => const LoginScreen()), // Replace with your login screen widget
        );
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset('asset/images/splash.png', width: 350),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

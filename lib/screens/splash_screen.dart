import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/screens/sign_in_screen.dart';
import 'package:task_manager/utils/assets_path.dart';
import 'package:task_manager/widgets/background_body.dart';

import '../utils/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _moveToSignInScreen();
  }

  Future<void> _moveToSignInScreen() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    if(mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BackgroundScreen(
        child:  Center(
          child: AppLogo(),
        ),
      ),
    );
  }
}


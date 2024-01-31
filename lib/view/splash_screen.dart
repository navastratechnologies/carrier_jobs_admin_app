import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';

import '../controller/login_managing_controller.dart';
import 'dashboard.dart';
import 'helpers/colors.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String loginUsername = '';

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen.scale(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            whiteColor,
            whiteColor,
            mainColor,
          ],
        ),
        childWidget: SizedBox(
          height: 300,
          child: Image.asset("assets/icon.png"),
        ),
        duration: const Duration(milliseconds: 2000),
        animationDuration: const Duration(milliseconds: 1500),
        onAnimationEnd: () => debugPrint("On Scale End"),
        nextScreen: loginUsername.isNotEmpty || loginUsername != ''
            ? const Dashboard()
            : const LoginPage(),
      ),
    );
  }

  checkLogin() async {
    String? tokne = await getToken();
    if (tokne != null) {
      setState(
        () {
          loginUsername = tokne;
        },
      );
    }
  }
}

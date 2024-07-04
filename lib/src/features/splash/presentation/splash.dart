import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:projetoflutterapi/src/features/home/presentation/home.dart';
import 'package:projetoflutterapi/src/features/login/presentation/login.dart';
import 'package:projetoflutterapi/src/infra/services/firebase_auth_service.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = GetIt.I<AuthService>();

    return FutureBuilder(
      future: authService.isSignIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Lottie.asset('assets/animation/splash.json'),
            ),
          );
        }
        if (snapshot.data == true) {
          return const Home();
        }
        return const Login();
      },
    );
  }
}

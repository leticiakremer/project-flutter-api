import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projetoflutterapi/src/core/entities/user_entitie.dart';
import 'package:projetoflutterapi/src/features/splash/presentation/splash.dart';
import 'package:projetoflutterapi/src/infra/services/firebase_auth_service.dart';

import 'src/infra/firebase_config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _setupGetIt();
  runApp(const MyApp());
}

_setupGetIt() {
  GetIt.I.registerSingleton<UserEntity>(UserEntity.initial());
  GetIt.I.registerSingleton<AuthService>(
    FirebaseAuthServiceImp(FirebaseAuth.instance),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.green,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const Splash(),
    );
  }
}

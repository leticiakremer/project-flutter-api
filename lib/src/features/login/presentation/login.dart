import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projetoflutterapi/src/core/entities/user_entitie.dart';
import 'package:projetoflutterapi/src/features/register/presenttion/register.dart';
import 'package:projetoflutterapi/src/features/splash/presentation/splash.dart';
import 'package:projetoflutterapi/src/features/widgets/input_custom.dart';
import 'package:projetoflutterapi/src/infra/services/firebase_auth_service.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final AuthService authService = GetIt.I<AuthService>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

    return Scaffold(
        body: Center(
      child: Form(
          key: formKey,
          child: ListView(
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/logo/logo.png',
                width: 300,
                cacheHeight: 300,
                cacheWidth: 300,
              ),
              InputCustom(
                controller: emailController,
                labelText: 'Email',
                isPassword: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              InputCustom(
                controller: passwordController,
                labelText: 'Senha',
                isPassword: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading.value = true;
                    try {
                      final UserEntity? user =
                          await authService.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      if (user != null) {
                        isLoading.value = false;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Splash()),
                        );
                      } else {
                        isLoading.value = false;
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Erro'),
                              content: const Text('Email ou senha inválidos'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: const Text('Ok'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } catch (e) {
                      isLoading.value = false;
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Erro'),
                            content: Text(e.toString()),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                                child: const Text('Ok'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(200, 50),
                ),
                child: ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, value, child) {
                    if (value) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      );
                    }
                    return const Text('Entrar',
                        style: TextStyle(color: Colors.white));
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
                  );
                },
                child: const Text('Cadastrar',
                    style: TextStyle(color: Colors.green)),
              ),
            ],
          )),
    ));
  }
}

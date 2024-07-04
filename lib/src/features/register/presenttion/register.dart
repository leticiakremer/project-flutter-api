import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projetoflutterapi/src/core/entities/user_entitie.dart';
import 'package:projetoflutterapi/src/features/home/presentation/home.dart';
import 'package:projetoflutterapi/src/features/login/presentation/login.dart';
import 'package:projetoflutterapi/src/features/widgets/input_custom.dart';
import 'package:projetoflutterapi/src/infra/services/firebase_auth_service.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

    final AuthService authService = GetIt.I<AuthService>();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Cadastro',
              style: TextStyle(color: Colors.green, fontSize: 20)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
          )),
      body: Center(
        child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'assets/register/register.png',
                  width: 400,
                ),
                InputCustom(
                  controller: nameController,
                  labelText: 'Nome',
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
                InputCustom(
                  controller: confirmPasswordController,
                  labelText: 'Confirmar Senha',
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
                      final UserEntity? user =
                          await authService.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text,
                      );
                      if (user != null) {
                        isLoading.value = false;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      } else {
                        isLoading.value = false;
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Erro'),
                              content: const Text('Erro ao cadastrar'),
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      }
                      return const Text('Cadastrar',
                          style: TextStyle(color: Colors.white));
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

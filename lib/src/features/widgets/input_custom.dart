import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class InputCustom extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final String? Function(String?)? validator;

  const InputCustom({
    super.key,
    required this.controller,
    required this.labelText,
    required this.isPassword,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> obscureText =
        ValueNotifier<bool>(this.isPassword);
    return ValueListenableBuilder(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.green),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.green),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.green),
            ),
            labelStyle: const TextStyle(color: Colors.green),
            suffixIcon: isPassword == false
                ? null
                : IconButton(
                    icon: Icon(
                      value ? Icons.visibility : Icons.visibility_off,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      obscureText.value = !obscureText.value;
                    },
                  ),
          ),
          obscureText: obscureText.value,
        );
      },
    );
  }
}

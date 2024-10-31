import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: controller.temp,
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [context.theme.colorScheme.secondaryContainer, context.theme.colorScheme.onSecondary],
          ),
        ),
        child: Center(
          child: Container(
            width: 500,
            height: 400,
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('ABC School', style: context.textTheme.headlineMedium),
                SizedBox(height: 10),
                Text('Attendance System', style: context.textTheme.titleMedium),
                SizedBox(height: 50),
                TextField(
                  controller: controller.usernameController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your username',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your password',
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: controller.handleLogin,
                  child: Text(
                    'LOGIN',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

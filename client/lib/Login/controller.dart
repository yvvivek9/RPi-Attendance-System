import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:client/Common/common.dart';
import 'package:client/Dashboard/page.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleLogin() async {
    try {
      Get.context!.loaderOverlay.show();
      final response = await httpPostRequest(
        route: '/api/auth/login',
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      final processed = Map.from(response);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', processed['token']);
      Get.offAll(() => DashboardScreen());
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }

  Future<void> temp() async {
    try {
      Get.context!.loaderOverlay.show();
      final response = await httpPostRequest(
        route: '/api/auth/check',
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }
}

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:client/Common/common.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'widgets.dart';

class ListStudentsController extends GetxController {
  final students = [].obs;

  @override
  void onInit() {
    super.onInit();
    getStudentsList();
  }

  Future<void> getStudentsList() async {
    try {
      final response = await httpPostRequest(route: '/api/student/list', body: {});
      final list = List<Map>.from(response);
      students.value = list;
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    }
  }

  Future<void> trainModel() async {
    try {
      Get.context!.loaderOverlay.show();
      final response = await httpPostRequest(route: '/api/student/train', body: {});
      showSuccessSnackBar(content: 'Training completed');
    } catch (e) {
      showErrorSnackBar(content: 'Training failed');
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }

  Future<void> addStudent() async {
    Future<void> callback(String sid, String name, String sclass) async {
      try {
        Get.context!.loaderOverlay.show();
        final response = await httpPostRequest(
          route: '/api/student/add',
          body: {
            'name': name,
            'std_id': sid,
            'std_class': sclass,
          },
        );
      } catch (e) {
        safePrint(e);
        showErrorSnackBar(content: e.toString());
      } finally {
        Get.context!.loaderOverlay.hide();
      }
    }

    try {
      final changed = await showDialog<bool>(
        context: Get.context!,
        builder: (ctx) => AddStudentPopup(successCallback: callback),
      );

      if (changed == true) getStudentsList();
    } catch (e) {
      safePrint(e);
      showErrorSnackBar(content: "Failed to add student");
    }
  }
}

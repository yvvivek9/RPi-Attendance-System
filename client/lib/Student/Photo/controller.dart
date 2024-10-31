import 'dart:typed_data';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:client/Common/common.dart';

class StudentPhotoController extends GetxController {
  late String stdID;
  late CameraController cameraController;
  final List<Uint8List> imagesAsBytes = [];

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    startCameraFeed();
  }

  Future<void> startCameraFeed() async {
    final cameras = await availableCameras();
    cameraController = CameraController(cameras.first, ResolutionPreset.max, enableAudio: false);
    await cameraController.initialize();
    loading.value = true;
  }

  Future<void> capturePhotos() async {
    for (int i = 0; i < 10; i++) {
      final picture = await cameraController.takePicture();
      final picAsBytes = await picture.readAsBytes();
      imagesAsBytes.add(picAsBytes);
    }
    loading.refresh();
  }

  Future<void> uploadPhotos() async {
    for (final image in imagesAsBytes) {
      try {
        final response = await httpPostRequest(
          route: '/api/student/photos/save',
          body: {
            'std_id': stdID,
            'image': base64.encode(image),
            'img_format': 'png',
          },
        );
        showSuccessSnackBar(content: 'Image upload successful');
      } catch (e) {
        safePrint(e);
        showErrorSnackBar(content: e.toString());
      }
    }
    Get.back();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
  }
}

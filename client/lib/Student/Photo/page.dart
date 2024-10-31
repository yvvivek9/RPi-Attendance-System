import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import 'controller.dart';

class StudentPhotoScreen extends StatelessWidget {
  StudentPhotoScreen({super.key, required this.stdID}) {
    controller.stdID = stdID;
  }

  final String stdID;
  final controller = Get.put(StudentPhotoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Face ID"),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Student ID:  $stdID',
                  style: context.textTheme.titleMedium,
                ),
              ),
              SizedBox(height: 30),
              if (controller.loading.value)
                Expanded(
                  flex: 3,
                  child: CameraPreview(
                    controller.cameraController,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ElevatedButton(
                            onPressed: controller.capturePhotos,
                            child: Text('Capture'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 30),
              Expanded(
                child: Row(
                  children: controller.imagesAsBytes
                      .map(
                        (e) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Image.memory(e),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: controller.imagesAsBytes.isEmpty ? null : controller.uploadPhotos,
                  child: Text('Upload Photos'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

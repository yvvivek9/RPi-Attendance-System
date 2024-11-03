import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:client/Student/Photo/page.dart';
import 'controller.dart';
import 'widgets.dart';

class ListStudentsPage extends StatelessWidget {
  ListStudentsPage({super.key});

  final controller = Get.put(ListStudentsController());
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student's List"),
      ),
      body: Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: controller.trainModel,
                        child: Text('Train Model'),
                      ),
                      SizedBox(width: 40),
                      ElevatedButton(
                        onPressed: controller.addStudent,
                        child: Text('Add Student'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  flex: 9,
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: controller.students.value
                              .map<Widget>((e) => Container(
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: context.theme.colorScheme.secondaryContainer,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            'ID:  ${e['std_id']}',
                                          ),
                                        ),
                                        SizedBox(width: 40),
                                        Expanded(
                                          flex: 3,
                                          child: Text('Name:  ${e['name']}'),
                                        ),
                                        SizedBox(width: 40),
                                        Expanded(
                                          child: Text('Class:  ${e['std_class']}'),
                                        ),
                                        SizedBox(width: 40),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) => UpdateRFIDPopup(stdID: e['std_id']),
                                              );
                                            },
                                            child: Text('Update RFID'),
                                          ),
                                        ),
                                        SizedBox(width: 40),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Get.to(() => StudentPhotoScreen(stdID: e['std_id']));
                                            },
                                            child: Text('Update FaceID'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

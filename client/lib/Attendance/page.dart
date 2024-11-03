import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AttendanceScreen extends StatelessWidget {
  AttendanceScreen({super.key});

  final controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List'),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: ExpansionPanelList(
              expansionCallback: (index, expanded) {
                controller.attendance.value[index].expanded = expanded;
                controller.attendance.refresh();
              },
              children: controller.attendance.value
                  .map((e) => ExpansionPanel(
                        headerBuilder: (ctx, exp) => Row(
                          children: [
                            SizedBox(width: 30),
                            Expanded(child: Text("Date:  ${e.date}")),
                            SizedBox(width: 30),
                            Expanded(child: Text("Period:  ${e.period}")),
                            SizedBox(width: 30),
                            Expanded(child: Text("Present:  ${e.present.length}")),
                            SizedBox(width: 100),
                          ],
                        ),
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: e.present.map<Widget>((stdID) {
                            final student = controller.students.firstWhere((e) => e['std_id'] == stdID);
                            return Text("Name:  ${student['name']},      ID:  ${student['std_id']},        Class:  ${student['std_class']}");
                          }).toList(),
                        ),
                        isExpanded: e.expanded,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_clock/one_clock.dart';

import 'controller.dart';

class TimetableScreen extends StatelessWidget {
  TimetableScreen({super.key});

  final controller = Get.put(TimetableController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Timetable'),
        ),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: DropdownMenu(
                            enableSearch: false,
                            requestFocusOnTap: false,
                            hintText: 'Select Day',
                            width: 300,
                            onSelected: (String? value) {
                              if (value != null) {
                                controller.selectedDay = value;
                                controller.selectionUpdated();
                              }
                            },
                            dropdownMenuEntries: [
                              DropdownMenuEntry(value: 'mon', label: 'Monday'),
                              DropdownMenuEntry(value: 'tue', label: 'Tuesday'),
                              DropdownMenuEntry(value: 'wed', label: 'Wednesday'),
                              DropdownMenuEntry(value: 'thur', label: 'Thursday'),
                              DropdownMenuEntry(value: 'fri', label: 'Friday'),
                              DropdownMenuEntry(value: 'sat', label: 'Saturday'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: DropdownMenu(
                            enableSearch: false,
                            requestFocusOnTap: false,
                            hintText: 'Select Period',
                            width: 300,
                            onSelected: (String? value) {
                              if (value != null) {
                                controller.selectedPeriod = value;
                                controller.selectionUpdated();
                              }
                            },
                            dropdownMenuEntries: [
                              DropdownMenuEntry(value: 'p1', label: 'Period 1'),
                              DropdownMenuEntry(value: 'p2', label: 'Period 2'),
                              DropdownMenuEntry(value: 'p3', label: 'Period 3'),
                              DropdownMenuEntry(value: 'p4', label: 'Period 4'),
                              DropdownMenuEntry(value: 'p5', label: 'Period 5'),
                              DropdownMenuEntry(value: 'p6', label: 'Period 6'),
                              DropdownMenuEntry(value: 'p7', label: 'Period 7'),
                              DropdownMenuEntry(value: 'p8', label: 'Period 8'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: AnalogClock(
                                isLive: false,
                                showAllNumbers: true,
                                showSecondHand: false,
                                hourHandColor: Colors.red,
                                datetime: controller.makeDateTimeObject(controller.startTime.value),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('Start Time'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: AnalogClock(
                                isLive: false,
                                showAllNumbers: true,
                                showSecondHand: false,
                                hourHandColor: Colors.red,
                                datetime: controller.makeDateTimeObject(controller.endTime.value),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text('End Time'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: controller.selectedDay != "" && controller.selectedPeriod != "" ? controller.handleUpdate : null,
                    child: Text('Update'),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:client/Common/common.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TimetableController extends GetxController {
  String selectedDay = '';
  String selectedPeriod = '';

  final startTime = TimeOfDay.now().obs;
  final endTime = TimeOfDay.now().obs;

  Future<void> selectionUpdated() async {
    if (selectedPeriod == '' || selectedDay == '') return;
    try {
      Get.context!.loaderOverlay.show();
      final response = await httpPostRequest(
        route: '/api/timetable/period/get',
        body: {
          'day': selectedDay,
          'period': selectedPeriod,
        },
      );
      final decoded = List<String>.from(response);
      startTime.value = makeTimeOfDayObject(decoded[0]);
      endTime.value = makeTimeOfDayObject(decoded[1]);
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }

  Future<void> handleUpdate() async {
    try {
      final newStartTime = await showTimePicker(
        context: Get.context!,
        initialTime: startTime.value,
        confirmText: 'Next',
        helpText: 'Select Period Start Time',
      );
      final newEndTime = await showTimePicker(
        context: Get.context!,
        initialTime: endTime.value,
        confirmText: 'Update',
        helpText: 'Select Period End Time',
      );
      if (newStartTime != null && newEndTime != null) {
        final response = await httpPostRequest(
          route: '/api/timetable/period/update',
          body: {
            'day': selectedDay,
            'period': selectedPeriod,
            'start': '${newStartTime.hour}:${newStartTime.minute}',
            'end': '${newEndTime.hour}:${newEndTime.minute}',
          },
        );
        await httpPostRequest(route: '/system/stop', body: {});
        await httpPostRequest(route: '/system/start', body: {});
        showSuccessSnackBar(content: 'Time update successful');
      }
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    } finally {
      selectionUpdated();
    }
  }

  TimeOfDay makeTimeOfDayObject(String time) {
    final split = time.split(':');
    return TimeOfDay(hour: int.parse(split[0]), minute: int.parse(split[1]));
  }

  DateTime makeDateTimeObject(TimeOfDay time) {
    final temp = DateTime.now();
    return DateTime(temp.year, temp.month, temp.day, time.hour, time.minute);
  }
}

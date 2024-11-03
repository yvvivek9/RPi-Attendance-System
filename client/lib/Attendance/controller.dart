import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:client/Common/common.dart';

class AttendanceController extends GetxController {
  final attendance = Rx<List<AttendanceModel>>([]);
  List<Map> students = [];

  @override
  void onInit() {
    super.onInit();
    getAttendance();
  }

  Future<void> getAttendance() async {
    try {
      await Future.delayed(Duration(seconds: 1), () {});
      Get.context!.loaderOverlay.show();
      final response = await httpPostRequest(route: '/api/attendance/list', body: {});
      final List<AttendanceModel> temp = [];
      for (final i in List<Map>.from(response)) {
        temp.add(AttendanceModel(i["date"], i["period"], List<String>.from(i["present"])));
      }
      final std = await httpPostRequest(route: '/api/student/list', body: {});
      students = List<Map>.from(std);
      attendance.value = temp;
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }
}

class AttendanceModel {
  AttendanceModel(this.date, this.period, this.present);
  final String date;
  final String period;
  final List<String> present;
  bool expanded = false;
}

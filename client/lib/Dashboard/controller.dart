import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:client/Common/common.dart';

class DashboardController extends GetxController {
  final attendance = Rx<List<AttendanceStats>>([]);

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
      final resList = List<Map>.from(response);
      final List<AttendanceStats> temp = [];
      for (final i in resList) {
        temp.add(AttendanceStats("${i['date']}, ${i['period']}", List.from(i['present']).length));
      }
      attendance.value = temp;
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.context!.loaderOverlay.hide();
    }
  }
}

class AttendanceStats {
  const AttendanceStats(this.detail, this.count);
  final String detail;
  final int count;

  @override
  String toString() {
    return 'AttendanceStats{detail: $detail, count: $count}';
  }
}

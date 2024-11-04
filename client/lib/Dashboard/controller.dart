import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

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

class CustomDrawerHeader extends StatefulWidget {
  const CustomDrawerHeader({super.key});

  @override
  State<CustomDrawerHeader> createState() => _CustomDrawerHeaderState();
}

class _CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  bool? serverOn;

  @override
  void initState() {
    getServerStatus();
    super.initState();
  }

  Future<void> getServerStatus() async {
    try {
      final response = await httpPostRequest(route: '/system/status', body: {});
      setState(() {
        serverOn = response;
      });
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    }
  }

  Future<void> changeServerStatus(String route) async {
    try {
      context.loaderOverlay.show();
      final response = await httpPostRequest(route: route, body: {});
      getServerStatus();
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (serverOn!) {
      return DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.red,
        ),
        child: InkWell(
          onTap: () {
            changeServerStatus('/system/stop');
          },
          child: Column(
            children: [
              Spacer(),
              Icon(
                Icons.stop_circle,
                color: Colors.white,
                size: 50,
              ),
              Spacer(),
              Text(
                'Turn off the server',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      );
    }
    if (!serverOn!) {
      return DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.green,
        ),
        child: InkWell(
          onTap: () {
            changeServerStatus('/system/start');
          },
          child: Column(
            children: [
              Spacer(),
              Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
              Spacer(),
              Text(
                'Turn on the server',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      );
    }
    return DrawerHeader(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.tertiary,
      ),
      child: Container(),
    );
  }
}

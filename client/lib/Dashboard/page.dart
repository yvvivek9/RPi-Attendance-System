import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:client/Student/List/page.dart';
import 'package:client/Timetable/page.dart';
import 'package:client/Attendance/page.dart';
import 'controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance system'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomDrawerHeader(),
            ListTile(
              textColor: context.theme.colorScheme.tertiary,
              titleTextStyle: context.textTheme.titleMedium,
              minLeadingWidth: 40,
              leading: Icon(Icons.person),
              title: const Text('Students'),
              onTap: () {
                Get.to(() => ListStudentsPage());
              },
            ),
            ListTile(
              textColor: context.theme.colorScheme.tertiary,
              titleTextStyle: context.textTheme.titleMedium,
              minLeadingWidth: 40,
              leading: Icon(Icons.calendar_month),
              title: const Text('Time Table'),
              onTap: () {
                Get.to(() => TimetableScreen());
              },
            ),
            ListTile(
              textColor: context.theme.colorScheme.tertiary,
              titleTextStyle: context.textTheme.titleMedium,
              minLeadingWidth: 40,
              leading: Icon(Icons.pattern),
              title: const Text('Attendance'),
              onTap: () {
                Get.to(() => AttendanceScreen());
              },
            ),
          ],
        ),
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Center(
                child: Text(
                  "Attendance Statistics",
                  style: context.textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 50),
              Expanded(
                child: AttendanceChart(attendanceData: controller.attendance.value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttendanceChart extends StatefulWidget {
  const AttendanceChart({super.key, required this.attendanceData});

  final List<AttendanceStats> attendanceData;

  @override
  State<AttendanceChart> createState() => _AttendanceChartState();
}

class _AttendanceChartState extends State<AttendanceChart> {
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.theme.colorScheme.inverseSurface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.detail,
                  style: context.textTheme.labelMedium,
                ),
                SizedBox(height: 5),
                // Divider(height: 20),
                SizedBox(height: 5),
                Text(
                  "Present: ${data.count}",
                  style: context.textTheme.labelMedium,
                ),
              ],
            ),
          );
        });
    _zoomPanBehavior = ZoomPanBehavior(
      enableMouseWheelZooming: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      tooltipBehavior: _tooltipBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(
          color: Colors.transparent,
        ),
        title: AxisTitle(
          text: "Date and Period",
        ),
      ),
      primaryYAxis: NumericAxis(
        anchorRangeToVisiblePoints: false,
        enableAutoIntervalOnZooming: false,
        title: AxisTitle(
          text: "Present",
        ),
      ),
      series: [
        LineSeries<AttendanceStats, String>(
          dataSource: widget.attendanceData,
          name: "Attendance",
          enableTooltip: true,
          xValueMapper: (AttendanceStats data, _) => data.detail,
          yValueMapper: (AttendanceStats data, _) => data.count,
          markerSettings: MarkerSettings(isVisible: true),
        ),
      ],
    );
  }
}

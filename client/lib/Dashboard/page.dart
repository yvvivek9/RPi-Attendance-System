import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:client/Student/List/page.dart';
import 'package:client/Timetable/page.dart';
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.tertiary,
              ),
              child: Container(),
            ),
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
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:client/Common/common.dart';

class AddStudentPopup extends StatelessWidget {
  const AddStudentPopup({super.key, required this.successCallback});

  final Function(String sid, String name, String sclass) successCallback;

  @override
  Widget build(BuildContext context) {
    final sidTC = TextEditingController();
    final nameTC = TextEditingController();
    final sclassTC = TextEditingController();

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Theme.of(context).colorScheme.tertiary,
              child: Text(
                "Add Student",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Student ID :')),
                      Expanded(
                        child: TextField(
                          controller: sidTC,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text('Student name :')),
                      Expanded(
                        child: TextField(
                          controller: nameTC,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text('Student class :')),
                      Expanded(
                        child: TextField(
                          controller: sclassTC,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    await successCallback(sidTC.text, nameTC.text, sclassTC.text);
                    Get.back(result: true);
                  },
                  child: Text("Add"),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class UpdateRFIDPopup extends StatefulWidget {
  const UpdateRFIDPopup({super.key, required this.stdID});

  final String stdID;

  @override
  State<UpdateRFIDPopup> createState() => _UpdateRFIDPopupState();
}

class _UpdateRFIDPopupState extends State<UpdateRFIDPopup> {
  @override
  void initState() {
    sendRequest();
    super.initState();
  }

  Future<void> sendRequest() async {
    try {
      final response = await httpPostRequest(
        route: '/api/student/rfid/save',
        body: {
          "std_id": widget.stdID,
        },
      );
      showSuccessSnackBar(content: 'RFID Updated');
    } catch (e) {
      showErrorSnackBar(content: e.toString());
    } finally {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.theme.colorScheme.surface,
        ),
        child: Center(
          child: Text(
            'Place RFID card on the reader',
            style: context.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}

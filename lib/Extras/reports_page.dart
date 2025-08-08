import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //placeholder: fake list of past reports
    final fakeReports = [
      "Intruder at front gate - july 9",
      "Unauthorized vehicle parked - july 8",
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Past Reports")),

      body: SafeArea(
          child: SingleChildScrollView(
            child: ListView.builder(
              itemCount: fakeReports.length,
              itemBuilder: (_, index) => ListTile(
                leading: const Icon(Icons.report),
                title: Text(fakeReports[index]),
              )
            ),
      )
      )
    );
  }
}
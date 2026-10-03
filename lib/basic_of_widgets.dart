import 'package:flutter/material.dart';

class BasicOfWidgets extends StatelessWidget {
  const BasicOfWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Counter"), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          children: [
            Text("Counter App"),
            Text(
              "data",

              style: TextStyle(color: Colors.redAccent, fontSize: 30),
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),

              child: Text("Container", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

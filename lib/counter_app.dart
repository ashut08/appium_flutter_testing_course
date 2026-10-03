import 'package:appiumtesting/counter_controller.dart';
import 'package:flutter/material.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  final counterController = CounterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: ValueKey('increment'),
        onPressed: () {
          setState(() {
            counterController.increment();
          });
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text("Conter App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              key: ValueKey("many_times"),
              "You have pushed the button this many times",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),

            Text(
              key: ValueKey('counter'),
              "${counterController.count}",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  key: ValueKey("decrement"),
                  onPressed: () {
                    setState(() {
                      counterController.decrement();
                    });
                  },
                  icon: Icon(Icons.remove),
                ),

                SizedBox(width: 10),
                OutlinedButton(
                  key: ValueKey("reset"),
                  onPressed: () {
                    setState(() {
                      counterController.reset();
                    });
                  },
                  child: Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

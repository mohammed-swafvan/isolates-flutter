import 'dart:isolate';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(child: Image.asset('assets/gif/boll_gif.gif')),
            const SizedBox(height: 30),

            /// sycronously (Blocking UI task)
            ElevatedButton(
              child: const Text('Task1'),
              onPressed: () {
                double res = complexTask1();
                setState(() {
                  result = res.toString();
                });
              },
            ),

            const SizedBox(height: 10),

            /// asycronously (Blocking UI task)
            ElevatedButton(
              child: const Text('Task2'),
              onPressed: () async {
                double res = await complexTask2();
                setState(() {
                  result = res.toString();
                });
              },
            ),

            const SizedBox(height: 10),

            /// isolates
            ElevatedButton(
              child: const Text('Task3'),
              onPressed: () async {
                final recievePort = ReceivePort();
                await Isolate.spawn(complexTask3, recievePort.sendPort);
                recievePort.listen((total) {
                  setState(() {
                    result = total.toString();
                  });
                });
              },
            ),
            const SizedBox(height: 10),
            Text('Result: $result'),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  double complexTask1() {
    double total = 1.0;
    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }

  Future<double> complexTask2() async {
    double total = 1.0;
    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}

/// end of the class

complexTask3(SendPort sendPort) {
  int total = 1;
  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('title'),
          backgroundColor: Colors.green,
        ),
        body: Container(
          child: const Text('WE\'RE LEARNING FLUTTERRRR'),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.orange,
              width: 10
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.account_circle),
                label: 'Profile')
          ],
          selectedIndex: selectedPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });

          },
          animationDuration: Duration(milliseconds: 1000),
        ),
      )
    );
  }
}
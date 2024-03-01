import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({Key? key}) : super(key:key);
  @override
  _MyDash createState() => _MyDash();
}

class _MyDash extends State<Dashboard> {

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
          body: Stack(
            children: [
              Container(
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

            ],
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
import 'package:flutter/material.dart';
import 'loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }
  Future<void> init() async{
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => const LoginPage()));
    });
  }
  @override
  void setState(fn){
    if(mounted) super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF68A268),
          body: Stack(
              alignment: Alignment.center,
              children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  const Spacer(),
                const Text(
                  'Restaurant',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white
                  ),
                ),
                const Spacer(),
                Container(
                  height: 100,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/logo.png'),
                       fit: BoxFit.cover
                    )
                  ),
                ),
                const Spacer(),
                const Column(
                  children: [
                    Text("version",
                    style: TextStyle(color: Colors.white)
                    ),
                    Text('1.0.0',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)
                    )
                  ],
                )
              ],
            ),
          ),
                Container(
                  height: 630,
                )
        ]
      ),
    ));
  }
}

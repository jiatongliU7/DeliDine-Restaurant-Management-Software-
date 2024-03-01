import 'Package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

}
class _LoginPageState extends State<LoginPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
    backgroundColor: Color.fromRGBO(213, 255, 185, 1.0),
      body: SafeArea(
        child: Center(
        child: Column(
          children: [
            const Text(
              "Hi again!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32
              ),
          ),
          const SizedBox(height: 10,),
          const Text(
            "Welcome Back! You have been Missed(at work)!",
            style: TextStyle(
              fontSize: 16
            )
          ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(

                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                  color: Color.fromRGBO(150, 255, 160, 1)
              ),
                child: const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                ),
              ),
             ),

            )
            ),
            const SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(150, 255, 160, 1)
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                      ),
                    ),
                  ),

                )
            ),
            const SizedBox(height: 10),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Sign In")

            )
            ),
        ],

      )
    )
      )
    );
  }
}
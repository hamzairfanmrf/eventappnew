import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                  color: Color(0xFFE91E63),
                  borderRadius: BorderRadius.all(Radius.circular(40))
              ),

              width: MediaQuery.of(context).size.width,

              // Change the color to your desired color
              padding: EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/Group 803.png',
                fit: BoxFit.cover,
              ), // Replace with your image path
            ),
            SizedBox(
              height: 30,
            ),
            Text("Welcome to Event app",
              style: TextStyle(
                color: Color(0xFFE91E63),
                fontSize: 25,

              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Enter the password",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 5,

            ),
            Text("Also confirm your password",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(


                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.lock,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                  hintText: "Password",


                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: InputDecoration(


                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.lock,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                  hintText: "Confirm Password",


                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width/1.2,
              height: 50,
              child: ElevatedButton(

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFE91E63), // Background color
                ),
                child: const Text(
                  'Next',
                  // style: TextStyle(fontSize: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

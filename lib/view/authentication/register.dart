
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/event_provider.dart';
import 'login.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController phoneNumber=TextEditingController();
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
            Text("Enter your mobile Number",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
            // SizedBox(
            //   height: 5,
            //
            // ),
            // Text("Password that belongs to your account",
            //   style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: TextField(
                textAlign: TextAlign.center,
                controller: phoneNumber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(


                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Icon(
                      Icons.call_end_outlined,
                      color: Color(0xFFE91E63),
                    ),
                  ),
                  hintText: "Phone Number",


                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // SizedBox(
            //   width: 350,
            //   child: TextField(
            //     textAlign: TextAlign.center,
            //     obscureText: true,
            //     decoration: InputDecoration(
            //
            //
            //       prefixIcon: Padding(
            //         padding: const EdgeInsets.only(left: 20.0),
            //         child: Icon(
            //           Icons.lock,
            //           color: Color(0xFF8387F1),
            //         ),
            //       ),
            //       hintText: "Password",
            //
            //
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width/1.2,
              height: 50,
              child: ElevatedButton(

                onPressed: () {
                  context.read<EventProvider>().verifyPhone(phoneNumber.text.trim(),context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OtpScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFE91E63), // Background color
                ),
                child: const Text(
                  'Register',
                  // style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  LoginForm()),
                      );

            },
                    child: Text('Already have an account? Login',
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            )
            // Container(
            //   color: Colors.grey,
            //   padding: EdgeInsets.all(16.0),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       labelText: 'Phone Number',
            //       border: OutlineInputBorder(),
            //     ),
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.all(16.0),
            //   child: TextField(
            //     obscureText: true,
            //     decoration: InputDecoration(
            //       labelText: 'Password',
            //       border: OutlineInputBorder(),
            //     ),
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Add your login logic here
            //   },
            //   child: Text('Login'),
            // ),
          ],
        ),
      ),
    );
  }
}

import 'package:eventappnew/view/authentication/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../../view_model/event_provider.dart';
import '../home/home_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var otpController="";
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
            Text("Enter OTP sent on your mobile Number",
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
            OTPTextField(
              length: 6,

               width: MediaQuery.of(context).size.width,
              fieldWidth: 60,
              style: TextStyle(
                  fontSize: 17
              ),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.underline,
              onCompleted: (pin) {
                print("Completed: " + pin);
               setState(() {
                 otpController=pin;
               });
              },
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
                  context.read<EventProvider>().verifyOTP(otpController,context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFE91E63), // Background color
                ),
                child: const Text(
                  'Submit',
                  // style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 5.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Text('Already have an account? Login',
            //         style: TextStyle(
            //             fontWeight: FontWeight.bold
            //         ),
            //       )
            //     ],
            //   ),
            // )
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

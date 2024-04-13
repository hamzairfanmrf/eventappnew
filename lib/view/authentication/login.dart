
import 'package:eventappnew/view/authentication/otp_screen.dart';
import 'package:eventappnew/view/authentication/register.dart';
import 'package:eventappnew/view_model/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_screen.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
              decoration: const BoxDecoration(
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
            const SizedBox(
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
            Text("Enter your mobile Number and Verify",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            ),
            SizedBox(
              height: 5,

            ),
            Text("Password that belongs to your account",
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
                controller: phoneNumber,
                textAlign: TextAlign.center,
                // keyboardType: TextInputType.number,
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
            //           color: Color(0xFFE91E63),
            //
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

                onPressed: () async{
                  String phoneNumber = this.phoneNumber.text.trim();

                  // Check if the phone number exists in the user list
                  bool isUserExists = await context.read<EventProvider>().doesUserExist(phoneNumber);// Add your logic to check if the phone number exists in the user list;

                  if (isUserExists) {
                    // If the user exists, proceed with phone verification
                    context.read<EventProvider>().verifyPhone(phoneNumber, context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OtpScreen()),
                    );
                  } else {
                    // If the user does not exist, display a Snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please register your number first'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary:  Color(0xFFE91E63), // Background color
                ),
                child: const Text(
                  'Login',
                  // style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );

                    },
                    child: Text('Dont have an account? Register',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}

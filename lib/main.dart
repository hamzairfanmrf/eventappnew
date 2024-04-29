
import 'package:eventappnew/live_streaming/join_screen.dart';
import 'package:eventappnew/user/user_profile.dart';
import 'package:eventappnew/view/animation/custom_animation.dart';
import 'package:eventappnew/view/authentication/login.dart';
import 'package:eventappnew/view/event/event_detail.dart';
import 'package:eventappnew/view/event/participated_events.dart';
import 'package:eventappnew/view/event/payment/card_details.dart';
import 'package:eventappnew/view/event/upload_event.dart';
import 'package:eventappnew/view/home/home_screen.dart';
import 'package:eventappnew/view/splash/splash_screen.dart';
import 'package:eventappnew/view_model/event_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'admin/approve_events.dart';
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(isAuthenticated: user != null));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;

  const MyApp({Key? key, required this.isAuthenticated}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => EventProvider(),
          ),

        ],
        child: MaterialApp(
            builder: EasyLoading.init(),

        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
          home: SplashScreen(isAuthenticated: isAuthenticated,),
    ),
      );
  }
}

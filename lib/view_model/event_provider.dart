import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventappnew/admin/approve_events.dart';
import 'package:eventappnew/constants/constants.dart';
import 'package:eventappnew/view/event/event_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../model/event_model.dart';
import '../view/home/home_screen.dart';
import 'package:http/http.dart' as http;

class EventProvider extends ChangeNotifier {
  String _imageUrl = "";

  String get imageUrl => _imageUrl;

  String _verID = "";
  EventModel? _eventModel;
  String phoneNum="";
  List<EventModel> getAllEvents=[];

  EventModel get eventModel => _eventModel!;
  String _userImageUrl='';

  // Function to fetch user data and update image URL for current user
  Future<void> fetchUserDataAndUpdateImageUrl() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      var userData = snapshot.data() as Map<String, dynamic>; // Explicit cast
      if (userData != null) {
        _userImageUrl = userData['imageUrl'];
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  // Function to get user image URL
  String getUserImageUrl() {
    return _userImageUrl;
  }
  var snackBar = SnackBar(
    content: Text('OTP sent'),
  );

   getAllEventsFromFirebase() async{
     FirebaseFirestore.instance
         .collection('events')
         .get()
         .then((QuerySnapshot querySnapshot) {
       querySnapshot.docs.forEach((doc) {
         Timestamp t=doc['date'] as Timestamp;
         DateTime d=t.toDate();
        getAllEvents.add(  EventModel(imageUrl: doc['image'],
            eventName: doc['eventName'], city: doc['city'], price: doc['price'],
            type: doc['type'], date: d, eventLat: doc['eventLat'],
            eventLong: doc['eventLong'], eventTime: doc['eventTime'],
            status: doc['status'], createdBy: doc['createdBy'],
            desc: doc["desc"], documentId: doc.id));
       });
     });
  }

  sendOTP(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = '';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      verificationFailed: (FirebaseAuthException error) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    printMessage("OTP Sent to  $phoneNumber");
  }

  authenticate(ConfirmationResult confirmationResult, String otp) async {
    UserCredential userCredential = await confirmationResult.confirm(otp);
    userCredential.additionalUserInfo!.isNewUser
        ? printMessage("Authentication Successful")
        : printMessage("User already exists");
  }


  printMessage(String msg) {
    debugPrint(msg);
  }

  setEvent(EventModel event) {
    _eventModel = event;
    notifyListeners();
  }


  setImageUrl(String url) {
    _imageUrl = url;
    notifyListeners();
  }

  Future<void> verifyPhone(String number, BuildContext context) async {
    phoneNum = number;

    // Check if the phone number is in the 'deletedUser' collection
    var deletedUserDoc = await FirebaseFirestore.instance.collection('deletedUser').where('phoneNumber', isEqualTo: number).get();

    if (deletedUserDoc.docs.isNotEmpty) {
      // Phone number is in the 'deletedUser' collection, display a Snackbar
      var snackBar = SnackBar(content: Text("Cannot use this number because you are blocked."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          // Your verification completed logic here
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        var snackBar = SnackBar(content: Text("Verification failed: ${e.message}"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      codeSent: (String verificationId, int? resendToken) {
        var snackBar = SnackBar(content: Text("Verification code sent."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _verID = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Code auto-retrieval timeout logic here
      },
    );

    notifyListeners();
  }


  Future<void> verifyOTP(String otpPin, BuildContext context) async {
    String Image, phone, role, userName, end_time, holiday, start_time, tokenid;
    var earnings;

    try {
      var authResult = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: _verID,
          smsCode: otpPin,
        ),
      );

      var userDoc = await FirebaseFirestore.instance.collection("Users").doc(authResult.user?.uid).get();

      if (userDoc.exists) {
        // User already exists, check for role and navigate accordingly
        role = userDoc['role'];
        if (role == "user") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (role == "admin") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ApproveEvents()),
          );
        }
      } else {
        // User does not exist, create a new document
        await FirebaseFirestore.instance.collection("Users").doc(authResult.user?.uid).set({
          "id": authResult.user?.uid,
          "name": "",
          "imageUrl": "default",
          "role": phoneNum == "+905435764144" ? "admin" : "user",
          "phoneNumber": phoneNum,
        });

        // Navigate based on the role
        if (phoneNum == "+905435764144") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ApproveEvents()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      var snackBar = SnackBar(content: Text("Verification failed: $e"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  double totalDist=0;
  int total=0;
  double calculateDistance(double lat1,double lon1,double lat2,double lon2){
    // double lat2=context.read<WorkerSideProvider>().userLat;
    // double lon2=context.read<WorkerSideProvider>().userLong;

    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    totalDist=12742* asin(sqrt(a));
    total=totalDist.round();


    return   totalDist;
  }
List<EventModel> nearbyEvents=[];
  getNearByEvents(BuildContext context) async{
    var pos=await _determinePosition(context);
    FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Timestamp t=doc['date'] as Timestamp;
        DateTime d=t.toDate();
        var dis= calculateDistance(pos.latitude, pos.longitude, double.parse(doc['eventLat']), double.parse(doc['eventLong']));
        if(dis<10){
          nearbyEvents.add(

              EventModel(imageUrl: doc['image'],
                      eventName: doc['eventName'], city: doc['city'], price: "Free",
                      type: doc['type'], date: d, eventLat: doc['eventLat'],
                      eventLong: doc['eventLong'], eventTime: doc['eventTime'],
                      status: doc['status'], createdBy: doc['createdBy'],
                      desc: doc["desc"], documentId: doc.id)
          );

        }

        // if(categoryType==doc['type']){
        //   filteredEvents.add(EventModel(imageUrl: doc['image'],
        //       eventName: doc['eventName'], city: doc['city'], price: "Free",
        //       type: doc['type'], date: d, eventLat: doc['eventLat'],
        //       eventLong: doc['eventLong'], eventTime: doc['eventTime'],
        //       status: doc['status'], createdBy: doc['createdBy'],
        //       desc: doc["desc"], documentId: doc.id));
        // }

      });
    });
    notifyListeners();
  }
  Future<Position> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  late Timer _timer;
  int _start = 15;
getText(){
 if(_start==0){
   return Text("No events found near you");
 }
 else{
   return CircularProgressIndicator(
     color: defaultColor,
   );
 }
}

   startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          notifyListeners();
          return getText();

        } else if(nearbyEvents.isNotEmpty){
          timer.cancel();
          notifyListeners();
        }
          else {
          _start--;
          print(_start);

         notifyListeners();

        }
      },
    );
    return getText();
  }
  Future<bool> doesUserExist(String phoneNumber) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Query the Users collection to find a document with the provided phoneNumber
      QuerySnapshot querySnapshot = await firestore
          .collection('Users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      // Check if any documents were found
      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      // Handle any errors that occur during the query
      print('Error checking user existence: $error');
      return false;
    }
  }
  String? getEventWithHighestScore(List<dynamic> recommendations) {
    double maxScore = double.negativeInfinity;
    String? eventNameWithMaxScore;

    for (var recommendation in recommendations) {
      String eventName = recommendation[0];
      double score = recommendation[1];

      if (score > maxScore) {
        maxScore = score;
        eventNameWithMaxScore = eventName;
      }
    }

    return eventNameWithMaxScore;
  }
  Future<List<dynamic>> fetchRecommendations(String userId) async {
    final String apiUrl = 'http://192.168.1.2:5000/recommend';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      List<dynamic> recommendations = jsonDecode(response.body);
      return recommendations;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load recommendations');
    }
  }
  List<EventModel> particitpatedEvents=[];
  Future participatedEvents() async{
    particitpatedEvents.clear();
    await FirebaseFirestore.instance
        .collection('events')

        .get()
        .then((QuerySnapshot querySnapshot) {

      querySnapshot.docs.forEach((doc) {
        Timestamp t=doc['date'] as Timestamp;
        DateTime d=t.toDate();
        FirebaseFirestore.instance
            .collection('events')
        .doc(doc.id)
        .collection('participants')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc2) {

            if(doc2['userId']==FirebaseAuth.instance.currentUser!.uid){
              particitpatedEvents.add(
                  EventModel(imageUrl: doc['image'],
                      eventName: doc['eventName'], city: doc['city'], price: "Free",
                      type: doc['type'], date: d, eventLat: doc['eventLat'],
                      eventLong: doc['eventLong'], eventTime: doc['eventTime'],
                      status: doc['status'], createdBy: doc['createdBy'],
                      desc: doc["desc"], documentId: doc.id)
              );

            }
          });
        });
      });
    });
    notifyListeners();
  }
}
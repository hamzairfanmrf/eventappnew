import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventappnew/constants/constants.dart';
import 'package:eventappnew/view/home/home_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../view/animation/custom_animation.dart';

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
double hei = 0;
double wid = 0;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _image = TextEditingController();
  UploadTask? task;
  File? image;
  Timer? _timer;
  int i=0;
  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (Image == null) {
        return "select Image";
      }
      final imageTemprory = File(image!.path);
      setState(() {
        this.image = imageTemprory;
      });
    } on Exception catch (e) {
      print("failed to pickImage");
      // TODO
    }
  }
  void initstate() {
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    //EasyLoading.showSuccess('Use in initState');
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {


    hei = MediaQuery.of(context).size.height;
    wid = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {

        return true;
      },
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return Scaffold(
                key: _scaffoldKey,
                floatingActionButton: FloatingActionButton(
                  backgroundColor: defaultColor,
                  child: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                  onPressed: ()  {
                    uploadToFirebase(image);
                    print("image url iss ${snapshot.data!['imageUrl']}");

                  },
                ),
                body:  Column(children: [
                  Container(
                    height: hei / 5.25,
                    width: wid,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0)),
                        gradient: LinearGradient(
                            colors: [Colors.lightGreen, Colors.yellow],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: hei / 37.421,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 30.0),
                        child: Text(
                          snapshot.data!['name'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                          height: 50),
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 80.0),
                        child: Text(
                          snapshot.data!['phoneNumber'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Center(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () async {
                                  getImage();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => DummyFaceCheck()),
                                  // );

                                },
                                child:snapshot.data!['imageUrl']=="default"?
                                ClipOval(
                                  child: image != null
                                      ? Image.file(
                                    image!,
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  )
                                      : Icon(
                                    Icons.camera_alt,
                                  ),
                                ):ClipOval(
                                  child: Image.network(snapshot.data!['imageUrl'],
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                )
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: (){
                                getImage();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => DummyFaceCheck()),
                                // );
                              },
                              child: Text("Change Picture",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ]),
                  )
                ])
            );
          }),
    );

  }

  Future  uploadToFirebase(File? img) async {
    EasyLoading.show(status: "Uploading");
    final fileName = File(image!.path);
    final destination = 'files/$fileName';
    try {
      final ref =  FirebaseStorage.instance.ref(destination);


      task = ref.putFile(image!);
      final snapShot = await task!.whenComplete(() {

      });
      final urlDownload = await snapShot.ref.getDownloadURL();
      print("donload link is $urlDownload");
      var db = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid);

      Map<String,dynamic> ourData={
        'imageUrl':urlDownload
      };

      db.update(ourData).then((value) {
        EasyLoading.showSuccess("Uploaded");
        EasyLoading.dismiss();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

      });
    }

    on FirebaseException catch (e) {
      return null;
    }
  }
}
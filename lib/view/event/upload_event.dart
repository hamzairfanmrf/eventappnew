import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:eventappnew/view/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';

import '../animation/custom_animation.dart';


class UploadEvents extends StatefulWidget {
  const UploadEvents({super.key});

  @override
  State<UploadEvents> createState() => _UploadEventsState();
}

class _UploadEventsState extends State<UploadEvents> {
  FocusNode textSecondFocusNode = FocusNode();
  int notesHeaderMaxLenth = 25;
  int notesDescriptionMaxLines = 10;
  int notesDescriptionMaxLenth = 150;
  String deletedNoteHeading = "";
  String deletedNoteDescription = "";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
var time=null;
  TextEditingController locationLat = TextEditingController();
  TextEditingController locationLong = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  String dropdownvalue = 'Festivals';
  bool isPaid=false;
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
  var items = [
    'Festivals',
    'Conferences',
    'Educational',
    'Webinars',
    'Seminars',
    'Religious',
  ];
  var date;
  UploadTask? task;
  File? image;
  Timer? _timer;
  int i = 0;
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
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child:Column(
            children: [
              InkWell(
                onTap: () async{
                 await getImage();
                },
                child: ClipOval(

                  child: image != null
                      ? Image.file(
                    image!,
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  )
                      : InkWell(
                    onTap: () async{
                     await  getImage();
                    },
                        child: CircleAvatar(
                    radius: 40,
                          backgroundColor: defaultColor,

                          child: Icon(

                    Icons.camera_alt,
                  ),
                        ),
                      ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  controller: titleController,

                  textAlign: TextAlign.center,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(


                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Icon(
                        Icons.pending_actions,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    hintText: "Event title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  keyboardType:TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,9}'))
                  ],
                  controller: locationLat,

                  textAlign: TextAlign.center,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(


                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Icon(
                        Icons.location_on,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    hintText: "Enter Lat",


                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                  keyboardType:TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,9}'))
                  ],
                  controller: locationLong,

                  textAlign: TextAlign.center,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(


                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Icon(
                        Icons.location_on,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    hintText: "Enter Long",


                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 350,
                child: TextFormField(

                  controller: cityController,

                  textAlign: TextAlign.center,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(


                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Icon(
                        Icons.location_on,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    hintText: "Enter City",


                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
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
                        Icons.phone,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    hintText: "Contact No if admin wants to contact",


                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary:  isPaid?Colors.white:Color(0xFFE91E63), // Background color
                      ),
                      onPressed: ()async{
                        setState(() {

                          isPaid=false;
                        });
                      }, child: Text("Free",
                  style: TextStyle(
                    color: isPaid?Colors.black:Colors.white
                  ),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary:  isPaid?Color(0xFFE91E63):Colors.white, // Background color
                      ),
                      onPressed: ()async{
                        setState(() {

                          isPaid=true;
                        });

                      }, child: Text("Paid",
                  style: TextStyle(
                    color: isPaid?Colors.white:Colors.black
                  ),
                  )),

                ],
              ),
              SizedBox(
                height: 5,
              ),
             isPaid? SizedBox(
                width: 350,
                child: TextFormField(
                  keyboardType:TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,9}'))
                  ],
                  controller: amountController,

                  textAlign: TextAlign.center,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(


                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Icon(
                        Icons.money_off_csred_outlined,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    hintText: "Enter Price",


                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ):Container(),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:  Color(0xFFE91E63), // Background color
                  ),
                  onPressed: ()async{

             time=await TimePicker.show(
                  context: context,

                  sheet: TimePickerSheet(
                    saveButtonColor: defaultColor,
                    sheetCloseIconColor: defaultColor,
                    hourTitleStyle: TextStyle(
                      color: defaultColor,
                      fontWeight: FontWeight.bold

                    ),
                    minuteTitleStyle: TextStyle(
                        color: defaultColor,
                        fontWeight: FontWeight.bold

                    ),

                    sheetTitle: 'Set meeting schedule',
                    hourTitle: 'Hour',
                    minuteTitle: 'Minute',
                    saveButtonText: 'Save',
                  ),
                );

              }, child: Text("Select time")),
           time!=null?   Text("${time.hour}: ${time.minute}"):Text(""),

              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder( //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder( //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                    filled: true,
                    fillColor:defaultColor,
                  ),
                  dropdownColor: defaultColor,
                  value: dropdownvalue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 20,
                        color: Colors.white
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Padding(
                padding:  EdgeInsets.all(15),
                child: Container(
                  margin: EdgeInsets.all(1),
                  height: 5 * 24.0,
                  child: TextField(
                     controller: descriptionController,
                    focusNode: textSecondFocusNode,
                    maxLines: notesDescriptionMaxLines,
                    maxLength: notesDescriptionMaxLenth,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Description',
                      hintStyle: TextStyle(
                        fontSize: 15.00,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              EasyDateTimeLine(
                initialDate: DateTime.now(),
                onDateChange: (selectedDate) {
                  date=selectedDate;
                  //`selectedDate` the new date selected.
                },
                activeColor: defaultColor,
                headerProps: const EasyHeaderProps(
                  monthPickerType: MonthPickerType.switcher,
                  selectedDateFormat: SelectedDateFormat.fullDateDayAsStrMY,
                ),

                timeLineProps: const EasyTimeLineProps(
                  hPadding: 16.0, // padding from left and right
                  separatorPadding: 16.0, // padding between days
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width/1.2,
                height: 50,
                child: ElevatedButton(

                  onPressed: () {
                    if(titleController.text.trim().isEmpty || locationLat.text.trim().isEmpty
                    || locationLong.text.isEmpty || phoneNumber.text.isEmpty
                    || isPaid==true && amountController.text.isEmpty || descriptionController.text.isEmpty
                    || date.toString().isEmpty || time.toString().isEmpty
                    ){
                      Alert(
                        context: context,
                        type: AlertType.error,
                        title: "Error",
                        desc: "Please enter all fields",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Okay",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();

                    }
                    else{
                      uploadToFirebase(image);
                    }


                  },
                  style: ElevatedButton.styleFrom(
                    primary:  Color(0xFFE91E63), // Background color
                  ),
                  child: const Text(
                    'Upload',
                    // style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
  Future uploadToFirebase(File? img) async {
    EasyLoading.show(status: "Uploading");
    final fileName = File(image!.path);
    final destination = 'files/$fileName';
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      task = ref.putFile(image!);
      final snapShot = await task!.whenComplete(() {});
      final urlDownload = await snapShot.ref.getDownloadURL();
      print("donload link is $urlDownload");
      FirebaseFirestore.instance.collection('events')
          .add({
        "eventName":titleController.text.trim(),
        "eventLat":locationLat.text.trim(),
        "eventLong":locationLong.text.trim(),
        "eventTime":"${time.hour}: ${time.minute}",
        "desc":descriptionController.text.trim(),
        "date":date,
        "image":urlDownload,
        "type":dropdownvalue,
        "createdBy":"",
        "status":"pending",
        'price':amountController.text.trim(),
        "city":cityController.text.trim(),

      }).then((value) => {
        EasyLoading.showSuccess("Done"),
        EasyLoading.dismiss(),
      });

    } on FirebaseException catch (e) {
      return null;
    }
  }
}

import 'dart:io';

import 'package:eventappnew/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class ShowAllUsers extends StatefulWidget {
  const ShowAllUsers({Key? key}) : super(key: key);

  @override
  _ShowAllUsersState createState() => _ShowAllUsersState();
}

class _ShowAllUsersState extends State<ShowAllUsers> {
  late List<Map<String, dynamic>> usersData;
  @override
  void initState() {
    // TODO: implement initState
    usersData = [];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
        backgroundColor: defaultColor,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }
          usersData = snapshot.data!.docs.map((doc) {
            return {
              'name': doc['name'],
              'phoneNumber': doc['phoneNumber'],
            };
          }).toList();
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return ListTile(
                leading: Icon(
                  Icons.person,
                  color: defaultColor,
                ),
                title: Text(user['phoneNumber']),
                subtitle: Text(user['role']),
                onTap: () {
                  showDeleteUserConfirmationDialog(user.id, user['phoneNumber']);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await generateCsv();
        },
        child: Icon(Icons.download),
        backgroundColor: defaultColor,
      ),
    );
  }

  Future<void> generateCsv() async {
    final List<List<dynamic>> rows = [];

    // Add header row
    rows.add(['Name', 'Phone Number']);

    // Add user data rows
    usersData.forEach((user) {
      rows.add([user['name'], user['phoneNumber']]);
    });

    // Get directory path
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/users.csv';

    // Write CSV file
    File file = File(filePath);
    String csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);

    // Show message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV file generated and saved to $filePath'),
      ),
    );
  }

  Future<void> showDeleteUserConfirmationDialog(String userId, String phoneNumber) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: defaultColor),
              ),
            ),
            TextButton(
              onPressed: () {
                deleteAndPopUser(userId, phoneNumber);
              },
              child: Text(
                'Yes',
                style: TextStyle(color: defaultColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteAndPopUser(String userId, String phoneNumber) async {
    await FirebaseFirestore.instance.collection('Users').doc(userId).delete();
    await FirebaseFirestore.instance.collection('deletedUser').doc(userId).set({
      'userId': userId,
      'phoneNumber': phoneNumber,
      'timestamp': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context); // Close the confirmation dialog
  }
}

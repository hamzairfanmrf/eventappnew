import 'package:eventappnew/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowAllUsers extends StatefulWidget {
  const ShowAllUsers({Key? key}) : super(key: key);

  @override
  _ShowAllUsersState createState() => _ShowAllUsersState();
}

class _ShowAllUsersState extends State<ShowAllUsers> {
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

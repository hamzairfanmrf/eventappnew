import 'dart:convert';
import 'package:http/http.dart' as http;

//Auth token we will use to generate a meeting and connect to it
const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiJhYmJmMjIwZi0yNGFkLTQ5MTAtYTc1MS1kODU0NmEzMTVkNGQiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTcxNDQxNTcyOSwiZXhwIjoxODcyMjAzNzI5fQ.qldxReX3pZrYSUZ0z9wgnBz2ys23XEe8koKhM1uAWYY';

// API call to create meeting
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse('https://api.videosdk.live/v2/rooms'),
    headers: {'Authorization': token},
  );

//Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomId'];
}

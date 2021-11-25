import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_regis_provider/domain/times.dart';
import 'package:flutter_login_regis_provider/domain/user.dart';
import 'package:flutter_login_regis_provider/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../dropDowns.dart';

String getToday(){
  final now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  return date.toString().substring(0,10);;
}

class SignDialog extends StatefulWidget {
  final Function updateSign;
  final String row_date;
  SignDialog(this.updateSign, this.row_date,);
  @override
  _SignDialogState createState() => _SignDialogState();
}

class _SignDialogState extends State<SignDialog> {
  String today;
  String _desc = "";
  int _wilaya = 16;
  void _updateWilaya(int wilaya) {
    setState(() => _wilaya = wilaya);
  }

  int _status=1;
  void _updateStatus(int status) {
    setState(() => _status = status);
  }
  String _location="";

  @override
  void initState()  {
    super.initState();
    today = getToday();

  }
  @override
  Future<void> didChangeDependencies() async {
    Position position = await Geolocator .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _location = position.toString();
    });
    if(_location!=null) print(_location);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    Map data = {
      'attendance_date': widget.row_date,
      'status': _status,
      'description': _desc,
      'state': _wilaya,
      'location':_location,
    };

    String body = json.encode(data);
    return AlertDialog(
      title: const Text('Sign!'),
      content: SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WilayaDD(_updateWilaya, 16),
            SizedBox(height: 20,),
            StatusDD(_updateStatus, 1),
            SizedBox(height: 20,),
            TextField(
              onChanged: (text) {
                  _desc= text;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),),
            SizedBox(height: 20,),

          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            Position position = await Geolocator .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            setState(() {
              _location = position.toString();
            });
            if(_location!=null) print(_location);
            //  print(body.toString());
      //       final response = await http
      //          .post(Uri.parse('https://bts-algeria.com/API/api/timesheet/create'),body: body,
      //           headers: {'Authorization': "Bearer "+user.resp.accessToken, 'Content-type': 'application/json',});
      //      if (response.statusCode == 200) {
      //        widget.updateSign(today, _wilaya, _status, _desc);
      //        Fluttertoast.showToast(
      //            msg: "Attendance signed successfully",
      //            toastLength: Toast.LENGTH_SHORT,
      //            gravity: ToastGravity.CENTER,
      //            timeInSecForIosWeb: 3,
      //            backgroundColor: Colors.green,
      //            textColor: Colors.white,
      //            fontSize: 16.0
      //        );
      //        Navigator.pop(context);
      //
      // } else {
      //
      //         print(response.body);
      //         print ('---------------/---------------/------------');
      //
      //         Fluttertoast.showToast(
      //             msg: "Error !!",
      //             toastLength: Toast.LENGTH_SHORT,
      //             gravity: ToastGravity.CENTER,
      //             timeInSecForIosWeb: 3,
      //             backgroundColor: Colors.red,
      //             textColor: Colors.white,
      //             fontSize: 16.0
      //         );
      //         Navigator.pop(context);
      //       }
          },
          child: const Text('Sign'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}


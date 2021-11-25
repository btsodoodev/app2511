import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_regis_provider/domain/user.dart';
import 'package:flutter_login_regis_provider/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ThreeActions extends StatefulWidget {
  final int id;
  final String name;
  final String date;
  final int userId;
  final String statusId;
  final String desc;
  final Function updateApprove;
  final Function updateDiaspprove;
  final Function updateReject;
  ThreeActions( this.id, this.name, this.date,this.userId,this.statusId,this.desc, this.updateApprove , this.updateDiaspprove, this.updateReject);
  @override
  _ThreeActionsState createState() => _ThreeActionsState();
}

class _ThreeActionsState extends State<ThreeActions> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return AlertDialog(
      title: const Text('Actions!'),
      content:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Please select which action you want for '+widget.name+" the activity on "+widget.date+"?"),
          SizedBox(height: 15,),
          Text('Remark: '+widget.desc)
        ],
      ),
      actions: [
        if (widget.statusId!="6")ElevatedButton(
          onPressed: () async {
            final response = await http
                .post(Uri.parse('https://bts-algeria.com/API/api/timesheet/approve/'+widget.id.toString()),
                headers: {'Authorization': "Bearer "+user.resp.accessToken, 'Content-type': 'application/json',});

            if (response.statusCode == 200) {
              print("the resp "+ response.body);
              widget.updateApprove(widget.id);
              Fluttertoast.showToast(
                  msg: "Attendance approved successfully,",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            } else {
              print('fuuuc');
              print(response.body);
              print ('---------------/---------------/------------');
              Fluttertoast.showToast(
                  msg: "error!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            Navigator.pop(context);
          },
          child: const Text('Approve'),
        ),

        if (widget.statusId=="6")ElevatedButton(
          onPressed: () async {
            final response = await http
                .post(Uri.parse('https://bts-algeria.com/API/api/timesheet/disapprove/'+widget.id.toString()),
                headers: {'Authorization': "Bearer "+user.resp.accessToken, 'Content-type': 'application/json',});

            print("--------------------");

            if (response.statusCode == 200) {
              widget.updateDiaspprove(widget.id);
              Fluttertoast.showToast(
                  msg: "Attendance disapproved successfully,",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

            } else {
              print('fuuuc');
              print(response.body);
              print ('---------------/---------------/------------');
              Fluttertoast.showToast(
                  msg: "error!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            Navigator.pop(context);
          },
          child: const Text('Disapprove'),
        ),

        if (widget.statusId!="8")ElevatedButton(
          onPressed: () async {
            final response = await http
                .post(Uri.parse('https://bts-algeria.com/API/api/timesheet/reject/'+widget.id.toString()),
                headers: {'Authorization': "Bearer "+user.resp.accessToken, 'Content-type': 'application/json',});

            print("--------------------");

            if (response.statusCode == 200) {
              widget.updateReject(widget.id);
              print('succccc');
              Fluttertoast.showToast(
                  msg: "Attendance rejected successfully,",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

            } else {
              print('fuuuc');
              print(response.body);
              print ('---------------/---------------/------------');
              Fluttertoast.showToast(
                  msg: "error!!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            Navigator.pop(context);

          },
          child: const Text('Reject'),
        ),
        ElevatedButton(
          onPressed: ()  {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),


      ],
    );
  }
}
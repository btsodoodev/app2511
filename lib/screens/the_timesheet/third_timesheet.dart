import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_regis_provider/domain/maps.dart';
import 'package:flutter_login_regis_provider/domain/times.dart';
import 'package:flutter_login_regis_provider/domain/user.dart';
import 'package:flutter_login_regis_provider/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../coloredStatus.dart';
import '../dropDowns.dart';
import '../timesheet.dart';
import '../updateDialog.dart';
import 'ThreeActions.dart';
import 'buttons.dart';
import '../today/signDialog.dart';
import 'signDialog2.dart';


Future<Times> fetchTimes(String token, int uid, String month) async {
  var date =  DateTime.now();
  if (month ==""){
    month = date.month.toString();
  }
  final response = await http
      .get(Uri.parse('https://bts-algeria.com/API/api/timesheet/u/'+uid.toString()+'/'+date.year.toString()+'/'+month),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer '+token,
    },);
  print(token);
  print("--------------------");
  if (response.statusCode == 200) {
    print(response.body);

    return Times.fromJson(jsonDecode(response.body));
  } else {

    throw Exception('Failed to load album');
  }
}

class Timesheet extends StatefulWidget {
   int id;
  Timesheet([this.id]);
  @override
  State<Timesheet> createState() => _TimesheetState();
}

class _TimesheetState extends State<Timesheet> {
  Future<Times> futureTimes;
  User _user = new User();
  @override
  void dispose() {
      widget.id = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _user = Provider.of<UserProvider>(context).user;
    if (widget.id!=null){
      futureTimes = fetchTimes(_user.resp.accessToken, widget.id, "");
    }else futureTimes = fetchTimes(_user.resp.accessToken, _user.user.first.id, "" );
  }

  void _updateTimesWithMonth(String mnth ){
        setState(() {
          if (widget.id!=null){
            futureTimes = fetchTimes(_user.resp.accessToken, widget.id, mnth);
          }else futureTimes = fetchTimes(_user.resp.accessToken, _user.user.first.id, mnth );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<Times>(
        future: futureTimes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TimesTable(snapshot.data,_updateTimesWithMonth);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return Center(child: const CircularProgressIndicator());
        },
      ),

    );
  }
}

class TimesTable extends StatefulWidget {
  Times times;
  final Function updateMonth2;
  TimesTable(this.times, this.updateMonth2);

  @override
  State<TimesTable> createState() => _TimesTableState();
}

class _TimesTableState extends State<TimesTable> {


  void _updateUpdate(int id, String date,  int status, int state, String desc){
    for (Attendance at in widget.times.attendances){
      if (at.id== id){
        print(at.id.toString()+"===="+id.toString());
        setState(() {
          at.date = date;
          at.workStatusId = status.toString();
          at.stateId = state.toString();
          at.description = desc;});
      }
    }
  }

  void _signUpdate(String date, int state, int status, String desc){
    for (Attendance at in widget.times.attendances){
      if (at.date== date){
        setState(() {
          at.workStatusId = status.toString();
          at.stateId = state.toString();
          at.description = desc;
        at.statusId="9";});
      }
    }
  }

  void _updateApprove(int id, ){
    for (Attendance at in widget.times.attendances){
      if (at.id== id){
        setState(() {
          at.statusId="6";
        });
      }
    }
  }

  void _updateDisapprove(int id, ){
    for (Attendance at in widget.times.attendances){
      if (at.id== id){
        setState(() {
          at.statusId="9";
        });
      }
    }
  }


  void _updateReject(int id, ){
    for (Attendance at in widget.times.attendances){
      if (at.id== id){
        setState(() {
          at.statusId="8";
        });
      }
    }
  }
  int dStatus = 1;
  int dWilaya = 16;

  @override
  void initState() {
    for (Attendance at in widget.times.attendances){
      if (at.stateId!=null){
        dWilaya=int.parse(at.stateId);
      }
      if (at.statusId!=null){
        dStatus=int.parse(at.statusId);
      }


    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    DateTime now = new DateTime.now();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: MonthDD(widget.updateMonth2),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.times.timesUser.name??'NoName', style: TextStyle(fontSize: 20, color: Colors.black54),),
              ),
            ],
          ),

          DataTable(
            showCheckboxColumn: false,
            columnSpacing: 20,
            dataRowHeight: 50,
            columns: const <DataColumn>[
              DataColumn(
                label: Text(
                  'Wilaya',
                ),
              ),
              DataColumn(
                label: Text(
                  'Date',
                ),
              ),
              DataColumn(
                label: Text(
                  'Work Status',
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                ),
              ),

            ],
            rows:  <DataRow>[
             for (Attendance at in widget.times.attendances)
               DataRow(
                 onSelectChanged: (_){
                   if((at.statusId=="9" || at.statusId=="8" ) && at.userId==user.user.first.id.toString())
                           showDialog(context: context,
                          builder: (BuildContext context) {
                           return UpdateDialog(widget.times.timesUser.id, at.date,_updateUpdate, at.id, at.description??'-');},);

                   if(at.statusId=="7" &&  DateTime.parse(at.date).isBefore(now) && at.userId==user.user.first.id.toString() )
                     showDialog(
                       context: context,
                       builder: (BuildContext context) {
                         return SignDialog2( _signUpdate, at.date,dStatus,dWilaya );},);

                   if((at.statusId=="9" || at.statusId=="8" ||  at.statusId=="6" ) && at.userId!=user.user.first.id.toString())
                     showDialog(
                       context: context,
                       builder: (BuildContext context) {
                         return ThreeActions(  at.id ,widget.times.timesUser.name, at.date, int.parse(at.userId), at.statusId,at.description??'-', _updateApprove, _updateDisapprove, _updateReject);
                       },
                     );

                 },

                  cells: <DataCell>[
                    DataCell(Text(states[int.parse(at.stateId?? "0")])),
                    DataCell(Text(at.date.substring(5)?? 'no description')),

                    DataCell(Text(work_statuses[int.parse(at.workStatusId??'69')]??'-')),
                    DataCell(statusColored(int.parse(at.statusId ?? '0')),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}




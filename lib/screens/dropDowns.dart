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




class WilayaDD extends StatefulWidget {
  final Function updateWilaya;
  final int dWilaya;
  WilayaDD(this.updateWilaya, [this.dWilaya]);

  @override
  _WilayaDDState createState() => _WilayaDDState();
}

class _WilayaDDState extends State<WilayaDD> {

  int dropdownValue=16;
  String val= states[16];

  @override
  void initState() {
  if (widget.dWilaya!=null){
    dropdownValue = widget.dWilaya;
    val = states[dropdownValue];
  }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: states
          .map((index, value) {
        return MapEntry(
            index,
            DropdownMenuItem<String>(
              value: value,
              child: Text(states[index]),
            ));
      })
          .values
          .toList(),
      value: val,
      onChanged: (String newValue) {
        if (newValue != null) {
          setState(() {
            val = newValue;
            var usdKey = states.keys.firstWhere(
                    (k) => states[k] == val, orElse: () => null);
            dropdownValue = usdKey;
            print(dropdownValue);
            widget.updateWilaya(dropdownValue);

          });
        }
      },


    );
  }
}

class StatusDD extends StatefulWidget {
  final Function updateStatus;
  final int dStatus;
  StatusDD(this.updateStatus, [this.dStatus]);

  @override
  _StatusDDState createState() => _StatusDDState();
}

class _StatusDDState extends State<StatusDD> {

  int dropdownValue =1;
  String val= work_statuses[1];

  @override
  void initState() {
    if (widget.dStatus!=null){
      dropdownValue = widget.dStatus;
      val = work_statuses[dropdownValue];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      items: work_statuses
          .map((index, value) {
        return MapEntry(
            index,
            DropdownMenuItem<String>(
              value: value,
              child: Text(work_statuses[index]),
            ));
      })
          .values
          .toList(),
      value: val,
      onChanged: (String newValue) {
        if (newValue != null) {
          setState(() {
          val = newValue;
          var usdKey = work_statuses.keys.firstWhere(
                  (k) => work_statuses[k] == val, orElse: () => null);
          dropdownValue = usdKey;
          widget.updateStatus(dropdownValue);
          print(dropdownValue);
          });

        }
      },
    );
  }
}


class MonthDD extends StatefulWidget {
  final Function updateMonth;
 MonthDD(this.updateMonth);

  @override
  _MonthDDState createState() => _MonthDDState();
}

class _MonthDDState extends State<MonthDD> {
  String val = "01";
  int monthIn;
  @override
  void initState() {
    var date =  DateTime.now();
    monthIn = date.month;
    val = months.values.elementAt(monthIn-1);
    print (val);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      iconSize: 50,
      style: TextStyle(fontSize: 30, color: Colors.black54),
      items: months.map((name, value) {
        return MapEntry(
            name,
            DropdownMenuItem<String>(
              value: value,
              child: Text(name),
            ));
      })
          .values
          .toList(),
      value: val,
      onChanged: (String newValue) {
        if (newValue != null) {
          setState(() {
            val = newValue;
           widget.updateMonth(val);

          });
        }
      },


    );
  }
}

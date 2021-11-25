import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_regis_provider/domain/maps.dart';
import 'package:flutter_login_regis_provider/domain/pends.dart';
import 'package:flutter_login_regis_provider/domain/user.dart';
import 'package:flutter_login_regis_provider/providers/user_provider.dart';
import 'coloredStatus.dart';
import 'the_timesheet/ThreeActions.dart';
import 'the_timesheet/buttons.dart';
import 'the_timesheet/third_timesheet.dart';
import 'package:provider/provider.dart';

class PendingTable extends StatefulWidget {
  Pends pend;
  PendingTable(this.pend);

  @override
  State<PendingTable> createState() => _PendingTableState();
}

class _PendingTableState extends State<PendingTable> {


  void _updateReject(int id, ){
    for (Att at in widget.pend.atts){
      if (at.id== id.toString()){
        setState(() {
          at.statusId="8";
        });
      }
    }
  }
  void _updateApprove(int id, ){
    for (Att at in widget.pend.atts){
      if (at.id== id.toString()){
        setState(() {
          at.statusId="6";
        });

      }
    }
  }

  void _updateDisapprove(int id, ){
    for (Att at in widget.pend.atts){
      if (at.id== id.toString()){
        setState(() {
          at.statusId="9";
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
        if (widget.pend.atts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(35.0),
            child: Text("No records Found!", style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.bold),),
          );}
        else return SingleChildScrollView(
            child: DataTable(
              showCheckboxColumn: false,
              columnSpacing: 20,
              dataRowHeight: 50,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Name',
                  ),
                ),
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
                for(Att att in widget.pend.atts)
                  DataRow(
                    onSelectChanged: (_){
                      if((att.statusId=="9" || att.statusId=="8" ||  att.statusId=="6" ) && att.userId!=user.user.first.id.toString())
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ThreeActions( int.parse( att.id) ,att.name, att.date, int.parse(att.userId), att.statusId,att.description??'-', _updateApprove, _updateDisapprove, _updateReject);
                          },
                        );

                    },
                    cells: <DataCell>[
                      DataCell(Text(att.name?? 'no description')),
                      DataCell(Text(states[int.parse(att.stateId?? "0")])),
                      DataCell(Text(att.date.substring(5)?? 'no description')),
                      DataCell(Text(work_statuses[int.parse(att.workStatusId??'69')])),
                      DataCell(statusColored(int.parse(att.statusId ?? '0'))),


                    ],
                  ),
              ],
            ),
          );
        }
  }

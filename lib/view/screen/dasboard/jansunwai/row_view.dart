import 'package:flutter/material.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:mp_mla_up/view/screen/dasboard/jansunwai/department_wise_dasboard.dart';

class RowView extends StatelessWidget {
  int comp_type;
  String display_header;
  String displayheadercode;
  int totalcom;
  int totalpendingall;
  int totaldisposed;
  int totalpending;
  int totaltp;
  int total_atrss;
  int totalunmarked;
  int refetype;

  RowView(
      this.comp_type,
      this.display_header,
      this.displayheadercode,
      this.totalcom,
      this.totalpendingall,
      this.totaldisposed,
      this.totalpending,
      this.totaltp,
      this.total_atrss,
      this.totalunmarked,
      this.refetype);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        nameCallMap(display_header, comp_type, context),
        SizedBox(
          height: 0.7 * SizeConfig.height,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Text('समस्त सन्दर्भ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 1.0 * SizeConfig.height,
                    ),
                    Text(totalcom.toString(),
                        style: TextStyle(
                            fontSize: 1.6 * SizeConfig.height,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text('निस्तारित सन्दर्भ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 1.0 * SizeConfig.height,
                    ),
                    Text(totaldisposed.toString(),
                        style: TextStyle(
                            fontSize: 1.6 * SizeConfig.height,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text('लंबित सन्दर्भ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 1.0 * SizeConfig.height,
                    ),
                    Text(totalpending.toString(),
                        style: TextStyle(
                            fontSize: 1.6 * SizeConfig.height,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

nameCallMap(String displayName, int comp_type, BuildContext context) =>
    Container(
      decoration: BoxDecoration(
        color: Color(0xFF00B681),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.all(1.0 * SizeConfig.height),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(displayName,
                    style: TextStyle(
                        fontSize: 1.7 * SizeConfig.height,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DepartmentWiseDashboard(compType: comp_type),
                      ),
                    );
                  },
                  child: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: Icon(Icons.chevron_right),
                  ),
                )
              ],
            )),
      ),
    );

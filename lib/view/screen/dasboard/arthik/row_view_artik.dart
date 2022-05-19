import 'package:flutter/material.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:mp_mla_up/view/screen/dasboard/arthik/year_wise_dashboard.dart';

class RowViewArtik extends StatelessWidget {
  int rno;
  String officer_name;
  int districtid;
  int total_complaint;
  int total_atrs;
  int total_pending;
  int a_disposed;
  int r_disposed;

  RowViewArtik(
      this.rno,
      this.officer_name,
      this.districtid,
      this.total_complaint,
      this.total_atrs,
      this.total_pending,
      this.a_disposed,
      this.r_disposed);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        nameCallMap(officer_name, total_complaint, total_pending, a_disposed,
            r_disposed, districtid, context),
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
                    Text('स्वीकृत धनराशि',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 1.0 * SizeConfig.height,
                    ),
                    Container(
                        padding: EdgeInsets.only(
                          bottom: 1, // Space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.black87,
                          width: 1.0, // Underline thickness
                        ))),
                        child: GestureDetector(
                          onTap: () {
                            if (a_disposed == 0) {
                              showAlertPopup(context, 'Alert',
                                  'महोदय निस्तारित सन्दर्भ उपलब्ध नहीं हैं |');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => YearWiseDashboard(
                                      a_disposed: a_disposed,
                                      districtid: districtid,
                                      displaytype: "Acccepted"),
                                ),
                              );
                            }
                          },
                          child: Text(a_disposed.toString(),
                              style: TextStyle(
                                  fontSize: 1.6 * SizeConfig.height,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400)),
                        ))
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text('अस्वीकृत धनराशि',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 1.0 * SizeConfig.height,
                    ),
                    Container(
                        padding: EdgeInsets.only(
                          bottom: 1, // Space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.black87,
                          width: 1.0, // Underline thickness
                        ))),
                        child: GestureDetector(
                          onTap: () {
                            if (r_disposed == 0) {
                              showAlertPopup(context, 'Alert',
                                  'महोदय निस्तारित सन्दर्भ उपलब्ध नहीं हैं |');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => YearWiseDashboard(
                                      r_disposed: r_disposed,
                                      districtid: districtid,
                                      displaytype: "Rejected"),
                                ),
                              );
                            }
                          },
                          child: Text(r_disposed.toString(),
                              style: TextStyle(
                                  fontSize: 1.6 * SizeConfig.height,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400)),
                        ))
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text('लंबित आवेदन',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 1.0 * SizeConfig.height,
                    ),
                    Container(
                        padding: EdgeInsets.only(
                          bottom: 1, // Space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.black87,
                          width: 1.0, // Underline thickness
                        ))),
                        child: GestureDetector(
                          onTap: () {
                            if (total_pending == 0) {
                              showAlertPopup(context, 'Alert',
                                  'महोदय निस्तारित सन्दर्भ उपलब्ध नहीं हैं |');
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => YearWiseDashboard(
                                      total_pending: total_pending,
                                      districtid: districtid,
                                      displaytype: "Pending"),
                                ),
                              );
                            }
                          },
                          child: Text(total_pending.toString(),
                              style: TextStyle(
                                  fontSize: 1.6 * SizeConfig.height,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400)),
                        ))
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

/*
nameCallMap(String displayName) => Container(
      decoration: BoxDecoration(
        color: Color(0xFF00B681),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(displayName,
              style: TextStyle(
                  fontSize: 1.6 * SizeConfig.height,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),

        ),
      ),
    );
*/
nameCallMap(String displayName, int total_complaint, int total_pending,
        int a_disposed, r_disposed, int districtid, BuildContext context) =>
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
                /*GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YearWiseDashboard(
                            total_complaint: total_complaint,
                            districtid: districtid
                        ),
                      ),
                    );
                  },
                  child: IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: Icon(Icons.chevron_right),
                  ),
                )*/
              ],
            )),
      ),
    );

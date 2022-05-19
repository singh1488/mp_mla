import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mp_mla_up/utils/uri.dart';
import 'package:mp_mla_up/view/screen/dasboard/jansunwai/complaint_list_dasboard.dart';
import 'package:mp_mla_up/view_model/jansunwai_dashboard_model.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:http/http.dart' as http;

class DepartmentWiseDashboard extends StatefulWidget {
  int compType;

  DepartmentWiseDashboard({Key key, @required this.compType}) : super(key: key);

  @override
  _DepartmentWiseDashboardState createState() =>
      _DepartmentWiseDashboardState(compType: compType);
}

class _DepartmentWiseDashboardState extends State<DepartmentWiseDashboard> {
  int compType;

  _DepartmentWiseDashboardState({Key key, @required this.compType});

  List<IgrsDashboardModel> data;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    getDashboard();
  }

  Future getDashboard() async {
    setState(() {
      visible = true;
    });

    try {
      var url = Uri.parse(
          URI_API().api_url+'get-jansunwai-dashboard/223536?resultfor=2&reftypeid=${compType}');
      final Map<String, String> tokenData = {"api-key": URI_API().api_key};

      var response = await http.get(
        url,
        headers: tokenData,
      );
      var statuscode = response.statusCode;

      if (statuscode == 200) {
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var tagObjs = message['Result'] as List;
        data = tagObjs
            .map((tagJson) => IgrsDashboardModel.fromJson(tagJson))
            .toList();

        setState(() {
          visible = false;
        });
      } else {
        setState(() {
          visible = false;
        });
        showAlertPopup(context, 'Alert',
            'कुछ त्रुटी हुई है कृपया कुछ समय बाद प्रयास करें');
      }
    } catch (e) {
      print(e);
      setState(() {
        visible = false;
      });
      showAlertPopup(
          context, 'Alert', 'कुछ त्रुटी हुई है कृपया कुछ समय बाद प्रयास करें');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'विभागवार संदर्भो का विवरण',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            child: Center(
                child: Padding(
                    padding: EdgeInsets.all(1.8 * SizeConfig.height),
                    child: visible == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                                Expanded(
                                  child: data != null
                                      ? ListView.builder(
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            var item = data[index];
                                            return Card(
                                                color: Colors.grey[100],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          bottom:
                                                              Radius.circular(
                                                                  3.0),
                                                          top: Radius.circular(
                                                              3.0)),
                                                ),
                                                child: RowViewDrillFirst(
                                                    item.comp_type,
                                                    item.display_header,
                                                    item.displayheadercode,
                                                    item.totalcom,
                                                    item.totalpendingall,
                                                    item.totaldisposed,
                                                    item.totalpending,
                                                    item.totaltp,
                                                    item.total_atrss,
                                                    item.totalunmarked,
                                                    item.refetype,
                                                    compType));
                                          },
                                        )
                                      : Center(
                                          child: Column(
                                          children: <Widget>[
                                            Text(
                                                'कुछ त्रुटी होने के कारण डैशबोर्ड लोड नहीं हो पाया हैं |',
                                                style: TextStyle(
                                                    fontSize:
                                                        4 * SizeConfig.width,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            ButtonTheme(
                                              minWidth:
                                                  22.4 * SizeConfig.height,
                                              height: 5.2 * SizeConfig.height,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    getDashboard();
                                                  });
                                                },
                                                child: Text(
                                                    "पुनः डैशबोर्ड लोड करें"),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Colors
                                                      .green, // background
                                                  onPrimary: Colors
                                                      .white, // foreground
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                )
                              ])))));
  }
}

class RowViewDrillFirst extends StatelessWidget {
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
  int compType;

  RowViewDrillFirst(
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
      this.refetype,
      this.compType);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        nameCallMap(display_header, comp_type.toString()),
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
                    GestureDetector(
                      onTap: () {
                        if (totaldisposed == 0) {
                          showAlertPopup(context, 'Alert',
                              'महोदय निस्तारित सन्दर्भ उपलब्ध नहीं हैं |');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComplaintListDashboard(
                                  compType: compType,
                                  displaytype: "Disposed",
                                  dep: displayheadercode,
                                  depName: display_header),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 23,
                        padding: EdgeInsets.only(
                          bottom: 1, // Space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.black87,
                          width: 1.0, // Underline thickness
                        ))),
                        child: Center(
                          child: Text(totaldisposed.toString(),
                              style: TextStyle(
                                  fontSize: 1.6 * SizeConfig.height,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    )
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
                    GestureDetector(
                      onTap: () {
                        if (totalpending == 0) {
                          showAlertPopup(context, 'Alert',
                              'महोदय लंबित सन्दर्भ उपलब्ध नहीं हैं |');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ComplaintListDashboard(
                                  compType: compType,
                                  displaytype: "Pending",
                                  dep: displayheadercode,
                                  depName: display_header),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 23,
                        padding: EdgeInsets.only(
                          bottom: 1, // Space between underline and text
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          color: Colors.black87,
                          width: 1.0, // Underline thickness
                        ))),
                        child: Center(
                          child: Text(totalpending.toString(),
                              style: TextStyle(
                                  fontSize: 1.6 * SizeConfig.height,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    )
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

nameCallMap(String displayName, String rowno) => Container(
      decoration: BoxDecoration(
        color: Color(0xFFD9D7D7),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(0.9 * SizeConfig.height),
          child: Text('(${rowno}) ${displayName}',
              style: TextStyle(
                  fontSize: 1.6 * SizeConfig.height,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );

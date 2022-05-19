import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mp_mla_up/utils/uri.dart';
import 'package:mp_mla_up/view/screen/dasboard/arthik/month_wise_dashboard.dart';
import 'package:mp_mla_up/view_model/arthikmadad_model_year.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:http/http.dart' as http;

class YearWiseDashboard extends StatefulWidget {
  int total_complaint;
  int districtid;
  int a_disposed;
  int r_disposed;
  int total_pending;
  String displaytype;

  YearWiseDashboard(
      {Key key,
      @required this.total_complaint,
      @required this.districtid,
      @required this.a_disposed,
      @required this.r_disposed,
      @required this.total_pending,
      @required this.displaytype})
      : super(key: key);

  @override
  _YearWiseDashboardState createState() => _YearWiseDashboardState(
      total_complaint: total_complaint,
      districtid: districtid,
      a_disposed: a_disposed,
      r_disposed: r_disposed,
      total_pending: total_pending,
      displaytype: displaytype);
}

class _YearWiseDashboardState extends State<YearWiseDashboard> {
  int total_complaint;
  int districtid;
  int a_disposed;
  int r_disposed;
  int total_pending;
  String displaytype;
  String compstatus;

  _YearWiseDashboardState(
      {Key key,
      @required this.total_complaint,
      @required this.districtid,
      @required this.a_disposed,
      @required this.r_disposed,
      @required this.total_pending,
      @required this.displaytype});

  List<ArtikMadadModelYear> data;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    if (displaytype == 'Accepted') {
      compstatus = "FD";
    } else if (displaytype == 'Rejected') {
      compstatus = "FA";
    } else {
      compstatus = "P";
    }
    print("response district = ${districtid}");

    getDashboard();
  }

  Future getDashboard() async {
    setState(() {
      visible = true;
    });

    try {
      var url = Uri.parse(
          URI_API().api_url+'get-relief-dashboard-drill-year/223536?districtid=${districtid}&compstatus=${compstatus}&resultfor=2&compyear=0');
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
            .map((tagJson) => ArtikMadadModelYear.fromJson(tagJson))
            .toList();
        print(data);

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
            'वर्षवार संदर्भो का विवरण',
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
                                                    item.year_id,
                                                    item.year_detail,
                                                    item.total_complaints,
                                                    total_pending,
                                                    a_disposed,
                                                    r_disposed,
                                                    districtid,
                                                    compstatus));
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
  int year_id;
  String year_detail;
  int total_complaints;
  int total_pending;
  int a_disposed;
  int r_disposed;
  int districtid;
  String compstatus;

  RowViewDrillFirst(
      this.year_id,
      this.year_detail,
      this.total_complaints,
      this.total_pending,
      this.a_disposed,
      this.r_disposed,
      this.districtid,
      this.compstatus);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        nameCallMap(year_id.toString()),
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
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 1.0 * SizeConfig.height,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (total_complaints == 0) {
                          showAlertPopup(context, 'Alert',
                              'महोदय निस्तारित सन्दर्भ उपलब्ध नहीं हैं |');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MonthWiseDashboard(
                                  districtid: districtid,
                                  compstatus: compstatus,
                                  compyear: year_id,
                                  year_detail: year_detail),
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
                          child: Text(total_complaints.toString(),
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
            ],
          ),
        ),
      ],
    );
  }
}

nameCallMap(String year_id) => Container(
      decoration: BoxDecoration(
        color: Color(0xFFD9D7D7),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(0.9 * SizeConfig.height),
          child: Text('${year_id}',
              style: TextStyle(
                  fontSize: 1.6 * SizeConfig.height,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );

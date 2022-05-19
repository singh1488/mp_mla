import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mp_mla_up/utils/uri.dart';
import 'package:mp_mla_up/view/screen/dasboard/jansunwai/complaint_application.dart';
import 'package:mp_mla_up/view_model/complaint_list_model.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:http/http.dart' as http;

class ComplaintListDashboard extends StatefulWidget {
  int compType;
  String dep;
  String displaytype;
  String depName;

  ComplaintListDashboard(
      {Key key,
      @required this.compType,
      this.displaytype,
      this.dep,
      this.depName})
      : super(key: key);

  @override
  _ComplaintListDashboardState createState() => _ComplaintListDashboardState(
      compType: compType, displaytype: displaytype, dep: dep, depName: depName);
}

class _ComplaintListDashboardState extends State<ComplaintListDashboard> {
  int compType;
  String displaytype;
  String dep;
  String depName;
  String dispHead;

  _ComplaintListDashboardState(
      {Key key,
      @required this.compType,
      this.displaytype,
      this.dep,
      this.depName});

  List<ComplaintListModel> data;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    if (displaytype == 'Disposed') {
      dispHead = 'निस्तारित';
    } else {
      dispHead = 'लंबित';
    }
    getDashboard();
  }

  Future getDashboard() async {
    setState(() {
      visible = true;
    });

    try {
      var url = Uri.parse(URI_API().api_url +
          'get-jansunwai-dashboard-drill/223536?comptype=${compType}&departmentid=${dep}&displaytype=${displaytype}');

      final Map<String, String> tokenData = {"api-key": URI_API().api_key};

      print(url);

      var response = await http.get(
        url,
        headers: tokenData,
      );
      var statuscode = response.statusCode;

      if (statuscode == 200) {
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var tagObjs = message['Result'] as List;
        data = tagObjs
            .map((tagJson) => ComplaintListModel.fromJson(tagJson))
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
          title: Text(
            '${dispHead} संदर्भो का विवरण',
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
                                Wrap(
                                  children: <Widget>[
                                    Text('विभाग : ${depName}',
                                        style: TextStyle(
                                            fontSize: 1.8 * SizeConfig.height,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.0 * SizeConfig.height,
                                ),
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
                                                child: RowComplaintList(
                                                    item.complaintcode,
                                                    item.complaintcode1,
                                                    item.bfy_name,
                                                    item.bfy_mobile,
                                                    item.refrencedate,
                                                    item.categoryname_u,
                                                    item.targetdate,
                                                    item.status,
                                                    item.mongo_ref_key,
                                                    index,
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

class RowComplaintList extends StatelessWidget {
  int complaintcode;
  int complaintcode1;
  String bfy_name;
  String bfy_mobile;
  String refrencedate;
  String categoryname_u;
  String targetdate;
  String status;
  String mongo_ref_key;
  int index;
  int compType;

  RowComplaintList(
      this.complaintcode,
      this.complaintcode1,
      this.bfy_name,
      this.bfy_mobile,
      this.refrencedate,
      this.categoryname_u,
      this.targetdate,
      this.status,
      this.mongo_ref_key,
      this.index,
      this.compType);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        nameCallMap(complaintcode.toString(), complaintcode, (index + 1),
            compType, context),
        SizedBox(
          height: 0.7 * SizeConfig.height,
        ),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      Text('सन्दर्भ दिनांक : ',
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 0.2 * SizeConfig.height,
                      ),
                      Text(refrencedate,
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  Wrap(
                    children: <Widget>[
                      Text('नियत दिनांक : ',
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 0.2 * SizeConfig.height,
                      ),
                      Text(targetdate,
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    Text('शिकायतकर्ता : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                    Text(bfy_name,
                        style: TextStyle(
                            fontSize: 1.6 * SizeConfig.height,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),
              Row(
                children: [
                  Wrap(
                    children: <Widget>[
                      Text('मोबाइल नम्बर : ',
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      Text(bfy_mobile,
                          style: TextStyle(
                              fontSize: 1.6 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),
              Row(
                children: [
                  Wrap(
                    children: <Widget>[
                      Text('शिकायत की स्थिति : ',
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      Text(status,
                          style: TextStyle(
                              fontSize: 1.6 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

nameCallMap(String displayName, int comp_type, int rowno, int compType,
        BuildContext context) =>
    Container(
      decoration: BoxDecoration(
        color: Color(0xFF00B681),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.all(0.9 * SizeConfig.height),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('(${rowno}) ${displayName}',
                    style: TextStyle(
                        fontSize: 1.6 * SizeConfig.height,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComplaintDetailJansunwai(
                            complaintCode: comp_type, compType: compType),
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

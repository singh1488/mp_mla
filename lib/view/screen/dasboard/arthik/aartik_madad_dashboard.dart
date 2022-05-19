import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mp_mla_up/view_model/artikmadad_model.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import '../../../../utils/uri.dart';
import 'row_view_artik.dart';

class ArthikMadadDashboard extends StatefulWidget {
  @override
  _ArthikMadadDashboardState createState() => _ArthikMadadDashboardState();
}

class _ArthikMadadDashboardState extends State<ArthikMadadDashboard> {

  List<ArtikMadadModel> data;
  bool visible = true;
  int totalcomplaint = 0;
  int totaldispose_a = 0;
  int totaldispose_r = 0;
  int totalpanding = 0;
  //String userId = Constants.prefs.getString("userId");

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
          URI_API().api_url+'get-relif-dashboard/223536?resultfor=2&districtid=0');
      final Map<String, String> tokenData = {"api-key": URI_API().api_key};

      var response = await http.get(
        url,
        headers: tokenData,
      );
      var statuscode = response.statusCode;

      if (statuscode == 200) {
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var tagObjs = message['Result'] as List;
        data = tagObjs.map((tagJson) => ArtikMadadModel.fromJson(tagJson)).toList();

        data.forEach((ArtikMadadModel d) {
          totalcomplaint = totalcomplaint + d.total_complaint;
          totaldispose_a = totaldispose_a + d.a_disposed;
          totaldispose_r = totaldispose_r + d.r_disposed;
          totalpanding = totalpanding + d.total_pending;
        });

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
      body: Container(
        child: Center(
          child: Padding(
              padding: EdgeInsets.all(1.8 * SizeConfig.height),
              child: visible == true ?
              Center(
                child: CircularProgressIndicator(),
              )
              : Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Card(
                              color: Colors.white.withOpacity(0.8),
                              child: Row(
                                children: <Widget>[
                                  TotalComplaintBox(),
                                  SizedBox(
                                    width: 2.2 * SizeConfig.width,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text('समस्त आवेदन',
                                            style: TextStyle(
                                                fontSize:
                                                1.5 * SizeConfig.height,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green)),
                                      ),
                                      SizedBox(
                                        height: 1.0 * SizeConfig.height,
                                      ),
                                      Center(
                                        child: Text(totalcomplaint.toString(),
                                            style: TextStyle(
                                                fontSize:   1.5 * SizeConfig.height,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Card(
                              color: Colors.white.withOpacity(0.8),
                              child: Row(
                                children: <Widget>[
                                  PendingComplaintBox(),
                                  SizedBox(
                                    width: 2.2 * SizeConfig.width,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text('लंबित आवेदन',
                                            style: TextStyle(
                                                fontSize:
                                                1.5 * SizeConfig.height,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orangeAccent)),
                                      ),
                                      SizedBox(
                                        height: 1.0 * SizeConfig.height,
                                      ),
                                      Center(
                                        child: Text(totalpanding.toString(),
                                            style: TextStyle(
                                                fontSize:   1.5 * SizeConfig.height,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Card(
                              color: Colors.white.withOpacity(0.8),
                              child: Row(
                                children: <Widget>[
                                  DisposeComplaintBox(),
                                  SizedBox(
                                    width: 2.2 * SizeConfig.width,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text('स्वीकृत धनराशि',
                                            style: TextStyle(
                                                fontSize:
                                                1.5 * SizeConfig.height,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green)),
                                      ),
                                      SizedBox(
                                        height: 1.0 * SizeConfig.height,
                                      ),
                                      Center(
                                        child: Text(totaldispose_a.toString(),
                                            style: TextStyle(
                                                fontSize:  1.5 * SizeConfig.height,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Card(
                              color: Colors.white.withOpacity(0.8),
                              child: Row(
                                children: <Widget>[
                                  RejectComplaintBox(),
                                  SizedBox(
                                    width: 2.2 * SizeConfig.width,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text('अस्वीकृत धनराशि',
                                            style: TextStyle(
                                                fontSize:
                                                1.5 * SizeConfig.height,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.redAccent)),
                                      ),
                                      SizedBox(
                                        height: 1.0 * SizeConfig.height,
                                      ),
                                      Center(
                                        child: Text(totaldispose_r.toString(),
                                            style: TextStyle(
                                                fontSize:   1.5 * SizeConfig.height,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.7 * SizeConfig.height,
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
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(3.0),
                                        top: Radius.circular(3.0)),
                                  ),
                                  child: RowViewArtik(
                                      item.rno,
                                      item.officer_name,
                                      item.districtid,
                                      item.total_complaint,
                                      item.total_atrs,
                                      item.total_pending,
                                      item.a_disposed,
                                      item.r_disposed
                                      )
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              children: <Widget>[
                                Text('कुछ त्रुटी होने के कारण डैशबोर्ड लोड नहीं हो पाया हैं |',
                                    style: TextStyle(
                                        fontSize: 4 * SizeConfig.width,
                                        fontWeight: FontWeight.bold)),

                                ButtonTheme(
                                  minWidth: 22.4 * SizeConfig.height,
                                  height: 5.2 * SizeConfig.height,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        getDashboard();
                                      });
                                    },
                                    child: Text("पुनः डैशबोर्ड लोड करें"),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green, // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class TotalComplaintBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15 * SizeConfig.width,
      height: 15 * SizeConfig.width,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
      ),
      child: Center(
        child: Icon(
          Icons.add_business,
          color: Colors.white,
          size: 8 * SizeConfig.width,
        ),
      ),
    );
  }
}

class PendingComplaintBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15 * SizeConfig.width,
      height: 15 * SizeConfig.width,
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
      ),
      child: Center(
        child: Icon(
          Icons.archive_outlined,
          color: Colors.white,
          size: 8 * SizeConfig.width,
        ),
      ),
    );
  }
}

class DisposeComplaintBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15 * SizeConfig.width,
      height: 15 * SizeConfig.width,
      decoration: BoxDecoration(
        color: Colors.green,
      ),
      child: Center(
        child: Icon(
          Icons.approval,
          color: Colors.white,
          size: 8 * SizeConfig.width,
        ),
      ),
    );
  }
}

class RejectComplaintBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15 * SizeConfig.width,
      height: 15 * SizeConfig.width,
      decoration: BoxDecoration(
        color: Colors.redAccent,
      ),
      child: Center(
        child: Icon(
          Icons.backspace,
          color: Colors.white,
          size: 8 * SizeConfig.width,
        ),
      ),
    );
  }
}

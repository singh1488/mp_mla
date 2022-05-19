import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:mp_mla_up/view_model/arthik_complaint_detail_model.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:mp_mla_up/utils/constants.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/uri.dart';

class ComplaintDetailArthik extends StatefulWidget {
  int districtid;
  String compstatus;
  int compyear;
  int compmonth;
  String month_detail;

  ComplaintDetailArthik(
      {Key key,
      @required this.districtid,
      @required this.compstatus,
      @required this.compyear,
      @required this.compmonth,
      @required this.month_detail})
      : super(key: key);

  @override
  _ComplaintDetailArthikState createState() => _ComplaintDetailArthikState(
      districtid: districtid,
      compstatus: compstatus,
      compyear: compyear,
      compmonth: compmonth,
      month_detail: month_detail);
}

class _ComplaintDetailArthikState extends State<ComplaintDetailArthik> {
  int districtid;
  String compstatus;
  int compyear;
  int compmonth;
  String month_detail;
  int compType;
  String mongo_key;
  SharedPreferences sp;

  String pathPDF = "";
  String landscapePathPdf = "";
  String remotePDFpath = "";
  String corruptedPathPDF = "";

  _ComplaintDetailArthikState(
      {Key key,
      @required this.districtid,
      @required this.compstatus,
      @required this.compyear,
      @required this.compmonth,
      @required this.month_detail});

  List<ArthikComplaintDetailModel> data;
  bool visible = true;

  @override
  void initState() {
    super.initState();
    getDashboard();
  }

  Future getDashboard() async {
    /*setState(() {
      visible = true;
    });*/
    if (this.mounted) {
      setState(() {
        visible = true;
      });
    }

    try {
      print('success11');
      var url = Uri.parse(
          URI_API().api_url+'get-relief-dashboard-drill-compdtl/223536?districtid=${districtid}&compstatus=${compstatus}&compyear=${compyear}&compmonth=${compmonth}');
      final Map<String, String> tokenData = {"api-key": URI_API().api_key};
      print('success22');
      var response = await http.get(
        url,
        headers: tokenData,
      );
      var statuscode = response.statusCode;
      print(statuscode);

      if (statuscode == 200) {
        print('success33');
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var tagObjs = message['Result'] as List;
        data = tagObjs
            .map((tagJson) => ArthikComplaintDetailModel.fromJson(tagJson))
            .toList();

        Constants.prefs.setString("r_mongo_ref_key", data[0].mongo_ref_key);
        sp = await SharedPreferences.getInstance();
        mongo_key = sp.getString('r_mongo_ref_key');
        print(mongo_key);

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

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    try {
      final uri = Uri.parse(
          URI_API().api_url+'get-doc/14/id/${mongo_key}');
      final headers = {'api-key': URI_API().api_key};
      var response = await http.get(
        uri,
        headers: headers,
      );

      var statuscode = response.statusCode;
      var bytes = response.bodyBytes;
      var dox = response.headers["content-type"];

      if (statuscode == 200) {
        final fileName = "flutterpdf.pdf";
        var dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/$fileName");
        await file.writeAsBytes(bytes, flush: true);
        completer.complete(file);
      }
    } catch (e) {
      throw Exception('Error downloading pdf file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: const Text(
            'सन्दर्भ का विवरण',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
            padding: EdgeInsets.all(1.1 * SizeConfig.height),
            child: visible == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : data != null
                    ? SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Card(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(3.0),
                                      top: Radius.circular(3.0)),
                                ),
                                child: ComplaintStatus(data)),
                            Card(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(3.0),
                                      top: Radius.circular(3.0)),
                                ),
                                child: ComplaintDetailsFirst(data)),
                            Card(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(3.0),
                                      top: Radius.circular(3.0)),
                                ),
                                child: ComplaintDetailsSecond(data)),
                            Card(
                                color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(3.0),
                                      top: Radius.circular(3.0)),
                                ),
                                child: ComplaintDetailsThird(data)),
                            Card(
                              color: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(3.0),
                                    top: Radius.circular(3.0)),
                              ),
                              /*child: ComplaintDetailsFourth(
                          data)*/
                            ),
                            Card(
                              color: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(3.0),
                                    top: Radius.circular(3.0)),
                              ),
                              /*child: ComplaintDetailsFive(
                          data)*/
                            ),
                            Card(
                              color: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(3.0),
                                    top: Radius.circular(3.0)),
                              ),
                              child: new Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    createFileOfPdfUrl().then((f) {
                                      setState(() {
                                        remotePDFpath = f.path;

                                        if (remotePDFpath.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PDFScreen(
                                                  path: remotePDFpath),
                                            ),
                                          );
                                        }
                                      });
                                    });
                                  },
                                  label: const Text('View Application'),
                                  icon: const Icon(Icons.folder),
                                ),
                              ), //child: ComplaintDetailsSix()),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Column(
                        children: <Widget>[
                          Text(
                              'कुछ त्रुटी होने के कारण डैशबोर्ड लोड नहीं हो पाया हैं |',
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
                      ))));
  }
}

//शिकायत की स्थिति
class ComplaintStatus extends StatelessWidget {
  List<ArthikComplaintDetailModel> data;

  ComplaintStatus(this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF00B681),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(0.9 * SizeConfig.height),
                child: Text('सन्दर्भ की स्थिति:',
                    style: TextStyle(
                        fontSize: 1.6 * SizeConfig.height,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
          ),
        ),
        SizedBox(
          height: 0.1 * SizeConfig.height,
        ),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Wrap(
                children: <Widget>[
                  if (data[0].comp_status == 'A')
                    //Html(data:data[0].comp_status,
                    Html(data: 'निस्तारित'),
                  if (data[0].comp_status == 'FA') Html(data: 'निस्तारित'),
                  if (data[0].comp_status == 'P') Html(data: 'लंबित'),
                  if (data[0].comp_status == 'ATRS')
                    Html(data: 'अनुमोदन हेतु लंबित'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//सन्दर्भ का विवरण
class ComplaintDetailsFirst extends StatelessWidget {
  List<ArthikComplaintDetailModel> data;

  ComplaintDetailsFirst(this.data);

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF00B681),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(0.9 * SizeConfig.height),
                child: Text('आवेदन पत्र का विवरण:',
                    style: TextStyle(
                        fontSize: 1.6 * SizeConfig.height,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
          ),
        ),
        SizedBox(
          height: 0.1 * SizeConfig.height,
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
                      Text('सन्दर्भ संख्या : ',
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 0.2 * SizeConfig.height,
                      ),
                      Text(data[0].complaint_code.toString(),
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      Text('आवेदन का प्रकार : ',
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 0.2 * SizeConfig.height,
                      ),
                      Text(data[0].markingtype,
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
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: c_width,
                    child: Wrap(
                      children: <Widget>[
                        Text('संदर्भ दिनांक : ',
                            style: TextStyle(
                                fontSize: 1.5 * SizeConfig.height,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 0.2 * SizeConfig.height,
                        ),
                        Text(data[0].created_date,
                            style: TextStyle(
                                fontSize: 1.5 * SizeConfig.height,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: c_width,
                    child: Wrap(
                      children: <Widget>[
                        Text('अधिकारी : ',
                            style: TextStyle(
                                fontSize: 1.5 * SizeConfig.height,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 0.2 * SizeConfig.height,
                        ),
                        Text(data[0].officer_name,
                            style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
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
                    Text('विभाग : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                    Text(data[0].department_name,
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
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'सन्दर्भ श्रेणी : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: data[0].category_name,
                              style: TextStyle(
                                  fontSize: 1.6 * SizeConfig.height,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'आवेदन पत्र का विवरण : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: data[0].app_details,
                              style: TextStyle(
                                  fontSize: 1.6 * SizeConfig.height,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
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

//आवेदनकर्ता का विवरण
class ComplaintDetailsSecond extends StatelessWidget {
  List<ArthikComplaintDetailModel> data;

  ComplaintDetailsSecond(this.data);

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF00B681),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(0.9 * SizeConfig.height),
                child: Text('आवेदक का विवरण:',
                    style: TextStyle(
                        fontSize: 1.6 * SizeConfig.height,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
          ),
        ),
        SizedBox(
          height: 0.1 * SizeConfig.height,
        ),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: c_width,
                    child: Wrap(
                      children: <Widget>[
                        Text('मोबाइल न. : ',
                            style: TextStyle(
                                fontSize: 1.5 * SizeConfig.height,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 0.2 * SizeConfig.height,
                        ),
                        Text(data[0].bfy_mobile,
                            style: TextStyle(
                                fontSize: 1.5 * SizeConfig.height,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: c_width,
                    child: Wrap(
                      children: <Widget>[
                        Text('आवेदक का विवरण: ',
                            style: TextStyle(
                                fontSize: 1.5 * SizeConfig.height,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 0.2 * SizeConfig.height,
                        ),
                        Text(data[0].bfy_details,
                            style: TextStyle(
                                fontSize: 1.5 * SizeConfig.height,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),

              /*  Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    Text('संसुतिकर्ता  : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                    Text(data[0].recomm_details,
                        style: TextStyle(
                            fontSize: 1.6 * SizeConfig.height,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),*/

              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),

              /*Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    Text('पिता का नाम : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                    Text(data[0].r_bfy_fname,
                        style: TextStyle(
                            fontSize: 1.6 * SizeConfig.height,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
              ),*/

              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),

              /*Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'पता : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: data[0].r_bfy_address, style: TextStyle(
                              fontSize: 1.6 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ],
    );
  }
}

//संस्तुतिकर्ता का विवरण:
class ComplaintDetailsThird extends StatelessWidget {
  List<ArthikComplaintDetailModel> data;

  ComplaintDetailsThird(this.data);

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF00B681),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(0.9 * SizeConfig.height),
                child: Text('संस्तुतिकर्ता का विवरण:',
                    style: TextStyle(
                        fontSize: 1.6 * SizeConfig.height,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
          ),
        ),
        SizedBox(
          height: 0.1 * SizeConfig.height,
        ),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: c_width,
                    child: Wrap(
                      children: <Widget>[
                        Text('पद : ',
                            style: TextStyle(
                                fontSize: 1.5 * SizeConfig.height,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 0.2 * SizeConfig.height,
                        ),
                        Text(data[0].recomm_details,
                            style: TextStyle(
                                fontSize: 1.5 * SizeConfig.height,
                                color: Colors.black87,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),
/*
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    Text('नाम : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                    Text(data[0].r_recommname,
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
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'संस्तुतिकर्ता का विवरण : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: data[0].r_recommdetails, style: TextStyle(
                              fontSize: 1.6 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
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
                      Text('ई-मेल : ',
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      Text(data[0].r_recommemail,
                          style: TextStyle(
                              fontSize: 1.6 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                ],
              )*/
            ],
          ),
        ),
      ],
    );
  }
}

//आवेदक द्वारा दिया गया फीडबैक:
class ComplaintDetailsFourth extends StatelessWidget {
  List<ArthikComplaintDetailModel> data;

  ComplaintDetailsFourth(this.data);

  @override
  Widget build(BuildContext context) {
    return data[0].d_flag == 'Y'
        ? Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF13232),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.all(0.9 * SizeConfig.height),
                      child: Text('Document:',
                          style: TextStyle(
                              fontSize: 1.6 * SizeConfig.height,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ),
              ),
              SizedBox(
                height: 0.1 * SizeConfig.height,
              ),
              /*Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      Text('स्थिति : ',
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 0.2 * SizeConfig.height,
                      ),

                      Text(data[0].r_feedbackstatus_public,
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),

                    ],
                  ),

                  Wrap(
                    children: <Widget>[
                      Text('दिनांक : ',
                          style: TextStyle(
                              fontSize: 1.5 * SizeConfig.height,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height:0.2 * SizeConfig.height,
                      ),

                      Text(data[0].r_feedback_date,
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
                    RichText(
                      text: TextSpan(
                        text: 'फीडबैक : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: data[0].r_feedback, style: TextStyle(
                              fontSize: 1.6 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),*/
            ],
          )
        : Center(
            child: null,
          );
  }
}

//फीडबैक पर कार्यवाही
/*
class ComplaintDetailsFive extends StatelessWidget {
  List<ArthikComplaintDetailModel> data;

  ComplaintDetailsFive(this.data);

  @override
  Widget build(BuildContext context) {
    return  data[0].r_feedbackstatusnew != '' ? Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF13232),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.all(0.9 * SizeConfig.height),
                child: Text('फीडबैक पर कार्यवाही:',
                    style: TextStyle(
                        fontSize: 1.6 * SizeConfig.height,
                        color: Colors.white,
                        fontWeight: FontWeight.bold))),
          ),
        ),
        SizedBox(
          height: 0.1 * SizeConfig.height,
        ),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    Text('कार्यवाही दिनांक : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height:0.2 * SizeConfig.height,
                    ),
                    Text(data[0].r_feedbackdate,
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400)),

                  ],
                ),
              ),

              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'कार्यवाही : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: data[0].r_feedbackstatusnew, style: TextStyle(
                              fontSize: 1.6 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 0.7 * SizeConfig.height,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'टिप्पणी : ',
                        style: TextStyle(
                            fontSize: 1.5 * SizeConfig.height,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(text: data[0].r_feedbackremark, style: TextStyle(
                              fontSize: 1.6 * SizeConfig.height,
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ): Center( child: null,);
  }
}*/

class PDFScreen extends StatefulWidget {
  final String path;

  PDFScreen({Key key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages ~/ 2}"),
              onPressed: () async {
                await snapshot.data.setPage(pages ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}

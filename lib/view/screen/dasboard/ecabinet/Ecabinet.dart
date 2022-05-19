import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mp_mla_up/view/screen/dasboard/ecabinet/row_view_current_meeting.dart';
import '../../../../utils/alertbox.dart';
import '../../../../utils/size_config.dart';
import '../../../../utils/uri.dart';
import '../../../../view_model/ecabinet_allmad_model.dart';

class Ecabinet extends StatefulWidget {
  @override
  State<Ecabinet> createState() => _EcabinetState();
}

class _EcabinetState extends State<Ecabinet> {
  List<EcabinetAllMadModel> data;
  bool visible = true;
  String meetingNo = "";

  @override
  void initState() {
    super.initState();
    getAllMad();
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);*/
  }

  Future getAllMad() async {
    if (this.mounted) {
      setState(() {
        visible = true;
      });
    }

    try {
      var url = Uri.parse(URI_API().api_url_ecabinet +
          'getAllMad?departmentId=anil.rajbhar@gov.in');

      var response = await http.get(
        url,
      );
      var statuscode = response.statusCode;

      if (statuscode == 200) {
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var tagObjs = message['Result'] as List;
        data = tagObjs
            .map((tagJson) => EcabinetAllMadModel.fromJson(tagJson))
            .toList();

        meetingNo = data[0].meetingcode;

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
    return Scaffold(body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return _buildNormalContainer();
        } else {
          return _buildNormalContainer();
        }
      },
    ));
  }

  Widget _buildNormalContainer() {
    return Container(
      child: visible == true
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Wrap(
            children: [
              Card(
                color: Colors.white.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(1.5 * SizeConfig.height),
                      child: Text('बैठक संख्या ${meetingNo} की मदें',
                          style: TextStyle(
                              fontSize: 1.8 * SizeConfig.height,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: data != null
                ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                var item = data[index];
                return Center(
                  child: RowViewCurrentMeeting(
                      item.displayOrderNo,
                      item.meetingcode,
                      item.agendatypeid,
                      item.itemComputerNo,
                      item.deptName,
                      item.subjectName,
                      item.subject,
                      item.itemDetails,
                      item.ministercode,
                      item.filenumber),
                );
              },
            )
                : Center(
              child: Text(
                  'खेद है | इस समय किसी भी बैठक की कार्यावली उपलब्ध नहीं है , कृपया कुछ समय बाद देखें या गोपन विभाग से सम्पर्क करें |',
                  style: TextStyle(
                      fontSize: 4 * SizeConfig.width,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWideContainers() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            color: Colors.red,
          ),
          Container(
            height: 100.0,
            width: 100.0,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    /*  SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    super.dispose();
  }
}

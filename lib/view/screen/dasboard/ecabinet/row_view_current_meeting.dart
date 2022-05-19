import 'package:flutter/material.dart';
import 'package:mp_mla_up/view/screen/dasboard/ecabinet/view_document.dart';

import '../../../../utils/size_config.dart';

class RowViewCurrentMeeting extends StatelessWidget {
  String displayOrderNo;
  String meetingcode;
  String agendatypeid;
  String itemComputerNo;
  String deptName;
  String subjectName;
  String subject;
  String itemDetails;
  String ministercode;
  String filenumber;

  RowViewCurrentMeeting(
      this.displayOrderNo,
      this.meetingcode,
      this.agendatypeid,
      this.itemComputerNo,
      this.deptName,
      this.subjectName,
      this.subject,
      this.itemDetails,
      this.ministercode,
      this.filenumber);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: const Color(0xffFFff5722), width: 1.0)),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFFff5722),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: 0.5 * SizeConfig.height),
                                child: Text('मद क्रमांक',
                                    style: TextStyle(
                                        fontSize: 1.5 * SizeConfig.height,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 0.5 * SizeConfig.height),
                                child: Text(displayOrderNo,
                                    style: TextStyle(
                                        fontSize: 1.8 * SizeConfig.height,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 0.5 * SizeConfig.height),
                                child: Text(
                                  deptName,
                                  style: TextStyle(
                                      fontSize: 1.4 * SizeConfig.height,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(subjectName,
                                  style: TextStyle(
                                      fontSize: 1.4 * SizeConfig.height,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 0.5 * SizeConfig.height),
                              child: Text(subject,
                                  style: TextStyle(
                                      fontSize: 1.4 * SizeConfig.height,
                                      color: Colors.black)),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 0.5 * SizeConfig.height),
                              child: Text("फाइल संख्या  ${filenumber}",
                                  style: TextStyle(
                                      fontSize: 1.6 * SizeConfig.height,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  textAlign: TextAlign.start),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewDocumentEcabinet(
                                          mettingCode: meetingcode,
                                          agendaId: agendatypeid,
                                          computerNo: itemComputerNo,
                                          itemDetails: filenumber,
                                          departmentName: deptName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: IconTheme(
                                    data: IconThemeData(
                                        color: const Color(0xffFFff5722),
                                        size: 8 * SizeConfig.width),
                                    child:
                                        Icon(Icons.arrow_circle_right_outlined),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

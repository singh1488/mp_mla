import 'package:flutter/material.dart';
import 'package:mp_mla_up/view/screen/dasboard/ecabinet/Ecabinet.dart';
import 'package:mp_mla_up/view/screen/dasboard/ecabinet/Notice.dart';
import '../../../../view_model/ecabinet_allmad_model.dart';
import '../navigation_drawer.dart';

class EcabinetMain extends StatefulWidget {
  @override
  State<EcabinetMain> createState() => _EcabinetMainState();
}

class _EcabinetMainState extends State<EcabinetMain> {
  List<EcabinetAllMadModel> data;
  String meetingNo = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('आगामी बैठक हेतु नोटिस',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Tab(
                child: Text('वर्तमान बैठक',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          title: Center(
            child: const Text(
              'ई-कैबिनेट, उत्तर प्रदेश',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        body: TabBarView(
          children: [
            Notice(),
            Ecabinet(),
          ],
        ),

      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

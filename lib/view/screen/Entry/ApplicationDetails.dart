import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:mp_mla_up/view/screen/Entry/FinancialAid.dart';
import 'package:mp_mla_up/view_model/get_district.dart';
import 'package:mp_mla_up/view_model/get_block.dart';
import 'package:mp_mla_up/view_model/get_village_panchayat.dart';
import 'package:mp_mla_up/view_model/get_rajasva_gram.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:mp_mla_up/utils/uri.dart';
import 'package:mp_mla_up/view_model/get_tehsil.dart';
import 'package:mp_mla_up/view_model/get_ward.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ApplicationDetails extends StatefulWidget {
  String applicant_name;
  String beneficiary_name;
  String relation;
  String father_name;
  String adhar;
  String age;
  String mobile_one;
  String mobile_two;
  String selectedGender;

  ApplicationDetails(
      {Key key,
      @required this.applicant_name,
      @required this.beneficiary_name,
      @required this.relation,
      @required this.father_name,
      @required this.adhar,
      @required this.age,
      @required this.mobile_one,
      @required this.mobile_two,
      @required this.selectedGender})
      : super(key: key);

  @override
  _ApplicationDetailsState createState() => _ApplicationDetailsState(
        applicant_name: applicant_name,
        beneficiary_name: beneficiary_name,
        relation: relation,
        father_name: father_name,
        adhar: adhar,
        age: age,
        mobile_one: mobile_one,
        mobile_two: mobile_two,
        selectedGender: selectedGender,
      );
}

class _ApplicationDetailsState extends State<ApplicationDetails> {
  List<DropdownMenuItem<District>> _dropdownMenuDistrict;
  District _selectedDistrict;

  List<DropdownMenuItem<Tehsil>> _dropdownMenuTehsil;
  Tehsil _selectedTehsil;

  List<DropdownMenuItem<Block>> _dropdownMenuBlock;
  Block _selectedBlock;

  List<DropdownMenuItem<VillagePanchayat>> _dropdownMenuVillagePanchayat;
  VillagePanchayat _selectedVillagePanchayat;

  List<DropdownMenuItem<RajasvaGram>> _dropdownMenuRajasvaGram;
  RajasvaGram _selectedRajasvaGram;

  List<DropdownMenuItem<Block>> _dropdownMenuNagar;
  Block _selectedNagar;

  List<DropdownMenuItem<Ward>> _dropdownMenuWard;
  Ward _selectedWard;

  String applicant_name;
  String beneficiary_name;
  String relation;
  String father_name;
  String adhar;
  String age;
  String mobile_one;
  String mobile_two;
  String selectedGender;
  String beneficiary_areaId = "0";

  String distId = "0",
      tehsilId = "0",
      blockId = "0",
      panchayatId = "0",
      rajasvaId = "0",
      nagarId = "0",
      wardId = "0";

  String distText = "",
      tehsilText = "",
      blockText = "",
      panchayatText = "",
      rajasvaText = "",
      nagarText = "",
      wardText = "";

  TextEditingController beneficiary_address = TextEditingController();

  _ApplicationDetailsState(
      {Key key,
      @required this.applicant_name,
      @required this.beneficiary_name,
      @required this.relation,
      @required this.father_name,
      @required this.adhar,
      @required this.age,
      @required this.mobile_one,
      @required this.mobile_two,
      @required this.selectedGender});

  bool visible = true;
  bool visibleNagar = false;
  bool isChecked = false;
  ProgressDialog pr;

  void initState() {
    super.initState();
    visible = true;
    visibleNagar = false;
    getDistrict();
  }

  Future getDistrict() async {
    try {
      var url = Uri.parse(
          URI_API().api_url + 'get-district?state=9&level=0&department=0');

      var response = await http.get(
        url,
        headers: URI_API().tokenData,
      );
      var statuscode = response.statusCode;
      if (statuscode == 200) {
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<District> dist = list.map((i) => District.fromJson(i)).toList();

        List data = []; //edited line
        setState(() {
          _dropdownMenuDistrict = buildDropDownMenuDistrict(dist);
          //_selectedDistrict = _dropdownMenuDistrict[0].value;
        });
      } else {
        showAlertPopup(context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<District>> buildDropDownMenuDistrict(
      List listDistrict) {
    List<DropdownMenuItem<District>> items = [];

    for (District listItem in listDistrict) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.r_valuetext),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future getTehsil() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    pr.update(
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    await pr.show();
    try {
      var url = Uri.parse(URI_API().api_url +
          'thana-tehsil-block-district-wise?district=$distId&cmdtype=1&tehsil=0');
      var response = await http.get(
        url,
        headers: URI_API().tokenData,
      );

      var statuscode = response.statusCode;

      if (statuscode != 200) {
        await pr.hide();
        showAlertPopup(context, 'Alert', 'Error!! Please try again later');
      } else if (statuscode == 200) {
        await pr.hide();

        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<Tehsil> tehsil = list.map((i) => Tehsil.fromJson(i)).toList();

        List data = []; //edited line
        setState(() {
          _dropdownMenuTehsil = builddropdownMenuTehsil(tehsil);
        });
      } else {
        showAlertPopup(context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<Tehsil>> builddropdownMenuTehsil(List listTehsil) {
    List<DropdownMenuItem<Tehsil>> items = [];
    for (Tehsil listTehsil in listTehsil) {
      items.add(
        DropdownMenuItem(
          child: Text(listTehsil.r_valuetext_h),
          value: listTehsil,
        ),
      );
    }
    return items;
  }

  Future getBlock() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    pr.update(
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    await pr.show();
    try {
      var url = Uri.parse(URI_API().api_url +
          'thana-tehsil-block-district-wise?district=$distId&cmdtype=2&tehsil=$tehsilId');
      var response = await http.get(
        url,
        headers: URI_API().tokenData,
      );
      var statuscode = response.statusCode;

      if (statuscode != 200) {
        await pr.hide();
        showAlertPopup(context, 'Alert', 'Error!! Please try again later');
      } else if (statuscode == 200) {
        await pr.hide();

        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<Block> block = list.map((i) => Block.fromJson(i)).toList();

        List data = []; //edited line
        setState(() {
          _dropdownMenuBlock = builddropdownMenuBlock(block);
        });
      } else {
        showAlertPopup(context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<Block>> builddropdownMenuBlock(List listBlock) {
    List<DropdownMenuItem<Block>> items = [];
    for (Block listBlock in listBlock) {
      items.add(
        DropdownMenuItem(
          child: Text(listBlock.r_valuetext_h),
          value: listBlock,
        ),
      );
    }
    return items;
  }

  Future getNagarPalika() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    pr.update(
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    await pr.show();
    try {
      var url = Uri.parse(URI_API().api_url +
          'thana-tehsil-block-district-wise?district=$distId&cmdtype=5&tehsil=$tehsilId');
      var response = await http.get(
        url,
        headers: URI_API().tokenData,
      );
      var statuscode = response.statusCode;

      if (statuscode != 200) {
        await pr.hide();

        await pr.hide();
        showAlertPopup(context, 'Alert', 'Error!! Please try again later');
      } else if (statuscode == 200) {
        await pr.hide();

        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<Block> block = list.map((i) => Block.fromJson(i)).toList();

        List data = []; //edited line
        setState(() {
          _dropdownMenuNagar = builddropdownMenuNagar(block);
        });
      } else {
        showAlertPopup(context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<Block>> builddropdownMenuNagar(List listBlock) {
    List<DropdownMenuItem<Block>> items = [];
    for (Block listBlock in listBlock) {
      items.add(
        DropdownMenuItem(
          child: Text(listBlock.r_valuetext_h),
          value: listBlock,
        ),
      );
    }
    return items;
  }

  Future getVillagePanchayat() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    pr.update(
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    await pr.show();
    try {
      var url = Uri.parse(
          URI_API().api_url + 'village-panchayat-block-wise?blockId=$blockId');
      var response = await http.get(
        url,
        headers: URI_API().tokenData,
      );
      var statuscode = response.statusCode;
      if (statuscode != 200) {
        await pr.hide();
        showAlertPopup(context, 'Alert', 'Error!! Please try again later');
      } else if (statuscode == 200) {
        await pr.hide();

        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<VillagePanchayat> panchayat =
            list.map((i) => VillagePanchayat.fromJson(i)).toList();

        List data = []; //edited line
        setState(() {
          _dropdownMenuVillagePanchayat =
              builddropdownMenuVillagePanchayat(panchayat);
          _selectedVillagePanchayat = _dropdownMenuVillagePanchayat[0].value;
        });
      } else {
        showAlertPopup(context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<VillagePanchayat>> builddropdownMenuVillagePanchayat(
      List listVillagePanchayat) {
    List<DropdownMenuItem<VillagePanchayat>> items = [];
    for (VillagePanchayat listVillagePanchayat in listVillagePanchayat) {
      items.add(
        DropdownMenuItem(
          child: Text(listVillagePanchayat.value_text_u),
          value: listVillagePanchayat,
        ),
      );
    }
    return items;
  }

  Future getRajasvaGram() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    pr.update(
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    await pr.show();
    try {
      var url = Uri.parse(URI_API().api_url +
          'village-panchayat-wise?panchayatId=$panchayatId');

      var response = await http.get(
        url,
        headers: URI_API().tokenData,
      );
      var statuscode = response.statusCode;
      if (statuscode != 200) {
        await pr.hide();
        showAlertPopup(context, 'Alert', 'Error!! Please try again later');
      } else if (statuscode == 200) {
        await pr.hide();

        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<RajasvaGram> gram =
            list.map((i) => RajasvaGram.fromJson(i)).toList();

        List data = []; //edited line
        setState(() {
          _dropdownMenuRajasvaGram = builddropdownMenuRajasvaGram(gram);
          _selectedRajasvaGram = _dropdownMenuRajasvaGram[0].value;
        });
      } else {
        showAlertPopup(context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<RajasvaGram>> builddropdownMenuRajasvaGram(
      List listRajasvaGram) {
    List<DropdownMenuItem<RajasvaGram>> items = [];
    for (RajasvaGram listRajasvaGram in listRajasvaGram) {
      items.add(
        DropdownMenuItem(
          child: Text(listRajasvaGram.value_text_u),
          value: listRajasvaGram,
        ),
      );
    }
    return items;
  }

  Future getWard() async {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    pr.update(
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    await pr.show();
    try {
      var url = Uri.parse(URI_API().api_url +
          'get-ward-town-area-wise?param1=$distId+&param2=0&param3=$nagarId&param4=1');
      var response = await http.get(
        url,
        headers: URI_API().tokenData,
      );
      var statuscode = response.statusCode;
      if (statuscode != 200) {
        await pr.hide();
        showAlertPopup(context, 'Alert', 'Error!! Please try again later');
      } else if (statuscode == 200) {
        await pr.hide();

        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;

        if (list.length > 0) {
          List<Ward> gram = list.map((i) => Ward.fromJson(i)).toList();
          List data = []; //edited line
          setState(() {
            _dropdownMenuWard = builddropdownMenuWard(gram);
            _selectedWard = _dropdownMenuWard[0].value;
          });
        } else {
          showAlertPopup(context, 'Alert', 'Ward not mapped with this town.');
        }
      } else {
        showAlertPopup(context, 'Alert',
            'Something Went Worng Please Try After Some Time!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<Ward>> builddropdownMenuWard(List listRajasvaGram) {
    List<DropdownMenuItem<Ward>> items = [];
    for (Ward listRajasvaGram in listRajasvaGram) {
      items.add(
        DropdownMenuItem(
          child: Text(listRajasvaGram.r_valuetext),
          value: listRajasvaGram,
        ),
      );
    }
    return items;
  }

  void valueReset(String type) {
    if (type == "R") {
      distId = "0";
      tehsilId = "0";
      blockId = "0";
      panchayatId = "0";
      rajasvaId = "0";
      nagarId = "0";
      wardId = "0";
      distText = "";
      tehsilText = "";
      blockText = "";
      panchayatText = "";
      rajasvaText = "";
      nagarText = "";
      wardText = "";
      _dropdownMenuDistrict = [];
      _selectedDistrict = null;
      _dropdownMenuTehsil = [];
      _selectedTehsil = null;
      _dropdownMenuBlock = [];
      _selectedBlock = null;
      _dropdownMenuNagar = [];
      _selectedNagar = null;
      _dropdownMenuVillagePanchayat = [];
      _selectedVillagePanchayat = null;
      _dropdownMenuRajasvaGram = [];
      _selectedRajasvaGram = null;
      _dropdownMenuWard = [];
      _selectedWard = null;

      setState(() {
        getDistrict();
      });
    } else if (type == "D") {
      tehsilId = "0";
      blockId = "0";
      panchayatId = "0";
      rajasvaId = "0";
      nagarId = "0";
      wardId = "0";
      tehsilText = "";
      blockText = "";
      panchayatText = "";
      rajasvaText = "";
      nagarText = "";
      wardText = "";

      _dropdownMenuTehsil = [];
      _selectedTehsil = null;
      _dropdownMenuBlock = [];
      _selectedBlock = null;
      _dropdownMenuNagar = [];
      _selectedNagar = null;
      _dropdownMenuVillagePanchayat = [];
      _selectedVillagePanchayat = null;
      _dropdownMenuRajasvaGram = [];
      _selectedRajasvaGram = null;
      _dropdownMenuWard = [];
      _selectedWard = null;
    } else if (type == "T") {
      blockId = "0";
      panchayatId = "0";
      rajasvaId = "0";
      blockText = "";
      panchayatText = "";
      rajasvaText = "";

      _dropdownMenuBlock = [];
      _selectedBlock = null;
      _dropdownMenuVillagePanchayat = [];
      _selectedVillagePanchayat = null;
      _dropdownMenuRajasvaGram = [];
      _selectedRajasvaGram = null;
    } else if (type == "B") {
      panchayatId = "0";
      rajasvaId = "0";
      panchayatText = "";
      rajasvaText = "";

      _dropdownMenuVillagePanchayat = [];
      _selectedVillagePanchayat = null;
      _dropdownMenuRajasvaGram = [];
      _selectedRajasvaGram = null;
    } else if (type == "P") {
      rajasvaId = "0";
      rajasvaText = "";

      _dropdownMenuRajasvaGram = [];
      _selectedRajasvaGram = null;
    } else if (type == "N") {
      wardId = "0";
      wardText = "";

      _dropdownMenuWard = [];
      _selectedWard = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Application Details'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: Column(children: <Widget>[
              FormBuilder(
                child: Column(
                  children: <Widget>[
                    FormBuilderRadioGroup(
                        name: 'area',
                        initialValue: '0',
                        options: [
                          FormBuilderFieldOption(
                              value: '0', child: Text('Rural')),
                          FormBuilderFieldOption(
                              value: '1', child: Text('Urban')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            beneficiary_areaId = value;
                            if (value == "0") {
                              visible = true;
                              visibleNagar = false;
                            } else {
                              visible = false;
                              visibleNagar = true;
                            }

                            valueReset("R");
                          });
                        }),
                    SizedBox(
                      height: 25.0,
                    ),
                    DropdownButtonFormField(
                        hint: new Text('Select District'),
                        isExpanded: true,
                        value: _selectedDistrict,
                        items: _dropdownMenuDistrict,
                        onChanged: (value) {
                          setState(() {
                            _selectedDistrict = value;
                            distId = _selectedDistrict.r_valueid.toString();
                            distText = _selectedDistrict.r_valuetext.toString();

                            valueReset("D");

                            if (beneficiary_areaId == "0") {
                              getTehsil();
                            } else {
                              getNagarPalika();
                            }
                          });
                        }),
                    Visibility(
                      visible: visible,
                      child: SizedBox(
                        height: 25.0,
                      ),
                    ),
                    Visibility(
                      visible: visible,
                      child: DropdownButton(
                          hint: new Text('Select Tehsil'),
                          isExpanded: true,
                          value: _selectedTehsil,
                          items: _dropdownMenuTehsil,
                          onChanged: (value) {
                            setState(() {
                              _selectedTehsil = value;
                              tehsilId = _selectedTehsil.r_valueid.toString();
                              tehsilText =
                                  _selectedTehsil.r_valuetext_h.toString();
                              valueReset("T");
                              getBlock();
                            });
                          }),
                    ),
                    Visibility(
                      visible: visible,
                      child: SizedBox(
                        height: 25.0,
                      ),
                    ),
                    Visibility(
                      visible: visible,
                      child: DropdownButton(
                          hint: new Text('Select Block'),
                          isExpanded: true,
                          value: _selectedBlock,
                          items: _dropdownMenuBlock,
                          onChanged: (value) {
                            setState(() {
                              _selectedBlock = value;
                              blockId = _selectedBlock.r_valueid.toString();
                              blockText =
                                  _selectedBlock.r_valuetext_h.toString();
                              valueReset("B");
                              getVillagePanchayat();
                            });
                          }),
                    ),
                    Visibility(
                      visible: visibleNagar,
                      child: SizedBox(
                        height: 25.0,
                      ),
                    ),
                    Visibility(
                      visible: visibleNagar,
                      child: DropdownButton(
                          hint: new Text('Select Nagar Palika'),
                          isExpanded: true,
                          value: _selectedNagar,
                          items: _dropdownMenuNagar,
                          onChanged: (value) {
                            setState(() {
                              _selectedNagar = value;
                              nagarId = _selectedNagar.r_valueid.toString();
                              nagarText =
                                  _selectedNagar.r_valuetext_h.toString();
                              valueReset("N");
                              getWard();
                            });
                          }),
                    ),
                    Visibility(
                      visible: visibleNagar,
                      child: SizedBox(
                        height: 25.0,
                      ),
                    ),
                    Visibility(
                      visible: visibleNagar,
                      child: DropdownButton(
                          hint: new Text('Select Ward'),
                          isExpanded: true,
                          value: _selectedWard,
                          items: _dropdownMenuWard,
                          onChanged: (value) {
                            setState(() {
                              _selectedWard = value;
                              wardId = _selectedWard.r_valueid.toString();
                              wardText = _selectedWard.r_valuetext.toString();
                            });
                          }),
                    ),
                    Visibility(
                      visible: visible,
                      child: SizedBox(
                        height: 25.0,
                      ),
                    ),
                    Visibility(
                      visible: visible,
                      child: DropdownButton(
                          hint: new Text('Select Village Panchayat'),
                          isExpanded: true,
                          value: _selectedVillagePanchayat,
                          items: _dropdownMenuVillagePanchayat,
                          //onChanged: (value) => print(value),
                          onChanged: (value) {
                            setState(() {
                              _selectedVillagePanchayat = value;
                              panchayatId =
                                  _selectedVillagePanchayat.value_id.toString();
                              panchayatText = _selectedVillagePanchayat
                                  .value_text_u
                                  .toString();
                              valueReset("P");
                              getRajasvaGram();
                            });
                          }),
                    ),
                    Visibility(
                      visible: visible,
                      child: SizedBox(
                        height: 25.0,
                      ),
                    ),
                    Visibility(
                      visible: visible,
                      child: DropdownButton(
                          hint: new Text('Select Rajasva Gram'),
                          isExpanded: true,
                          value: _selectedRajasvaGram,
                          items: _dropdownMenuRajasvaGram,
                          //onChanged: (value) => print(value),
                          onChanged: (value) {
                            setState(() {
                              _selectedRajasvaGram = value;
                              rajasvaId =
                                  _selectedRajasvaGram.value_id.toString();
                              rajasvaText =
                                  _selectedRajasvaGram.value_text_u.toString();
                            });
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                      checkColor: Colors.greenAccent,
                      activeColor: Colors.red,
                      value: this.isChecked,
                      onChanged: (bool value) {
                        setState(() {
                          this.isChecked = value;
                          if (value) {
                            beneficiary_address.text = setAddress();
                          } else {
                            beneficiary_address.text = "";
                          }
                        });
                      }),
                  Text(
                    'Address Same As Above',
                    style: TextStyle(fontSize: 2 * SizeConfig.textSize),
                  )
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              FormBuilderTextField(
                name: 'Address',
                controller: beneficiary_address,
                decoration: InputDecoration(
                  labelText: 'Beneficiary Address',
                  hintText: 'Enter Complete Address',
                ),
                maxLength: 125,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if (distText == null ||
                        distText.isEmpty ||
                        distText == "") {
                      showAlertPopup(
                          context, 'Alert', 'Please Select District');
                    } else if (beneficiary_address.text == null ||
                        beneficiary_address.text.isEmpty ||
                        beneficiary_address.text == "") {
                      showAlertPopup(context, 'Alert',
                          'Please Enter Beneficiary Address.');
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FinancialAid(
                            beneficiary_name: beneficiary_name,
                            father_name: father_name,
                            adhar: adhar,
                            age: age,
                            mobile_one: mobile_one,
                            mobile_two: mobile_two,
                            applicant_name: applicant_name,
                            relation: relation,
                            selectedGender: selectedGender,
                            selectedDistrict: distId,
                            selectedTehsil: tehsilId,
                            selectedBlock:
                                beneficiary_areaId == "0" ? blockId : nagarId,
                            selectedPanchayat: panchayatId,
                            selectedRajasva:
                                beneficiary_areaId == "0" ? rajasvaId : wardId,
                            beneficiary_address: beneficiary_address.text,
                            beneficiary_area: beneficiary_areaId,
                          ),
                        ),
                      );
                    }
                  },
                  label: const Text('NEXT'),
                  icon: const Icon(Icons.next_plan),
                ),
              ),
              Row(
                children: <Widget>[],
              )
            ]),
          ),
        ));
  }

  String setAddress() {
    String abr = "";

    if (beneficiary_areaId == "0") {
      String vill = rajasvaId == "0" ? "" : rajasvaText;
      if (vill != "") {
        abr = abr + "ग्राम- " + vill + ", ";
      }

      String pan = panchayatId == "0" ? "" : panchayatText;
      if (pan != "") {
        abr = abr + "ग्राम पंचायत- " + pan + ", ";
      }

      String blk = blockId == "0" ? "" : blockText;
      if (blk != "") {
        abr = abr + "ब्लाक- " + blk + ", ";
      }

      String teh = tehsilId == "0" ? "" : tehsilText;
      if (teh != "") {
        abr = abr + "तहसील- " + teh + ", ";
      }

      String dis = distId == "0" ? "" : distText;
      if (dis != "") {
        abr = abr + "जिला- " + dis;
      }
    } else {
      String war = wardId == "0" ? "" : wardText;
      if (war != "") {
        abr = abr + "वार्ड- " + war + ", ";
      }

      String nag = nagarId == "0" ? "" : nagarText;
      if (nag != "") {
        abr = abr + "नगर- " + nag + ", ";
      }

      String dis = distId == "0" ? "" : distText;
      if (dis != "") {
        abr = abr + "जिला- " + dis;
      }
    }

    return abr;
  }
}

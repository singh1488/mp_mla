import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:govt_documents_validator/govt_documents_validator.dart';
import 'package:mp_mla_up/view/screen/Entry/ApplicationDetails.dart';
import 'package:mp_mla_up/view_model/custom_value.dart';
import 'package:mp_mla_up/view_model/get_relation.dart';
import 'package:mp_mla_up/view_model/get_title.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:mp_mla_up/utils/uri.dart';

class BeneficiaryDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BeneficiaryDetailsState();
  }
}

class BeneficiaryDetailsState extends State<BeneficiaryDetails> {
  List<DropdownMenuItem<GetTitle>> _dropdownMenuTitle;
  GetTitle _selectedTitle;
  TextEditingController applicant_name = TextEditingController();
  bool isChecked = false;
  GetTitle _selectedTitle_b;
  TextEditingController beneficiary_name = TextEditingController();
  List<DropdownMenuItem<GetRelation>> _dropdownMenuRelation;
  GetRelation _selectedRelation;
  GetTitle _selectedTitle_f;
  TextEditingController father_name = TextEditingController();

  List<CustomValue> _genderOptions = [
    CustomValue("1", "Male", "Male"),
    CustomValue("2", "Female", "Female"),
    CustomValue("3", "Other", "Other"),
  ];
  List<DropdownMenuItem<CustomValue>> _dropdownMenuGander;


  CustomValue _selectedGender;
  TextEditingController adhar = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController mobile_one = TextEditingController();
  TextEditingController mobile_two = TextEditingController();

  bool visible = true;
  String title_aname;
  String title_bname;
  String title_fname;
  String relation;
  String gander;

  @override
  void initState() {
    super.initState();
    _dropdownMenuGander = buildDropDownMenuGender(_genderOptions);
    getTitle();
    getRelation();
  }

  List<DropdownMenuItem<CustomValue>> buildDropDownMenuGender(List listTitle) {
    List<DropdownMenuItem<CustomValue>> items = [];
    for (CustomValue listItem in listTitle) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.value_text_u),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future getTitle() async {
    setState(() {
      visible = true;
    });

    try {
      var url = Uri.parse(URI_API().api_url + 'get-title/{}');
      var response = await http.get(
        url,
        headers: URI_API().tokenData,
      );
      var statuscode = response.statusCode;
      if (statuscode == 200) {
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<GetTitle> title = list.map((i) => GetTitle.fromJson(i)).toList();
        print("response = ${title[0].value_text_u}");
        print("response = ${title[1].value_text_u}");
        setState(() {
          _dropdownMenuTitle = buildDropDownMenuTitle(title);
          // _selectedTitle = _dropdownMenuTitle[0].value;
        });
      } else {
        showAlertPopup(context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<GetTitle>> buildDropDownMenuTitle(List listTitle) {
    List<DropdownMenuItem<GetTitle>> items = [];
    for (GetTitle listItem in listTitle) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.value_text_u),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future getRelation() async {
    setState(() {
      visible = true;
    });

    try {
      var url = Uri.parse(URI_API().api_url + 'get-relation/{}');

      var response = await http.get(
        url,
        headers: URI_API().tokenData,
      );
      var statuscode = response.statusCode;
      if (statuscode == 200) {
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<GetRelation> relation =
            list.map((i) => GetRelation.fromJson(i)).toList();

        print("response = ${relation[0].value_text_u}");
        print("response = ${relation[1].value_text_u}");

        setState(() {
          _dropdownMenuRelation = buildDropDownMenuRelation(relation);
          // _selectedRelation = _dropdownMenuRelation[0].value;
        });
      } else {
        showAlertPopup(context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<GetRelation>> buildDropDownMenuRelation(
      List listRelation) {
    List<DropdownMenuItem<GetRelation>> items = [];
    for (GetRelation listItem in listRelation) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.value_text_u),
          value: listItem,
        ),
      );
    }
    return items;
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
          title: Text('Beneficiary Details'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Column(children: <Widget>[
              Column(children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                _dropdowntitleA(context),
                SizedBox(
                  height: 10.0,
                ),
                FormBuilderTextField(
                  name: 'Applicant Name',
                  controller: applicant_name,
                  decoration: InputDecoration(
                    labelText: 'Applicant Name',
                    hintText: 'Enter Applicant Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name of applicant';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                _checkbox(context),
                SizedBox(
                  height: 10.0,
                ),
                _dropdowntitleB(context),
                SizedBox(
                  height: 10.0,
                ),
                FormBuilderTextField(
                  name: 'Beneficiary Name',
                  controller: beneficiary_name,
                  decoration: InputDecoration(
                    labelText: 'Beneficiary Name',
                    hintText: 'Enter Beneficiary Name',
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                _dropdownRelation(context),
                SizedBox(
                  height: 30.0,
                ),
                _dropdowntitleF(context),
                SizedBox(
                  height: 10.0,
                ),
                FormBuilderTextField(
                  name: 'FatherName',
                  controller: father_name,
                  decoration: InputDecoration(
                    labelText: 'Father Name',
                    hintText: 'Enter Father/Husband/Guardian Name',
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                _dropdownGender(context),
                SizedBox(
                  height: 20.0,
                ),
                FormBuilderTextField(
                  name: 'Adhar',
                  controller: adhar,
                  decoration: InputDecoration(
                    labelText: 'Beneficiary Aadhar Number',
                    hintText: 'Enter Aadhar Number',
                  ),
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10.0,
                ),
                FormBuilderTextField(
                  name: 'Age',
                  controller: age,
                  decoration: InputDecoration(
                    labelText: 'Beneficiary Age',
                    hintText: 'Enter Beneficiary Age',
                  ),
                  maxLength: 3,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 10.0,
                ),
                FormBuilderTextField(
                  name: 'MobileNo',
                  controller: mobile_one,
                  decoration: InputDecoration(
                    //icon: Icon(Icons.phone),
                    labelText: 'Mobile Number',
                    hintText: 'Enter Mobile Number',
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(
                  height: 10.0,
                ),
                FormBuilderTextField(
                  name: 'MobileNo2',
                  controller: mobile_two,
                  decoration: InputDecoration(
                    //icon: Icon(Icons.phone),
                    labelText: 'Mobile Number 2',
                    hintText: 'Enter Alternate Mobile Number',
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                        onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      bool isAadharNum;
                      String aadharNumber = adhar.text;
                      AadharValidator aadharValidator = new AadharValidator();
                      isAadharNum = aadharValidator.validate(aadharNumber);

                      if (title_aname == null ||
                          title_aname.isEmpty ||
                          title_aname == "") {
                        showAlertPopup(
                            context, 'Alert', 'Please Select Applicant Title.');

                      } else if (applicant_name.text == null ||
                          applicant_name.text.isEmpty ||
                          applicant_name.text == "") {
                        showAlertPopup(
                            context, 'Alert', 'Please Enter Applicant Name.');

                      } else if (title_bname == null ||
                          title_bname.isEmpty ||
                          title_bname == "") {
                        showAlertPopup(context, 'Alert',
                            'Please Select Beneficiary Title.');

                      } else if (beneficiary_name.text == null ||
                          beneficiary_name.text.isEmpty ||
                          beneficiary_name.text == "") {
                        showAlertPopup(
                            context, 'Alert', 'Please Enter Beneficiary Name.');

                      } else if (relation == null ||
                          relation.isEmpty ||
                          relation == "") {
                        showAlertPopup(
                            context, 'Alert', 'Please Select Relation.');

                      } else if (title_fname == null ||
                          title_fname.isEmpty ||
                          title_fname == "") {
                        showAlertPopup(context, 'Alert',
                            'Please Select Father/Husband/Guardian Title.');

                      } else if (father_name.text == null ||
                          father_name.text.isEmpty ||
                          father_name.text == "") {
                        showAlertPopup(context, 'Alert',
                            'Please Enter Father/Husband/Guardian Name.');

                      } else if (gander == null ||
                          gander.isEmpty ||
                          gander == "") {
                        showAlertPopup(
                            context, 'Alert', 'Please Select Gender.');

                      } else if (isAadharNum == false) {
                        showAlertPopup(context, 'Alert',
                            'Please Enter Valid Aadhar Number.');

                      } else if (age.text == null ||
                          age.text.isEmpty ||
                          age.text == "") {
                        showAlertPopup(context, 'Alert', 'Please Enter Age.');

                      } else if (mobile_one.text == null ||
                          mobile_one.text.isEmpty ||
                          mobile_one.text == "") {
                        showAlertPopup(
                            context, 'Alert', 'Please Enter Mobile Number 1.');

                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplicationDetails(
                                applicant_name: title_aname + " " + applicant_name.text,
                                beneficiary_name: title_bname + " " + beneficiary_name.text,
                                relation: relation,
                                father_name: title_fname + " " + father_name.text,
                                adhar: adhar.text,
                                age: age.text,
                                mobile_one: mobile_one.text,
                                mobile_two: mobile_two.text,
                                selectedGender: gander),
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
            ]),
          ),
        ));
  }

  Widget _dropdownGender(BuildContext context) {
    return Column(children: <Widget>[
      DropdownButton(
          hint: Text('Select Gender'),
          isExpanded: true,
          value: _selectedGender,
          items: _dropdownMenuGander,

          onChanged: (value) {
            setState(() {
              _selectedGender = value;
              gander = _selectedGender.value_id.toString();
            });
          })
    ]);
  }

  Widget _dropdowntitleA(BuildContext context) {
    return Column(children: <Widget>[
      DropdownButton(
          hint: new Text('Select Applicant Title'),
          isExpanded: true,
          value: _selectedTitle,
          items: _dropdownMenuTitle,
          //onChanged: (value) => print(value),
          onChanged: (value) {
            setState(() {
              _selectedTitle = value;
              title_aname = _selectedTitle.value_text_u.toString();
            });
          })
    ]);
  }

  Widget _dropdowntitleB(BuildContext context) {
    return Column(children: <Widget>[
      DropdownButton(
          hint: new Text('Select Beneficiary Title'),
          isExpanded: true,
          value: _selectedTitle_b,
          items: _dropdownMenuTitle,
          onChanged: (value) {
            setState(() {
              _selectedTitle_b = value;
              title_bname = _selectedTitle_b.value_text_u.toString();
            });
          })
    ]);
  }

  Widget _dropdowntitleF(BuildContext context) {
    return Column(children: <Widget>[
      DropdownButton(
          hint: new Text('Select Father Name Title'),
          isExpanded: true,
          value: _selectedTitle_f,
          items: _dropdownMenuTitle,
          onChanged: (value) {
            setState(() {
              _selectedTitle_f = value;
              title_fname = _selectedTitle_f.value_text_u.toString();
            });
          })
    ]);
  }

  Widget _dropdownRelation(BuildContext context) {
    return Column(children: <Widget>[
      DropdownButton(
          hint: new Text('Select Relation with Beneficiary'),
          isExpanded: true,
          value: _selectedRelation,
          items: _dropdownMenuRelation,
          onChanged: (value) {
            setState(() {
              _selectedRelation = value;
              relation = _selectedRelation.value_id.toString();
            });
          })
    ]);
  }

  Widget _checkbox(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
            checkColor: Colors.greenAccent,
            activeColor: Colors.red,
            value: this.isChecked,
            onChanged: (bool value) {
              setState(() {
                this.isChecked = value;
                if (value) {
                  beneficiary_name = applicant_name;
                  _selectedTitle_b = _selectedTitle;
                  title_bname = title_aname;
                } else {
                  beneficiary_name = null;
                  _selectedTitle_b = null;
                  title_bname = null;
                }
              });
            }),
        Text(
          'Is Baneficiary same as Applicant',
          style: TextStyle(fontSize: 2 * SizeConfig.textSize),
        )
      ],
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mp_mla_up/view_model/get_hospital.dart';
import 'package:mp_mla_up/view_model/get_purpose_list.dart';

class AddData extends StatefulWidget {
  String beneficiary_name, father_name, adhar, age, mobile_one, mobile_two;
  String selectedTitle;
  String selectedGender;
  String selectedDistrict;
  String selectedTehsil;
  String selectedBlock;
  String selectedPanchayat;

  AddData(
      {Key key,
      @required this.beneficiary_name,
      @required this.father_name,
      @required this.adhar,
      @required this.age,
      @required this.mobile_one,
      @required this.mobile_two,
      @required this.selectedTitle,
      @required this.selectedGender,
      @required this.selectedDistrict,
      @required this.selectedTehsil,
      @required this.selectedBlock,
      @required this.selectedPanchayat})
      : super(key: key);

  @override
  _AddDataState createState() => _AddDataState(
      beneficiary_name: beneficiary_name,
      father_name: father_name,
      adhar: adhar,
      age: age,
      mobile_one: mobile_one,
      mobile_two: mobile_two,
      selectedTitle: selectedTitle,
      selectedGender: selectedGender,
      selectedDistrict: selectedDistrict,
      selectedTehsil: selectedTehsil,
      selectedBlock: selectedBlock,
      selectedPanchayat: selectedPanchayat);
}

class _AddDataState extends State<AddData> {
  List<DropdownMenuItem<Hospital>> _dropdownMenuHospital;
  Hospital _selectedHospital;
  List<DropdownMenuItem<Purpose>> _dropdownMenuPurpose;
  Purpose _selectedPurpose;

  String beneficiary_name, father_name, adhar, age, mobile_one, mobile_two;
  String selectedTitle;
  String selectedGender;
  String selectedDistrict;
  String selectedTehsil;
  String selectedBlock;
  String selectedPanchayat;

  _AddDataState({
    Key key,
    @required this.beneficiary_name,
    @required this.father_name,
    @required this.adhar,
    @required this.age,
    @required this.mobile_one,
    @required this.mobile_two,
    @required this.selectedTitle,
    @required this.selectedGender,
    @required this.selectedDistrict,
    @required this.selectedTehsil,
    @required this.selectedBlock,
    @required this.selectedPanchayat,
  });

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();

      print("ADDDATA11");

      data['beneficiary_name'] = this.beneficiary_name;
      data['father_name'] = this.father_name;
      data['adhar'] = this.adhar;
      data['age'] = this.age;
      data['mobile_one'] = this.mobile_one;
      data['mobile_two'] = this.mobile_two;
      data['selectedTitle'] = this.selectedTitle;
      data['selectedGender'] = this.selectedGender;
      data['selectedDistrict'] = this.selectedDistrict;
      data['selectedTehsil'] = this.selectedTehsil;
      data['selectedBlock'] = this.selectedBlock;
      data['selectedPanchayat'] = this.selectedPanchayat;

      var bodydata = json.encode(data); // important
      print(bodydata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: new EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text('SUBMIT'),
                  icon: const Icon(Icons.save),
                ),
              ),
            ]),
          ),
        ));
  }
}

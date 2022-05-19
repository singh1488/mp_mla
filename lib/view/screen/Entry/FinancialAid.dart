import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mp_mla_up/utils/constants.dart';
import 'package:mp_mla_up/utils/uri.dart';
import 'package:mp_mla_up/view_model/get_hospital.dart';
import 'package:mp_mla_up/view_model/get_purpose_list.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:open_file/open_file.dart';

class FinancialAid extends StatefulWidget {
  String beneficiary_name, father_name, adhar, age, mobile_one, mobile_two;
  String applicant_name,
      relation,
      selectedGender,
      beneficiary_address,
      beneficiary_area;
  String selectedDistrict;
  String selectedTehsil;
  String selectedBlock;
  String selectedPanchayat, selectedRajasva;

  FinancialAid(
      {Key key,
      @required this.beneficiary_name,
      @required this.father_name,
      @required this.adhar,
      @required this.age,
      @required this.mobile_one,
      @required this.mobile_two,
      @required this.applicant_name,
      @required this.relation,
      @required this.selectedGender,
      @required this.selectedDistrict,
      @required this.selectedTehsil,
      @required this.selectedBlock,
      @required this.selectedPanchayat,
      @required this.selectedRajasva,
      @required this.beneficiary_address,
      @required this.beneficiary_area})
      : super(key: key);

  @override
  _FinancialAidState createState() => _FinancialAidState(
      beneficiary_name: beneficiary_name,
      father_name: father_name,
      adhar: adhar,
      age: age,
      mobile_one: mobile_one,
      mobile_two: mobile_two,
      applicant_name: applicant_name,
      relation: relation,
      selectedGender: selectedGender,
      selectedDistrict: selectedDistrict,
      selectedTehsil: selectedTehsil,
      selectedBlock: selectedBlock,
      selectedPanchayat: selectedPanchayat,
      selectedRajasva: selectedRajasva,
      beneficiary_address: beneficiary_address,
      beneficiary_area: beneficiary_area);
}

class _FinancialAidState extends State<FinancialAid> {
  List<DropdownMenuItem<Hospital>> _dropdownMenuHospital;
  Hospital _selectedHospital;
  List<DropdownMenuItem<Purpose>> _dropdownMenuPurpose;
  Purpose _selectedPurpose;
  String beneficiary_name,
      father_name,
      adhar,
      age,
      mobile_one,
      mobile_two,
      applicant_name,
      relation,
      selectedGender;

  String beneficiary_address,
      beneficiary_area,
      selectedDistrict,
      selectedTehsil,
      selectedBlock,
      selectedPanchayat,
      selectedRajasva,
      userId = "0";

  TextEditingController estimated_amount = TextEditingController();
  TextEditingController hosp_reg_no = TextEditingController();
  TextEditingController purpose_details = TextEditingController();

  _FinancialAidState(
      {Key key,
      @required this.beneficiary_name,
      @required this.father_name,
      @required this.adhar,
      @required this.age,
      @required this.mobile_one,
      @required this.mobile_two,
      @required this.applicant_name,
      @required this.relation,
      @required this.selectedGender,
      @required this.selectedDistrict,
      @required this.selectedTehsil,
      @required this.selectedBlock,
      @required this.selectedPanchayat,
      @required this.selectedRajasva,
      @required this.beneficiary_address,
      @required this.beneficiary_area});

  @override
  void initState() {
    super.initState();
    userId = Constants.prefs.getInt("user_id").toString();
    getHospital();
    getPurpose("1");
    visible = true;
  }

  String hospital_code = "0",
      purpose_code = "0",
      aid_type = "1",
      purpose = "",
      amount = "0",
      h_reg_no = "";
  File pickedImage;
  String img64;
  var bytes;
  bool visible = true;
  File _image;
  final ImagePicker _picker = ImagePicker();
  String app_source;

  Future getHospital() async {
    try {
      var url = Uri.parse(URI_API().api_url +
          'jansunwai-mobile-service/api/get-relief-hospital-list/{}');
      final Map<String, String> tokenData = {"api-key": URI_API().api_key};

      var response = await http.get(
        url,
        headers: tokenData,
      );
      var statuscode = response.statusCode;
      if (statuscode == 200) {
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<Hospital> hosp = list.map((i) => Hospital.fromJson(i)).toList();

        setState(() {
          _dropdownMenuHospital = buildDropDownMenuHospital(hosp);
        });
      } else {
        showAlertPopup(this.context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(this.context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<Hospital>> buildDropDownMenuHospital(
      List listHospital) {
    List<DropdownMenuItem<Hospital>> items = [];
    for (Hospital listItem in listHospital) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.hospdetail),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future getPurpose(String reftype) async {
    try {
      print("SUCCESS1");
      var url = Uri.parse(URI_API().api_url +
          'jansunwai-mobile-service/api/get-relief-purpose-list?p_relief_type=$reftype');
      final Map<String, String> tokenData = {"api-key": URI_API().api_key};
      print("SUCCESS2");
      var response = await http.get(
        url,
        headers: tokenData,
      );
      var statuscode = response.statusCode;
      if (statuscode == 200) {
        print("SUCCESS3");
        var message = jsonDecode(utf8.decode(response.bodyBytes));
        var list = message['Result'] as List;
        List<Purpose> purpose = list.map((i) => Purpose.fromJson(i)).toList();
        setState(() {
          _dropdownMenuPurpose = buildDropDownMenuPurpose(purpose);
        });
      } else {
        showAlertPopup(this.context, 'Alert', 'ERROR!!');
      }
    } catch (e) {
      print(e);
      showAlertPopup(this.context, 'Alert', 'ERROR!!');
    }
  }

  List<DropdownMenuItem<Purpose>> buildDropDownMenuPurpose(List listPurpose) {
    List<DropdownMenuItem<Purpose>> items = [];
    for (Purpose listItem in listPurpose) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.pdesc),
          value: listItem,
        ),
      );
    }
    return items;
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();

    if (response.isEmpty) {
      return;
    }
    if (response != null) {
      setState(() {
        _image = response.file as File;
      });
    } else {
      print('Retrieve error ' + response.exception.code);
    }
  }

  Widget _previewImage() {
    if (_image != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.file(
              File(_image.path),
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _previewText() {
    if (_image != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text("File Name:- " + _image.path.split('/').last),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    } else {
      return const Text(
        'You have not yet picked a document.',
        textAlign: TextAlign.center,
      );
    }
  }

  void _pickImage() async {
    try {
      if (app_source == "Gallery") {
        FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'pdf', 'png'],
        );
        setState(() {
          if (result != null) {
            File file = File(result.files.single.path);
            _image = file;
          }
        });
      } else if (app_source == "Camera") {
        final pickedFile = await _picker.pickImage(source: ImageSource.camera);
        setState(() {
          _image = new File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Image picker error " + e);
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
          title: Text('Financial Aid Details'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: new EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              Column(
                children: <Widget>[
                  FormBuilderRadioGroup(
                      name: 'aidtype',
                      initialValue: '1',
                      options: [
                        FormBuilderFieldOption(
                            value: '1', child: Text('Treatment Aid')),
                        FormBuilderFieldOption(
                            value: '2', child: Text('Financial Aid')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          aid_type = value;
                          getPurpose(aid_type);
                          if (value == "1") {
                            visible = true;
                          } else {
                            visible = false;
                          }
                        });
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  Visibility(
                      visible: visible,
                      child: DropdownButton(
                          hint: new Text('Select Hospital'),
                          isExpanded: true,
                          value: _selectedHospital,
                          items: _dropdownMenuHospital,
                          onChanged: (value) {
                            setState(() {
                              _selectedHospital = value;
                              hospital_code =
                                  _selectedHospital.hospcd.toString();
                            });
                          })),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              DropdownButton(
                  hint: new Text('Select Purpose'),
                  isExpanded: true,
                  value: _selectedPurpose,
                  items: _dropdownMenuPurpose,
                  //onChanged: (value) => print(value),
                  onChanged: (value) {
                    setState(() {
                      _selectedPurpose = value;
                      purpose_code = _selectedPurpose.pcode.toString();
                    });
                  }),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                  visible: visible,
                  child: FormBuilderTextField(
                    name: 'amount',
                    controller: estimated_amount,
                    decoration: InputDecoration(
                      labelText: 'Enter Estimated Amount',
                    ),
                    maxLength: 7,
                    keyboardType: TextInputType.number,
                  )),
              SizedBox(
                height: 10.0,
              ),
              Visibility(
                  visible: visible,
                  child: FormBuilderTextField(
                    name: 'registrationno',
                    controller: hosp_reg_no,
                    decoration: InputDecoration(
                      labelText: 'Enter Hospital Registration Number',
                    ),
                    maxLength: 20,
                  )),
              SizedBox(
                height: 10.0,
              ),
              FormBuilderTextField(
                name: 'purposedtl',
                controller: purpose_details,
                decoration: InputDecoration(
                  labelText: 'Purpose Details',
                  hintText: 'Enter Purpose Details',
                ),
                maxLines: 4,
                maxLength: 1500,
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                  child: FutureBuilder<void>(
                future: retriveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text('Picked an image');
                    case ConnectionState.done:
                      return _previewText();
                    /*if(_image.path.split('.').last == 'pdf'){
                        return _previewText();
                      }else{
                        return _previewImage();
                      }*/
                    default:
                      return const Text('Picked an image');
                  }
                },
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                    onPressed: imagePickerOption,
                    icon: const Icon(Icons.add_a_photo_sharp),
                    label: const Text('Select Application File')),
              ),
              SizedBox(
                height: 10.0,
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
                    purpose = purpose_details.text;

                    if (aid_type == "1") {
                      amount = estimated_amount.text;
                      h_reg_no = hosp_reg_no.text;
                    }

                    if (aid_type == "1" && hospital_code == "0") {
                      showAlertPopup(
                          context, 'Alert', 'Please select hospital.');
                    } else if (aid_type == "1" &&
                        (amount.isEmpty || amount == "0" || amount == "")) {
                      showAlertPopup(context, 'Alert', 'Please enter amount.');
                    } else if (purpose_code == "0" || purpose_code == "") {
                      showAlertPopup(
                          context, 'Alert', 'Please select purpose.');
                    } else if (purpose.isEmpty ||
                        purpose == "0" ||
                        purpose == "") {
                      showAlertPopup(
                          context, 'Alert', 'Please enter purpose details.');
                    } else if (_image == null ||
                        _image.isBlank ||
                        _image.lengthSync() == 0) {
                      showAlertPopup(
                          context, 'Alert', 'Please select document.');
                    } else if (_image.lengthSync() > 1000000) {
                      showAlertPopup(context, 'Alert',
                          'Please Select document less then than 1 MB.');
                    } else {
                      AddData();
                    }
                  },
                  label: const Text('SUBMIT'),
                  icon: const Icon(Icons.save),
                ),
              ),
            ]),
          ),
        ));
  }

  //Bottom Sheet For Select File
  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Select the Application",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      //pickImage(ImageSource.camera);
                      app_source = "Camera";
                      Navigator.pop(this.context);
                      _pickImage();
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      app_source = "Gallery";
                      Navigator.pop(this.context);
                      _pickImage();
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future AddData() async {
    print("Image Path == " + _image.path);
    String basename = _image.path.split('/').last;
    print("File Name == " + basename);

    MediaType contentType;

    if (basename.contains(".pdf")) {
      contentType = new MediaType('application', 'pdf');
    } else if (basename.contains(".jpg")) {
      contentType = new MediaType('image', 'jpg');
    } else if (basename.contains(".png")) {
      contentType = new MediaType('image', 'png');
    } else if (basename.contains(".jpeg")) {
      contentType = new MediaType('image', 'jpeg');
    }

    var uri = Uri.parse(
        URI_API().api_url + "jansunwai-mobile-service/api/save-relief-app");
    final Map<String, String> tokenData = {"api-key": URI_API().api_key};
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(tokenData);
    request.fields['app_details'] = this.purpose;
    request.fields['app_type'] = this.aid_type;
    request.fields['bfy_area'] = this.beneficiary_area;
    request.fields['bfy_disttcode'] = this.selectedDistrict;
    request.fields['bfy_tehsilcode'] = this.selectedTehsil;
    request.fields['bfy_block_npcode'] = this.selectedBlock;
    request.fields['village_panchayat'] = this.selectedPanchayat;
    request.fields['village_wardcode'] = this.selectedRajasva;
    request.fields['bfy_aadhar'] = this.adhar;
    request.fields["bfy_fname"] = this.father_name;
    request.fields["bfy_name"] = this.beneficiary_name;
    request.fields['bfy_mob1'] = this.mobile_one;
    request.fields['bfy_mob2'] = this.mobile_two;
    request.fields['bfy_adress'] = this.beneficiary_address;
    request.fields['bfy_age'] = this.age;
    request.fields['ipaddress'] = '';
    request.fields['gender'] = this.selectedGender;
    request.fields['hospitalid'] = this.hospital_code;
    request.fields['anyhospitalname'] = '';
    request.fields['purposeid'] = this.purpose_code;
    request.fields['estimatedamount'] = this.amount;
    request.fields['byfrelation'] = this.relation;
    request.fields['hospital_reg_no'] = this.h_reg_no;
    request.fields['aplicant_name'] = this.applicant_name;
    request.fields['user_id'] = this.userId;

    var multiFile = http.MultipartFile.fromBytes(
        "file", await File.fromUri(_image.uri).readAsBytes(),
        filename: basename, contentType: contentType);
    request.files.add(multiFile);

    var response = await request.send();

    var responseData = await response.stream.bytesToString(utf8);

    if (response.statusCode == 200) {}
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }
}

//multipart from data

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mp_mla_up/utils/uri.dart';
import 'package:mp_mla_up/view/screen/background.dart';
import 'package:mp_mla_up/view/screen/dasboard/main_dashboard.dart';
import 'package:mp_mla_up/view_model/user_login.dart';
import 'package:mp_mla_up/view_model/user_model.dart';
import 'package:mp_mla_up/utils/alertbox.dart';
import 'package:mp_mla_up/utils/constants.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:dbcrypt/dbcrypt.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool visible = false;
  bool isChecked = false;
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            //BgLoginImage(),
            Background(),
            Center(
              child: Padding(
                padding: EdgeInsets.all(2.0 * SizeConfig.height),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "ई-पत्र, उत्तर प्रदेश",
                        style: TextStyle(
                            fontSize: 4 * SizeConfig.textSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 2.2 * SizeConfig.height,
                      ),
                      Card(
                        color: Colors.white.withOpacity(0.8),
                        child: Form(
                            child: Padding(
                              padding: EdgeInsets.all(1.8 * SizeConfig.height),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 2.2 * SizeConfig.height,
                                  ),
                                  TextFormField(
                                    controller: userNameController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "यूजर आईडी दर्ज करें",
                                        labelText: "यूजर आईडी"),
                                  ),
                                  SizedBox(
                                    height: 2.2 * SizeConfig.height,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "पासवर्ड दर्ज करें",
                                        labelText: "पासवर्ड"),
                                  ),
                                  SizedBox(
                                    height: 2.2 * SizeConfig.height,
                                  ),
                                  /*Row(
                                    children: <Widget>[
                                      Checkbox(
                                          checkColor: Colors.greenAccent,
                                          activeColor: Colors.red,
                                          value: this.isChecked,
                                          onChanged: (bool value) {
                                            setState(() {
                                              this.isChecked = value;
                                            });
                                          }),
                                      Text(
                                        'Remember Me',
                                        style: TextStyle(
                                            fontSize: 2 * SizeConfig.textSize),
                                      )
                                    ],
                                  ),*/
                                  Padding(
                                    padding: EdgeInsets.all(
                                        1.8 * SizeConfig.height),
                                    child: ButtonTheme(
                                      minWidth: 22.4 * SizeConfig.height,
                                      height: 5.2 * SizeConfig.height,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          /*Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainDashboard()));*/

                                          Login();
                                        },
                                        child: Text("लॉग इन करें"),

                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green, // background
                                          onPrimary: Colors.white, // foreground
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future Login() async {
    setState(() {
      visible = true;
    });
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

    String userID = userNameController.text;
    String password = passwordController.text;

    try {

      final uri = Uri.parse(URI_API().api_url+'user-login');
      final headers = {'Content-Type': 'application/json',
        'Accept':'application/json',
        'api-key': URI_API().api_key
      };

      Map<String, dynamic> body = {'password': password, 'userId': userID};

      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      Response response = await post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );

      int statuscode = response.statusCode;
      String responseBody = response.body;

      print("Status $statuscode");
      print("Response $responseBody");

      if (statuscode == 200) {
        var message = jsonDecode(response.body);

        var tagObjsJson = message['Result'] as List;

        List<LoginModel> tagObjs = tagObjsJson.map((tagJson) =>
            LoginModel.fromJson(tagJson)).toList();
        print(tagObjs[0].status);

        String status = tagObjs[0].status;
        print("Statusms $status");

        if (status == 'NOTFOUND') {
          await pr.hide();
          showAlertPopup(context, 'Alert',
              'महोदय आपका यूजर आईडी गलत हैं कृपया यूजर आईडी की जाँच करें |');
        } else if (status == 'WRONGPASSWORD') {
          await pr.hide();
          showAlertPopup(context, 'Alert',
              'महोदय आपका पासवर्ड गलत हैं कृपया सही पासवर्ड दर्ज करें |');
        } else {
          await pr.hide();
          Constants.prefs.setString("user_name", tagObjs[0].status);
          userLogin();
        }

        print(tagObjs[0].status);
      } else {
        await pr.hide();
        showAlertPopup(context, 'Alert',
            'कुछ त्रुटी हुई है कृपया कुछ समय बाद प्रयास करें');
      }
    } on SocketException {
      await pr.hide();
      showAlertPopup(
          context, 'Alert', 'कुछ त्रुटी हुई है कृपया कुछ समय बाद प्रयास करें');
    } catch (e) {
      print(e);
      await pr.hide();
      showAlertPopup(
          context, 'Alert', 'कुछ त्रुटी हुई है कृपया कुछ समय बाद प्रयास करें');
    }
  }

  Future userLogin() async {
    setState(() {
      visible = true;
    });

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

    String userID = userNameController.text;

    try {
      var url = Uri.parse(URI_API().api_url+'get-user/' +userID);

      final Map<String, String> tokenData = {"api-key": URI_API().api_key};

      var response = await http.get(
        url,
        headers: tokenData,
      );

      var statuscode = response.statusCode;
      var responseBody = response.body;

      var message = jsonDecode(utf8.decode(response.bodyBytes));

      print("Status 2 Api $statuscode");
      print("Response 2 API $message");

      if (statuscode == 200) {
        //var message = jsonDecode(response.body);
        var tagObjsJson = message['Result'] as List;

        List<UserModel> tagObjs =
        tagObjsJson.map((tagJson) => UserModel.fromJson(tagJson)).toList();

        if (tagObjs.length < 0 || tagObjs.length == 0) {
          await pr.hide();
          showAlertPopup(context, 'Alert', 'महोदय आपका यूजर आईडी अथवा पासवर्ड गलत हैं कृपया यूजर आईडी की जाँच करें |');
        } else {
          Constants.prefs.setBool("isLogin", true);
          Constants.prefs.setBool("isPin", false);
          Constants.prefs.setInt("user_id", tagObjs[0].user_id);
          Constants.prefs.setInt("mis_id", tagObjs[0].mis_id);
          Constants.prefs.setString("user_name", tagObjs[0].user_name);
          Constants.prefs.setString("u_password", tagObjs[0].u_password);
          Constants.prefs.setString("r_name", tagObjs[0].r_name);
          Constants.prefs.setString("r_name_hindi", tagObjs[0].r_name_hindi);
          Constants.prefs.setString("mobileno1", tagObjs[0].mobileno1);
          Constants.prefs.setString("mobileno2", tagObjs[0].mobileno2);
          Constants.prefs.setString("r_emailid", tagObjs[0].r_emailid);
          Constants.prefs.setString("r_phoneno", tagObjs[0].r_phoneno);
          Constants.prefs.setString("user_type", tagObjs[0].user_type);
          Constants.prefs.setInt("user_level", tagObjs[0].user_level);
          Constants.prefs.setString("state_id", tagObjs[0].state_id);
          Constants.prefs.setInt("distict_id", tagObjs[0].distict_id);
          Constants.prefs.setInt("post_id", tagObjs[0].post_id);
          Constants.prefs.setString("post_name", tagObjs[0].post_name);
          Constants.prefs.setInt("const_id", tagObjs[0].const_id);
          Constants.prefs.setString("constname", tagObjs[0].constname);
          Constants.prefs.setInt("is_lock", tagObjs[0].is_lock);

          await pr.hide();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MainDashboard()));
        }

        print(tagObjs[0].r_name_hindi);
      } else {
        await pr.hide();
        showAlertPopup(context, 'Alert',
            'कुछ त्रुटी हुई है कृपया कुछ समय बाद प्रयास करें');
      }
    } on SocketException {
      await pr.hide();
      showAlertPopup(
          context, 'Alert', 'कुछ त्रुटी हुई है कृपया कुछ समय बाद प्रयास करें');
    } catch (e) {
      print(e);
      await pr.hide();
      showAlertPopup(
          context, 'Alert', 'कुछ त्रुटी हुई है कृपया कुछ समय बाद प्रयास करें');
    }
  }


}
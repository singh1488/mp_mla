import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mp_mla_up/view/screen/dasboard/main_dashboard.dart';
import 'package:mp_mla_up/view/screen/login.dart';
import 'package:mp_mla_up/utils/Images.dart';
import 'package:mp_mla_up/utils/constants.dart';
import 'package:mp_mla_up/utils/size_config.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 3;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                Constants.prefs.getBool("isLogin") == true
                    ? MainDashboard()
                    : Login()));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Align(
                      alignment: Alignment.center, child: SpleshMainContent()),
                ),
                // ButtonWidget(),
              ],
            ),
          );
        } else {
          return Column(

            children: <Widget>[
              Expanded(
                flex: 3,
                child: Align(
                    alignment: Alignment.center, child: SpleshMainContentLand()),
              ),
              // ButtonWidget(),
            ],

          );
        }
      });
    });
  }
}

class SpleshMainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2 * SizeConfig.height),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              const Color(0xFFFBA018),
              const Color(0xFFFAC88E),
            ],
            begin: const FractionalOffset(1.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 7.8 * SizeConfig.height,
                              width: 8.8 * SizeConfig.height,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(Images.pm))),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.height,
                            ),
                            Text(
                              "श्री नरेन्द्र मोदी",
                              style: TextStyle(
                                  fontSize: 1.6 * SizeConfig.textSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 0.6 * SizeConfig.height,
                            ),
                            Text(
                              "माननीय प्रधानमंत्री",
                              style: TextStyle(
                                  fontSize: 1.2 * SizeConfig.textSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 7.8 * SizeConfig.height,
                              width: 7.8 * SizeConfig.height,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(Images.cm))),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.height,
                            ),
                            Text(
                              "योगी आदित्यनाथ",
                              style: TextStyle(
                                  fontSize: 1.6 * SizeConfig.textSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 0.6 * SizeConfig.height,
                            ),
                            Text(
                              "माननीय मुख्यमंत्री, उत्तर प्रदेश",
                              style: TextStyle(
                                  fontSize: 1.2 * SizeConfig.textSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Image.asset(Images.logo,
                          height: 16.7 * SizeConfig.height,
                          width: 16.7 * SizeConfig.height),
                    ),
                  ),
                  SizedBox(
                    height: 1.9 * SizeConfig.height,
                  ),
                  Text(
                    "ई-पत्र",
                    style: TextStyle(
                        fontSize: 3.4 * SizeConfig.textSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        2.3 * SizeConfig.height,
                        2.0 * SizeConfig.height,
                        2.3 * SizeConfig.height,
                        0),
                    child: Text(
                      "माननीय सांसद एवं विधायक हेतु",
                      style: TextStyle(
                        fontSize: 2.3 * SizeConfig.textSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: 6.5 * SizeConfig.height,
                      maxHeight: 7.9 * SizeConfig.height),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class SpleshMainContentLand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2 * SizeConfig.height),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              const Color(0xFFFBA018),
              const Color(0xFFFAC88E),
            ],
            begin: const FractionalOffset(1.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 8.8 * SizeConfig.height,
                              width: 9.8 * SizeConfig.height,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(Images.pm))),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.height,
                            ),
                            Text(
                              "श्री नरेन्द्र मोदी",
                              style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textSize,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 0.6 * SizeConfig.height,
                            ),
                            Text(
                              "माननीय प्रधानमंत्री",
                              style: TextStyle(
                                  fontSize: 1.4 * SizeConfig.textSize,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),


                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "ई-पत्र",
                                style: TextStyle(
                                    fontSize: 3.4 * SizeConfig.textSize,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 0.6 * SizeConfig.height,
                              ),
                              Text(
                                "माननीय सांसद एवं विधायक हेतु",
                                style: TextStyle(
                                  fontSize: 2.3 * SizeConfig.textSize,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 8.8 * SizeConfig.height,
                              width: 8.8 * SizeConfig.height,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(Images.cm))),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.height,
                            ),
                            Text(
                              "योगी आदित्यनाथ",
                              style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textSize,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 0.6 * SizeConfig.height,
                            ),
                            Text(
                              "माननीय मुख्यमंत्री, उत्तर प्रदेश",
                              style: TextStyle(
                                  fontSize: 1.4 * SizeConfig.textSize,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
              flex: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Image.asset(Images.logo,
                          height: 16.7 * SizeConfig.height,
                          width: 16.7 * SizeConfig.height),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: 7.5 * SizeConfig.height,
                          maxHeight: 7.5 * SizeConfig.height),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mp_mla_up/view/screen/dasboard/main_dashboard.dart';
import 'package:mp_mla_up/view/screen/dasboard/page_routes.dart';
import 'package:mp_mla_up/view/screen/splash_screen.dart';
import 'package:mp_mla_up/utils/constants.dart';
import 'package:mp_mla_up/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
           // SizerUtil().init(constraints, orientation);
            SizeConfig().init(constraints, orientation);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                  primarySwatch: Colors.orange),
              home: SplashScreen(),
              routes:  {
                PageRoutes.dashboard: (context) => MainDashboard(),
              },
            );
          },
        );
      },
    );
  }
}



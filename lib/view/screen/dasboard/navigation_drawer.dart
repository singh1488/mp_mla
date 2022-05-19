import 'package:flutter/material.dart';

import 'package:mp_mla_up/utils/size_config.dart';
import 'package:mp_mla_up/view/screen/Entry/BeneficiaryDetails.dart';
import 'package:mp_mla_up/view/screen/dasboard/page_routes.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          createDrawerBodyItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () =>
                Navigator.pushReplacementNamed(context, PageRoutes.dashboard),
          ),
          Divider(),
          createDrawerBodyItem(
            icon: Icons.note_add,
            text: 'Entry Form',
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BeneficiaryDetails())),
            //Navigator.pushReplacementNamed(context, PageRoutes.entry_form),
          ),
          ListTile(
            title: Text('App version 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

Widget createDrawerHeader() {
  return DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    child: Stack(children: <Widget>[
      Positioned(
        top: 40.0,
        bottom: 12.0,
        left: 16.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('यूजर आईडी - MLA_3891',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 1.6 * SizeConfig.textSize)),
            SizedBox(
              height: 4.0,
            ),
            Text('पावनी टंडन',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 1.6 * SizeConfig.textSize,
                )),
            SizedBox(
              height: 4.0,
            ),
            Text('pawnitandon18@gmail.com',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 1.6 * SizeConfig.textSize)),
            SizedBox(
              height: 4.0,
            ),
            Text('9695690820',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 1.6 * SizeConfig.textSize)),
          ],
        ),
      ),
    ]),
    decoration: BoxDecoration(
      color: Colors.orange,
    ),
  );
}

Widget createDrawerBodyItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}

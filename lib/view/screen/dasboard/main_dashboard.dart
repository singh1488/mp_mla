import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mp_mla_up/view/screen/dasboard/navigation_drawer.dart';
import 'arthik/aartik_madad_dashboard.dart';
import 'ecabinet/EcabinetMain.dart';
import 'jansunwai/jansunwai_dashboard.dart';

class MainDashboard extends StatefulWidget {
  static const String routeName = '/dashboard';

  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[
    JansunwaiDashboard(),
    ArthikMadadDashboard(),
    EcabinetMain(),
    /*Text(
      'Index 1: CMIS प्रोजेक्ट्स',
      style: optionStyle,
    ),*/
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2 ? null :
      AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          'मेरा विधान सभा क्षेत्र, उत्तर प्रदेश',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      drawer: NavigationDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'जनसुनवाई सन्दर्भ',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'आर्थिक मदद',
            backgroundColor: Colors.blueAccent,
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room),
            label: 'ई-कैबिनेट',
            backgroundColor: Colors.blueAccent,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

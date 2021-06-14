import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:simple_wol/models/wolmodel.dart';
import 'package:simple_wol/screens/add_item.dart';
import 'package:simple_wol/screens/search.dart';
import 'package:simple_wol/screens/wol_home.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WOLListModel(),
      child: WOLApp(),
    ),
  );
}

class WOLApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'Simple Wake-On-LAN by TheCrether',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => WOLHome(title: 'Simple Wake-On-LAN'),
        "/add": (context) => AddItem(),
        "/search": (context) => Search(),
      },
    );
  }
}

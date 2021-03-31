import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_wol/wol.dart';

Future<void> saveWOLItems(List<WOLItem> items) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("wol-items", WOLItem.encode(items));
}

Future<List<WOLItem>> getWOLItems() async {
  var prefs = await SharedPreferences.getInstance();
  String items = prefs.getString("wol-items");
  if (items == null) return [];
  return WOLItem.decode(prefs.getString("wol-items"));
}

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_wol/wol.dart';

/// saves a WOLItem list as a JSON string in storage
Future<void> saveWOLItems(List<WOLItem> items) async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString("wol-items", WOLItem.encode(items)); // encode the list to a JSON string
}

/// fetches the WOLItem list from storage, returns [] if no list was found
Future<List<WOLItem>> getWOLItems() async {
  var prefs = await SharedPreferences.getInstance();
  String items = prefs.getString("wol-items");
  if (items == null) return [];
  return WOLItem.decode(prefs.getString("wol-items")); // decode the JSON list to an actual list
}

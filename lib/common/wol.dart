import 'dart:convert';

import 'package:wake_on_lan/wake_on_lan.dart';

class WOLItem {
  /// the ip that is used by the wake_on_lan package
  final IPv4Address ip;

  /// the mac that is used by the wake_on_lan package
  final MACAddress mac;

  /// the name for a WOLItem
  final String name;

  /// the port that is used by the wake_on_lan package
  final int port;

  /// the default constructor for a WOLItem
  /// you need to provide the ip, mac, name and port
  WOLItem(this.ip, this.mac, this.name, this.port);

  /// converts the object to a dynamic map used for JSON strings
  Map<String, dynamic> toJson() => {
        'ip': ip.address,
        'mac': mac.address,
        'name': name,
        'port': port,
      };

  /// a secondary constructor for the WOLItem.decode() function
  WOLItem.fromJson(Map<String, dynamic> json)
      : ip = IPv4Address.from(json['ip']),
        mac = MACAddress.from(json['mac']),
        name = json['name'],
        port = json['port'];

  /// create the JSON string
  static String encode(List<WOLItem> items) =>
      json.encode(items.map<Map<String, dynamic>>((item) => item.toJson()).toList());

  /// map a JSON string to a List of WOLItem (calls the WOLItem.fromJson constructor)
  static List<WOLItem> decode(String list) =>
      (json.decode(list) as List<dynamic>).map<WOLItem>((item) => WOLItem.fromJson(item)).toList();
}

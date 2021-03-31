import 'dart:convert';

import 'package:wake_on_lan/wake_on_lan.dart';

class WOLItem {
  final IPv4Address ip;
  final MACAddress mac;
  final String name;
  final int port;

  WOLItem(this.ip, this.mac, this.name, this.port);

  Map<String, dynamic> toJson() => {
        'ip': ip.address,
        'mac': mac.address,
        'name': name,
        'port': port,
      };

  WOLItem.fromJson(Map<String, dynamic> json)
      : ip = IPv4Address.from(json['ip']),
        mac = MACAddress.from(json['mac']),
        name = json['name'],
        port = json['port'];

  static String encode(List<WOLItem> items) =>
      json.encode(items.map<Map<String, dynamic>>((item) => item.toJson()).toList());

  static List<WOLItem> decode(String list) =>
      (json.decode(list) as List<dynamic>).map<WOLItem>((item) => WOLItem.fromJson(item)).toList();
}

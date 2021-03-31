import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_wol/shared.dart';
import 'package:simple_wol/wol.dart';
import 'package:simple_wol/util.dart';
import 'package:wake_on_lan/wake_on_lan.dart';

void main() {
  runApp(WOLApp());
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
      home: WOLHome(title: 'Simple Wake-On-LAN'),
    );
  }
}

class WOLHome extends StatefulWidget {
  WOLHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WOLHomeState createState() => _WOLHomeState();
}

class _WOLHomeState extends State<WOLHome> {
  var _nameController;
  var _macController;
  var _ipController;
  var _portController;
  final _formKey = GlobalKey<FormState>();

  var _list = <WOLItem>[];

  @override
  void initState() {
    super.initState();
    getWOLItems().then((List<WOLItem> list) {
      setState(() {
        _list = list;
      });
    });
  }

  void _showAddDialog() async {
    _nameController = TextEditingController();
    _macController = TextEditingController();
    _ipController = TextEditingController();
    _portController = TextEditingController(text: "9");
    final result = await showDialog<WOLItem>(
      context: context,
      builder: (context) => AlertDialog(
        // contentPadding: EdgeInsets.all(10.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        // ),
        title: Text("Add a WoL device"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AddForm(
              formKey: _formKey,
              nameController: _nameController,
              ipController: _ipController,
              macController: _macController,
              portController: _portController,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Add device',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Navigator.of(context).pop(WOLItem(
                  IPv4Address.from(_ipController.text),
                  MACAddress.from(_macController.text),
                  _nameController.text,
                  _portController.text.trim().length == 0 ? -1 : int.parse(_portController.text),
                ));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Added device"),
                  duration: Duration(seconds: 2),
                ));
              }
            },
          ),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        _list.add(result);
        saveWOLItems(_list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: WOLList(
        list: _list,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Add WOL device',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class WOLList extends StatelessWidget {
  WOLList({Key key, this.list}) : super(key: key);
  List<WOLItem> list;

  @override
  Widget build(BuildContext context) {
    if (list.length == 0) {
      return Container(
        child: Center(
          child: Text("no devices added yet"),
        ),
      );
    }
    return Container(child: _buildList());
  }

  ListView _buildList() {
    return ListView.separated(
      separatorBuilder: (context, i) => Divider(
        color: Colors.grey[500],
        indent: 60,
        endIndent: 60,
      ),
      padding: const EdgeInsets.all(5),
      itemCount: list.length,
      itemBuilder: (context, i) => _buildRow(context, list[i]),
    );
  }

  Widget _buildRow(BuildContext context, WOLItem item) {
    return ListTile(
      title: Text(item.name),
      onTap: () async {
        // send WOL packet
        WakeOnLAN wol;
        if (item.port == -1) {
          wol = WakeOnLAN.from(item.ip, item.mac);
        } else {
          wol = WakeOnLAN.from(item.ip, item.mac, port: item.port);
        }
        await wol.wake().whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Trying to wake " + item.name),
              duration: Duration(seconds: 5),
            )));
      },
    );
  }
}

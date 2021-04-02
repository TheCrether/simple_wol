import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_wol/shared.dart';
import 'package:simple_wol/util.dart';
import 'package:simple_wol/wol.dart';
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
  // the different controllers that are assigned in _showAddDialog()
  var _nameController;
  var _macController;
  var _ipController;
  var _portController;
  final _formKey = GlobalKey<FormState>(); // generate a formkey for the Form in the dialog

  var _list = <WOLItem>[];

  @override
  void initState() {
    super.initState();
    // fetch the saved WOLItems, if there are any
    getWOLItems().then((List<WOLItem> list) {
      setState(() {
        // set the new list and tell Flutter to update the UI/state
        _list = list;
      });
    });
  }

  /// this displays an alert dialog with a form in it
  void _showAddDialog() async {
    // re-create the different controllers for the text fields, so that the values are empty
    _nameController = TextEditingController();
    _macController = TextEditingController();
    _ipController = TextEditingController();
    _portController = TextEditingController(text: "9");
    final result = await showDialog<WOLItem>(
      context: context,
      builder: (context) => AlertDialog(
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
              style: TextStyle(color: Colors.redAccent),
            ),
            // remove the AlertDialog from the navigation stack and return an empty result (null)
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Add device',
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () {
              // checks all validator functions
              if (_formKey.currentState.validate()) {
                // controller.text returns the value of the form field
                // this pops the AlertDialog from the navigation stack and returns an WOLItem
                Navigator.of(context).pop(WOLItem(
                  IPv4Address.from(_ipController.text), // create the IPv4 address
                  MACAddress.from(_macController.text), // create the MAC address
                  _nameController.text,
                  _portController.text.trim().length == 0 ? -1 : int.parse(_portController.text),
                ));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Added device"),
                  duration: Duration(seconds: 2), // show that the device was added to the list
                ));
              }
            },
          ),
        ],
      ),
    );

    // check if the AlertDialog returned an WOLItem
    if (result != null) {
      // update the state and save it in device storage
      setState(() {
        _list.add(result);
        saveWOLItems(_list);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WOLList(
        list: _list,
      ),
      floatingActionButton: FloatingActionButton(
        // create the FAB for adding devices
        onPressed: _showAddDialog,
        tooltip: 'Add WOL device',
        child: Icon(Icons.add),
      ),
    );
  }
}

//. renders a list of WOLItems
class WOLList extends StatelessWidget {
  WOLList({this.list}); // so that the list can be a parameter
  /// the list that will be rendered
  final List<WOLItem> list;

  @override
  Widget build(BuildContext context) {
    if (list.length == 0) {
      // check if the list is empty
      return Container(
        child: Center(
          child: Text("no devices added yet"),
        ),
      );
    }
    return Container(child: _buildList());
  }

  /// generate the ListView that displays the WOLItems
  ListView _buildList() {
    // generate a ListView with separators in between the items
    return ListView.separated(
      // this is the "builder" for a separator element
      separatorBuilder: (context, i) => Divider(
        color: Colors.grey[500],
        indent: 60,
        endIndent: 60,
      ),
      padding: const EdgeInsets.all(5),
      // set the list length
      itemCount: list.length,
      // the "builder" for a single ListTile
      itemBuilder: (context, i) => _buildRow(context, list[i]),
    );
  }

  ListTile _buildRow(BuildContext context, WOLItem item) {
    return ListTile(
      // give the tile a key for better performance
      key: Key(item.mac.address),
      title: Text(item.name),
      onTap: () async {
        // send WOL packet when the element is clicked/pressed
        WakeOnLAN wol;
        if (item.port == -1) {
          // generate the packet without a port (because it was omitted when adding it) => makes it port 9
          wol = WakeOnLAN.from(item.ip, item.mac);
        } else {
          // generate the packet with a part
          wol = WakeOnLAN.from(item.ip, item.mac, port: item.port);
        }
        // show a snackbar to let the user know that the magic packet was sent
        await wol.wake().whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Trying to wake " + item.name),
          // set the duration of how long the snackbar should appear
              duration: Duration(seconds: 5),
        )));
      },
    );
  }
}

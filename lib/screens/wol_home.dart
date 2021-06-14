import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_wol/common/shared_preferences.dart';
import 'package:simple_wol/common/wol.dart';
import 'package:simple_wol/models/wolmodel.dart';
import 'package:simple_wol/util.dart';
import 'package:wake_on_lan/wake_on_lan.dart';

class WOLHome extends StatefulWidget {
  WOLHome({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WOLHomeState createState() => _WOLHomeState();
}

class _WOLHomeState extends State<WOLHome> {
  @override
  void initState() {
    super.initState();
    // fetch the saved WOLItems, if there are any
    getWOLItems().then((List<WOLItem> list) {
      var model = context.read<WOLListModel>();
      model.setList(list);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WOLList(),
      floatingActionButton: FloatingActionButton(
        // create the FAB for adding devices
        onPressed: () => Navigator.pushNamed(context, "/add"),
        tooltip: 'Add WOL device',
        child: Icon(Icons.add),
      ),
    );
  }
}

//. renders a list of WOLItems
class WOLList extends StatelessWidget {
  WOLList(); // so that the list can be a parameter

  @override
  Widget build(BuildContext context) {
    var model = context.watch<WOLListModel>();
    var list = model.items;
    if (list.length == 0) {
      // check if the list is empty
      return Container(
        child: Center(
          child: Text("no devices added yet"),
        ),
      );
    }
    return Container(child: _buildList(list));
  }

  /// generate the ListView that displays the WOLItems
  ListView _buildList(List<WOLItem> list) {
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

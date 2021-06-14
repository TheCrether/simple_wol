import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_wol/common/shared_preferences.dart';
import 'package:simple_wol/common/wol.dart';
import 'package:simple_wol/models/wolmodel.dart';
import 'package:simple_wol/util.dart';
import 'package:wake_on_lan/wake_on_lan.dart';

class AddItem extends StatelessWidget {
  // the different controllers that are assigned in _showAddDialog()
  var _nameController;
  var _macController;
  var _ipController;
  var _portController;
  final _formKey = GlobalKey<FormState>(); // generate a formkey for the Form in the dialog

  /// this displays an alert dialog with a form in it
  void _showAddDialog(BuildContext context) async {
    // var model = context.watch<WOLListModel>();
    // re-create the different controllers for the text fields, so that the values are empty
    _nameController = TextEditingController();
    _macController = TextEditingController();
    _ipController = TextEditingController();
    _portController = TextEditingController(text: "9");
    await showDialog<WOLItem>(
      context: context,
      builder: (context) => Consumer<WOLListModel>(
        builder: (context, builder, child) => AlertDialog(
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
                  var model = context.read<WOLListModel>();
                  model.add(WOLItem(
                    IPv4Address.from(_ipController.text), // create the IPv4 address
                    MACAddress.from(_macController.text), // create the MAC address
                    _nameController.text,
                    _portController.text.trim().length == 0 ? -1 : int.parse(_portController.text),
                  ));
                  saveWOLItems(model.items);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Added device"),
                    duration: Duration(seconds: 2), // show that the device was added to the list
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add an item"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(height: 5),
                  Text(
                    "Add manually",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: () => _showAddDialog(context),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all(Size(80, 80))),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  SizedBox(height: 5),
                  Text(
                    "Search for PCs",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onPressed: () => Navigator.pushReplacementNamed(context, "/search"),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all(Size(80, 80))),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}

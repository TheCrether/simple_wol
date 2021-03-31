import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wake_on_lan/wake_on_lan.dart';

// Define a custom Form widget.
class AddForm extends StatefulWidget {
  AddForm({Key key, this.formKey, this.nameController, this.macController, this.ipController, this.portController})
      : super(key: key);
  final TextEditingController nameController;
  final TextEditingController macController;
  final TextEditingController ipController;
  final TextEditingController portController;

  final GlobalKey<FormState> formKey;

  @override
  AddFormState createState() => AddFormState(formKey, nameController, macController, ipController, portController);
}

class AddFormState extends State<AddForm> {
  AddFormState(this.formKey, this.nameController, this.macController, this.ipController, this.portController);

  final formKey;
  final TextEditingController nameController;
  final TextEditingController macController;
  final TextEditingController ipController;
  final TextEditingController portController;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Name",
            ),
            validator: (value) {
              if (value.trim().length == 0) return "Please enter a name";
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: macController,
            decoration: InputDecoration(
              labelText: "MAC Address",
              hintText: "FF:FF:FF:FF:FF:FF",
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F:]')),
              TextInputFormatter.withFunction((oldValue, newValue) => // format everything to uppercase
                  TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection)),
            ],
            validator: (value) {
              if (!MACAddress.validate(value.trim())) return "Please enter a valid MAC address";
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: ipController,
            decoration: InputDecoration(
              labelText: "IPv4 Address",
              hintText: "10.0.0.10",
            ),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            validator: (value) {
              if (!IPv4Address.validate(value.trim())) return "Please enter a valid IPv4 address";
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: portController,
            decoration: InputDecoration(
              labelText: "Port (optional)",
              hintText: "9",
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value.trim().length == 0) return null;

              int port = int.parse(value);
              if (!(0 <= port && port <= 65535)) return "Please enter a valid port (0-65535)";
              return null;
            },
          )
        ],
      ),
    );
  }
}

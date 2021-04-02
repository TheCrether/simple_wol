import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wake_on_lan/wake_on_lan.dart';

// The widget for creating a form for the AlertDialog
class AddForm extends StatelessWidget {
  AddForm({Key key, this.formKey, this.nameController, this.macController, this.ipController, this.portController})
      : super(key: key);

  // the controllers that are given to the TextFormField widgets
  final TextEditingController nameController;
  final TextEditingController macController;
  final TextEditingController ipController;
  final TextEditingController portController;

  // the form key used for validating the form
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    // build the form with the different text fields
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: nameController, // set the controller (is used for value retrieval later)
            decoration: InputDecoration(
              // give the form fields a label to know what to input
              labelText: "Name",
            ),
            validator: (value) {
              // this checks the value when a user tries to add the device (basically like submitting a form)
              // if a validator returns a string, it means that the input is invalid
              if (value.trim().length == 0) return "Please enter a name";
              return null;
            },
          ),
          SizedBox(height: 10), // some space between the fields
          TextFormField(
            controller: macController,
            decoration: InputDecoration(
              labelText: "MAC Address",
              hintText: "FF:FF:FF:FF:FF:FF", // give a hint of how a MAC address looks
            ),
            inputFormatters: [
              // this field can take what constraints or formatting should be done with the input
              FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F:]')), // only input alphanumeric characters
              TextInputFormatter.withFunction((oldValue, newValue) => // format everything to uppercase
                  TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection)),
            ],
            validator: (value) {
              // validate that it is a valid MAC address
              if (!MACAddress.validate(value.trim())) return "Please enter a valid MAC address";
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: ipController,
            decoration: InputDecoration(
              labelText: "IPv4 Address",
              hintText: "10.0.0.10", // give a hint of how an IPv4 address looks
            ),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            validator: (value) {
              // validate that the input is a valid IPv4 address
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
              if (value.trim().length == 0) return null; // this gets caught later

              // check if the port is valid
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

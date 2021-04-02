# simple_wol

A Flutter application where you can add WOL devices and wake them up over the LAN. This was done as part of an exercise for school.

## What did I learn here?

* how to use basic JSON operations in Dart
* make a dialog in Flutter (AlertDialog)
* build a form and add validation + input formatting (making everything uppercase or only valid characters from a RegEx) (AddForm)
* manage basic state (StatefulWidget)
* save data on the device with the [shared_preferences](https://pub.dev/packages/shared_preferences) module
* use external modules in general (ex: [wake_on_lan](https://pub.dev/packages/wake_on_lan))
* add an icon to a Flutter app with [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

## What each file does

### [`lib/main.dart`](./lib/main.dart)

The entrypoint for the application. It manages the list state of the WOLItems and displays the AlertDialog used for adding devices.

### [`lib/shared.dart`](./lib/shared.dart)

This contains helper functions for saving and getting data from SharedPreferences.

### [`lib/util.dart`](./lib/util.dart)

This contains helper widgets (in this case only the AddForm widget). The AddForm widget is the content of the AlertDialog that gets displayed when trying to add a device.

### [`lib/wol.dart`](./lib/wol.dart)

Contains the WOLItem class that is used for saving the data of a device.


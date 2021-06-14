import 'package:flutter/widgets.dart';
import 'package:simple_wol/common/wol.dart';

class WOLListModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<WOLItem> _items = [];

  List<WOLItem> get items => _items.map((i) => i).toList();

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(WOLItem item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void setList(List<WOLItem> list) {
    _items.clear();
    _items.addAll(list);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}

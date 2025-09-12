import 'package:contact_hub/core/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  final _debounce = Debounce(const Duration(milliseconds: 200));
  String _text = '';
  String get text => _text;

  void set(String v, void Function(String) onCommit) {
    _text = v;
    notifyListeners();
    _debounce.run(() => onCommit(v));
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }
}

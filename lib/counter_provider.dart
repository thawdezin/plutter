import 'package:flutter/cupertino.dart';

class CounterProvider extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  late int counterValue;

  CounterProvider({this.counterValue = 0});

  void incrementCounter() {
    counterValue++;
    notifyListeners();
  }

  void decrementCounter() {
    counterValue--;
    notifyListeners();
  }
}

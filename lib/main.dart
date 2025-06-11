import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LifecycleDemo(),
    );
  }
}

class LifecycleDemo extends StatefulWidget {
  const LifecycleDemo({super.key});

  @override
  State<LifecycleDemo> createState() => _LifecycleDemoState();
}

class _LifecycleDemoState extends State<LifecycleDemo> {
  int _counter = 0;
  final List<String> _log = [];

  @override
  void initState() {
    super.initState();
    _log.add('initState(): Widget is created');
    // Widget ရဲ့ state ပထမဆုံး initialize လုပ်တဲ့အချိန်
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _log.add('didChangeDependencies(): Inherited widgets changed');
    // context မကြိုတင်ရရှိနိုင်တဲ့အချိန်တွင်
    // Localization, Theme, MediaQuery စတဲ့ InheritedWidget တွေရဲ့ data ပြောင်းလဲမှ 알려줍니다.
  }

  @override
  Widget build(BuildContext context) {
    _log.add('build(): UI rebuilt');
    // UI ကို ဆွဲခတ်တဲ့ method
    return Scaffold(
      appBar: AppBar(title: const Text('Lifecycle Demo')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _counter++;
                _log.add('setState(): counter=$_counter');
              });
            },
            child: Text('Increment ($_counter)'),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _log.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_log[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _log.add('dispose(): Widget is destroyed');
    // State object ကို free လုပ်မည့်အချိန်
    super.dispose();
  }
}

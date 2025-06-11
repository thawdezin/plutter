import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Bottom Nav',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Calls', style: TextStyle(fontSize: 24))),
    Center(child: Text('Contacts', style: TextStyle(fontSize: 24))),
    Center(child: Text('Keypad', style: TextStyle(fontSize: 24))),
    Center(child: Text('Search', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // for transparent bottom bar
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(4, (index) {
                  IconData icon;
                  String label;
                  switch (index) {
                    case 0:
                      icon = Icons.access_time;
                      label = 'Calls';
                      break;
                    case 1:
                      icon = Icons.person;
                      label = 'Contacts';
                      break;
                    case 2:
                      icon = Icons.dialpad;
                      label = 'Keypad';
                      break;
                    default:
                      icon = Icons.search;
                      label = 'Search';
                  }
                  final isSelected = index == _currentIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _currentIndex = index),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: isSelected
                          ? BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30),
                      )
                          : BoxDecoration(),
                      child: Row(
                        children: [
                          Icon(icon,
                              color: isSelected ? Colors.blue : Colors.white),
                          if (isSelected)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "My network image",
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                color: Colors.red,
                child: Image.network(
                  "https://t4.ftcdn.net/jpg/01/05/90/77/240_F_105907729_4RzHYsHJ2UFt5koUI19fc6VzyFPEjeXe.jpg",
                  width: 200,
                  height: 200,
                ),
              ),
              Positioned(
                right: 10,
                left: 10,
                child: Container(
                  color: Colors.green,
                  child: Image.network(
                    "https://t4.ftcdn.net/jpg/01/05/90/77/240_F_105907729_4RzHYsHJ2UFt5koUI19fc6VzyFPEjeXe.jpg",
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

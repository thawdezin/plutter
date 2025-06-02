import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
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
        body: Column(
          children: [
            Center(
              child: Image.network(
                "https://t4.ftcdn.net/jpg/01/05/90/77/240_F_105907729_4RzHYsHJ2UFt5koUI19fc6VzyFPEjeXe.jpg",
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int count = 10;
  Color red = Colors.red;
  Color green = Colors.green;
  Color temp = Colors.white;

  AudioCache au = AudioCache();
  AudioPlayer ap = AudioPlayer();



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: green,title: MaterialButton(onPressed: (){}, child: Container(
          color: Colors.deepPurple,
          child: Image.network(
            "https://t4.ftcdn.net/jpg/01/05/90/77/240_F_105907729_4RzHYsHJ2UFt5koUI19fc6VzyFPEjeXe.jpg",
            width: 100,
            height: 100,
          ),
        ),),),
        body: Container(
          color: red,
          child: SingleChildScrollView(

            child: Column(

              children: [
                Text("${count}"),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      this.count = 50;

                      ap.play(AssetSource("music/Kick.wav"));


                    });
                  },
                  child: Container(
                    color: Colors.deepPurple,
                    child: Image.network(
                      "https://t4.ftcdn.net/jpg/01/05/90/77/240_F_105907729_4RzHYsHJ2UFt5koUI19fc6VzyFPEjeXe.jpg",
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      //this.count = 90;
                      this.count++;
                      temp = green;
                      green = red;
                      red = temp;
                    });
                  },
                  child: Container(
                    color: Colors.red,
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
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Center(
//             child: Text(
//               "My network image",
//               style: TextStyle(color: Colors.black, fontSize: 30),
//             ),
//           ),
//           elevation: 0.0,
//         ),
//         body: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               Container(
//                 color: Colors.red,
//                 child: Image.network(
//                   "https://t4.ftcdn.net/jpg/01/05/90/77/240_F_105907729_4RzHYsHJ2UFt5koUI19fc6VzyFPEjeXe.jpg",
//                   width: 200,
//                   height: 200,
//                 ),
//               ),
//               Positioned(
//                 right: 10,
//                 left: 10,
//                 child: Container(
//                   color: Colors.green,
//                   child: Image.network(
//                     "https://t4.ftcdn.net/jpg/01/05/90/77/240_F_105907729_4RzHYsHJ2UFt5koUI19fc6VzyFPEjeXe.jpg",
//                     width: 100,
//                     height: 100,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Scaffold(
// appBar: AppBar(
// title: Center(
// child: Text(
// "My network image",
// style: TextStyle(color: Colors.black, fontSize: 30),
// ),
// ),
// elevation: 0.0,
// ),
// body: SingleChildScrollView(
// scrollDirection: Axis.horizontal,
// child: Stack(
// alignment: Alignment.bottomRight,
// children: [
// Container(
// color: Colors.red,
// child: Image.network(
// "https://t4.ftcdn.net/jpg/01/05/90/77/240_F_105907729_4RzHYsHJ2UFt5koUI19fc6VzyFPEjeXe.jpg",
// width: 200,
// height: 200,
// ),
// ),
// Positioned(
// right: 10,
// left: 10,
// child: Container(
// color: Colors.green,
// child: Image.network(
// "https://t4.ftcdn.net/jpg/01/05/90/77/240_F_105907729_4RzHYsHJ2UFt5koUI19fc6VzyFPEjeXe.jpg",
// width: 100,
// height: 100,
// ),
// ),
// ),
// ],
// ),
// ),
// )

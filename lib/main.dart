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
  AudioPlayer ap = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: MaterialButton(onPressed: () {}, child: Text("Ttile")),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // number of items per row
            crossAxisCount: 4,
            // vertical spacing between the items
            mainAxisSpacing: 10,
            // horizontal spacing between the items
            crossAxisSpacing: 10,
          ),
          // number of items in your list
          itemCount: 28,
          itemBuilder: (BuildContext context, int index) {
            if (index % 2 == 0) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0xffADCBFC), Color(0xff067CCB)],
                    center: Alignment.center,
                    radius: 0.35,
                    // Increase for a wider red area
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: MaterialButton(
                  onPressed: () {
                    print("${index}");
                  },
                  child: Text("Change"),
                ),
              );
            }
            // else if (index % 3 == 0) {
            //   return Container(
            //     decoration: BoxDecoration(
            //       gradient: RadialGradient(
            //         colors: [Color(0xffff2525), Color(0xffc40050)],
            //         center: Alignment.center,
            //         radius: 0.35,
            //         // Increase for a wider red area
            //         stops: [0.0, 1.0],
            //         tileMode: TileMode.clamp,
            //       ),
            //     ),
            //     child: MaterialButton(
            //       onPressed: () {
            //         print("${index}");
            //       },
            //       child: Text("Change"),
            //     ),
            //   );
            // }
            // else if (index % 2 == 0) {
            //   return Container(
            //     decoration: BoxDecoration(
            //       gradient: RadialGradient(
            //         colors: [Color(0xffADCBFC), Color(0xff067CCB)],
            //         center: Alignment.center,
            //         radius: 0.35,
            //         // Increase for a wider red area
            //         stops: [0.0, 1.0],
            //         tileMode: TileMode.clamp,
            //       ),
            //     ),
            //     child: MaterialButton(
            //       onPressed: () {
            //         print("${index}");
            //       },
            //       child: Text("Change"),
            //     ),
            //   );
            // }
            else {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.red, Colors.green],
                    center: Alignment.center,
                    radius: 0.35,
                    // Increase for a wider red area
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: MaterialButton(
                  onPressed: () {
                    print("${index}");
                  },
                  child: Text("Change"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// 0xffADCBFC (center) 0xff067CCB (outline)
// 0xffff2525          0xffc40050
// 0xffE247FC          0xffA23AB7

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

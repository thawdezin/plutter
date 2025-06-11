// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   AudioPlayer ap = AudioPlayer();
//
//   var blueC = [Color(0xffADCBFC), Color(0xff067CCB)];
//   var pinkC = [Color(0xffE247FC), Color(0xffA23AB7)];
//   var redC = [Color(0xffff2525), Color(0xffc40050)];
//
//   var blueCO = [
//     Color(0xffADCBFC).withOpacity(0.5),
//     Color(0xff067CCB).withOpacity(0.5),
//   ];
//   var pinkCO = [
//     Color(0xffE247FC).withOpacity(0.5),
//     Color(0xffA23AB7).withOpacity(0.5),
//   ];
//   var redCO = [
//     Color(0xffff2525).withOpacity(0.5),
//     Color(0xffc40050).withOpacity(0.5),
//   ];
//
//   // var tempC = [Color(0xffADCBFC), Color(0xff067CCB)];
//   //
//   // var blueBackup = [Color(0xffADCBFC), Color(0xff067CCB)];
//   // var pinkBackup = [Color(0xffE247FC), Color(0xffA23AB7)];
//   // var redBackup = [Color(0xffff2525), Color(0xffc40050)];
//
//   List<List<Color>> itemColors = [];
//
//   @override
//   Widget build(BuildContext context) {
//     for (int i = 0; i < 28; i++) {
//       itemColors.add(blueC);
//     }
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: MaterialButton(onPressed: () {}, child: Text("")),
//         ),
//         body: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//
//             mainAxisSpacing: 10,
//
//             crossAxisSpacing: 10,
//           ),
//
//           itemCount: 28,
//           itemBuilder: (BuildContext context, int index) {
//             print(index);
//             if (index % 2 == 0) {
//               itemColors[index] = blueC;
//               var tempHolder = itemColors[index];
//               return Container(
//                 decoration: BoxDecoration(
//                   gradient: RadialGradient(
//                     colors: tempHolder,
//                     center: Alignment.center,
//                     radius: 0.35,
//                     // Increase for a wider red area
//                     stops: [0.0, 1.0],
//                     tileMode: TileMode.clamp,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: MaterialButton(
//                   onPressed: () {
//                     print(index);
//                     //ap.play(AssetSource("music/${++index}.mp3"));
//                     ap.play(AssetSource("${++index}.mp3"));
//                     print("$index");
//                     setState(() {
//                       tempHolder = blueCO;
//                       print("click");
//                       Future.delayed(const Duration(milliseconds: 400), () {
//                         setState(() {
//                           tempHolder = itemColors[index];
//                           print("done");
//                         });
//                       });
//                     });
//                   },
//                   child: Text(""),
//                 ),
//               );
//             } else if (++index % 4 == 0) {
//               itemColors[index] = pinkC;
//               var tempHolder = itemColors[index];
//               return Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   gradient: RadialGradient(
//                     colors: tempHolder,
//                     center: Alignment.center,
//                     radius: 0.35,
//                     // Increase for a wider red area
//                     stops: [0.0, 1.0],
//                     tileMode: TileMode.clamp,
//                   ),
//                 ),
//                 child: MaterialButton(
//                   onPressed: () {
//                     print(index);
//                     //ap.play(AssetSource("music/${++index}.mp3"));
//                     ap.play(AssetSource("${++index}.mp3"));
//                     print("$index");
//                     setState(() {
//                       tempHolder = pinkCO;
//                       print("click");
//                       Future.delayed(const Duration(milliseconds: 400), () {
//                         setState(() {
//                           tempHolder = itemColors[index];
//                           print("done");
//                         });
//                       });
//                     });
//                   },
//                   child: Text(""),
//                 ),
//               );
//             } else {
//               itemColors[index] = redC;
//               var tempHolder = itemColors[index];
//               return Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   gradient: RadialGradient(
//                     colors: tempHolder,
//                     center: Alignment.center,
//                     radius: 0.35,
//                     // Increase for a wider red area
//                     stops: [0.0, 1.0],
//                     tileMode: TileMode.clamp,
//                   ),
//                 ),
//                 child: MaterialButton(
//                   onPressed: () {
//                     print("$index");
//                     setState(() {
//                       print(index);
//                       //ap.play(AssetSource("music/${++index}.mp3"));
//                       ap.play(AssetSource("${++index}.mp3"));
//                       tempHolder = redCO;
//                       print("click");
//                       Future.delayed(const Duration(milliseconds: 400), () {
//                         setState(() {
//                           tempHolder = itemColors[index];
//                           print("done");
//                         });
//                       });
//                     });
//                   },
//                   child: Text(""),
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

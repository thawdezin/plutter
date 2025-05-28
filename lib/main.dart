import 'package:flutter/material.dart';
import 'package:plutter/counter_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(context.watch<CounterProvider>().counterValue.toString()),
              ElevatedButton(onPressed: (){
                context.read<CounterProvider>().incrementCounter();
              }, child: Text("+")),
              ElevatedButton(onPressed: (){
                context.read<CounterProvider>().decrementCounter();
              }, child: Text("-")),
            ],
          ),
        ),
      ),
    );
  }
}




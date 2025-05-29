import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plutter/counter_provider.dart';
import 'package:plutter/riverpod.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HelloWorldWidget(),
    );
  }
}

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(context.watch<CounterProvider>().counterValue.toString()),
              ElevatedButton(
                onPressed: () {
                  context.read<CounterProvider>().incrementCounter();
                },
                child: Text("+"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CounterProvider>().decrementCounter();
                },
                child: Text("-"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

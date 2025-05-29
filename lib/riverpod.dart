import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleApiPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simpleAsync = ref.watch(simpleFutureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Simple API')),
      body: Center(
        child: simpleAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
          data: (response) => Text(response.toString()),
        ),
      ),
    );
  }
}


class SimpleApiRepository {
  Future<SimpleResponse> fetchData() async {
    final response = await http.get(
      Uri.parse('https://crawl-scrape-test-website.vercel.app/api'),
    );

    if (response.statusCode == 200) {
      return SimpleResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}

final helloWorldProvider = Provider<String>((ref) {
  // ရိုးရိုး provider? ဒါဆို ဘာလို့ ထည့်နေသေးလဲ? gg
  return "Hello World";
});

class HelloWorldWidget extends ConsumerWidget {
  const HelloWorldWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helloWorld = ref.watch(helloWorldProvider);
    int counter = ref.watch(counterStateProvider);
    String showMyStateProvider = ref.read(myStateProvider.notifier).state;
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        final hw = ref.watch(helloWorldProvider);
        return Column(
          children: [
            Text("${helloWorld} and ${hw}"),
            Text("${counter} "),

            Text(showMyStateProvider),
            ElevatedButton(
              onPressed: () {
                ref.read(counterStateProvider.notifier).state++;
                ref.read(myStateProvider.notifier).state =
                    "${ref.read(myStateProvider.notifier).state} ${ref.watch(counterStateProvider)}";
              },
              child: Text("Click to change state"),
            ),
          ],
        );
      },
    );
  }
}

final counterStateProvider = StateProvider<int>((ref) {
  return 0;
});

final myStateProvider = StateProvider<String>((ref) {
  return "My init myStateProvider";
});

class SimpleResponse {
  final String message;

  SimpleResponse({required this.message});

  factory SimpleResponse.fromJson(Map<String, dynamic> json) {
    return SimpleResponse(message: json['message'] ?? '');
  }

  @override
  String toString() => message;
}

final simpleApiRepositoryProvider = Provider<SimpleApiRepository>((ref) {
  return SimpleApiRepository();
});

final simpleFutureProvider = FutureProvider.autoDispose<SimpleResponse>((ref) {
  final repo = ref.watch(simpleApiRepositoryProvider);
  return repo.fetchData();
});

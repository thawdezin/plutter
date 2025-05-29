import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

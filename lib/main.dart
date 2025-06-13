import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glassmorphic Nav Demo',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Calls Page', style: TextStyle(fontSize: 24, color: Colors.black))),
    Center(child: Text('Contacts Page', style: TextStyle(fontSize: 24, color: Colors.black))),
    Center(child: Text('Keypad Page', style: TextStyle(fontSize: 24, color: Colors.black))),
    Center(child: Text('Search Page', style: TextStyle(fontSize: 24, color: Colors.black))),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: const Text('iOS 26 Style Navigation')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: GlassmorphicBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class GlassmorphicBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const GlassmorphicBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<GlassmorphicBottomNavBar> createState() =>
      _GlassmorphicBottomNavBarState();
}

class _GlassmorphicBottomNavBarState extends State<GlassmorphicBottomNavBar> {
  double _dragOffset = 0;
  double _scale = 1;
  bool _canUpdate = true;

  final List<Map<String, dynamic>> _items = [
    {'icon': Icons.schedule, 'label': 'Calls'},
    {'icon': Icons.person, 'label': 'Contacts'},
    {'icon': Icons.dialpad, 'label': 'Keypad'},
    {'icon': Icons.search, 'label': 'Search'},
  ];

  @override
  void didUpdateWidget(covariant GlassmorphicBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _dragOffset = 0;
      _scale = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double totalW = MediaQuery.of(context).size.width - 32;
    const double hBar = 70, pillH = 80;
    final double itemW = totalW / _items.length;
    final double pillW = itemW * 1.2;
    final double pillX = widget.selectedIndex * itemW + (itemW - pillW)/2 + _dragOffset;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
      child: GestureDetector(
        onHorizontalDragStart: (_) => setState(() => _scale = 1.05),
        onHorizontalDragUpdate: (d) {
          if (!_canUpdate) return;
          _canUpdate = false;
          Future.delayed(const Duration(milliseconds: 16), () {
            setState(() {
              _dragOffset = (_dragOffset + d.primaryDelta!).clamp(
                -widget.selectedIndex * itemW,
                (_items.length - 1 - widget.selectedIndex) * itemW,
              );
            });
            _canUpdate = true;
          });
        },
        onHorizontalDragEnd: (e) {
          final deltaIndex = (_dragOffset / itemW).round();
          final newIndex = (widget.selectedIndex + deltaIndex)
              .clamp(0, _items.length - 1);
          widget.onItemTapped(newIndex);
          setState(() {
            _dragOffset = 0;
            _scale = 1;
          });
        },
        child: SizedBox(
          height: pillH,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background bar
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: hBar,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(color: Colors.black.withOpacity(0.1)),
                      ),
                    ),
                  ),
                ),
              ),

              // Navigation items
              Positioned.fill(
                child: Row(
                  children: List.generate(_items.length, (i) {
                    final item = _items[i];
                    final bool selected = i == widget.selectedIndex;
                    return Expanded(
                      child: InkWell(
                        onTap: () => widget.onItemTapped(i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(item['icon'], size: 24, color: Colors.black.withOpacity(selected ? 0.2 : 0.6)),
                            const SizedBox(height: 4),
                            Text(item['label'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(selected ? 0.2 : 0.6),
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Fast pill indicator
              RepaintBoundary(
                child: Transform.translate(
                  offset: Offset(pillX, 0),
                  child: Transform.scale(
                    scale: _scale,
                    child: _Pill(
                      icon: _items[widget.selectedIndex]['icon'],
                      label: _items[widget.selectedIndex]['label'],
                      width: pillW,
                    ),
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

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final double width;
  const _Pill({
    required this.icon,
    required this.label,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: Colors.blue),
                const SizedBox(height: 4),
                Text(label,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

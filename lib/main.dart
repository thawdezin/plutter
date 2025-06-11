import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS 26 Style Glassmorphism Navigation',
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
  final List<Widget> _pages = <Widget>[
    const Center(
      child: Text(
        'Calls Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    ),
    const Center(
      child: Text(
        'Contacts Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    ),
    const Center(
      child: Text(
        'Keypad Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    ),
    const Center(
      child: Text(
        'Search Page',
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    ),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

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
  double _dragOffset = 0.0;
  final List<Map<String, dynamic>> _items = [
    {'icon': Icons.schedule, 'label': 'Calls'},
    {'icon': Icons.person, 'label': 'Contacts'},
    {'icon': Icons.dialpad, 'label': 'Keypad'},
    {'icon': Icons.search, 'label': 'Search'},
  ];

  @override
  void didUpdateWidget(covariant GlassmorphicBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) _dragOffset = 0.0;
  }

  double _indicatorX(double width) {
    final int n = _items.length;
    final double itemW = width / n;
    final double pillW = itemW * 1.2;
    final base = widget.selectedIndex * itemW + (itemW - pillW) / 2;
    return base + _dragOffset;
  }

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width - 32;
    const double hBar = 70.0;
    const double pillH = 80.0;
    final double itemW = w / _items.length;
    final double pillW = itemW * 1.2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
      child: GestureDetector(
        onHorizontalDragUpdate:
            (d) => setState(() {
              _dragOffset = (_dragOffset + d.primaryDelta!).clamp(
                -widget.selectedIndex * itemW,
                (_items.length - 1 - widget.selectedIndex) * itemW,
              );
            }),
        onHorizontalDragEnd: (_) {
          final int deltaIndex = (_dragOffset / itemW).round();
          final int newIndex = (widget.selectedIndex + deltaIndex).clamp(
            0,
            _items.length - 1,
          );
          widget.onItemTapped(newIndex);
          setState(() => _dragOffset = 0);
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
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Navigation items
              //GlassContainer.clearGlass(
              //child:
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_items.length, (i) {
                    final item = _items[i];
                    final bool selected = i == widget.selectedIndex;
                    return Expanded(
                      child: InkWell(
                        onTap: () => widget.onItemTapped(i),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'],
                              size: 24,
                              color: Colors.black.withOpacity(
                                selected ? 0.2 : 0.6,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['label'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(
                                  selected ? 0.2 : 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                // ),
              ),

              // Pill indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: ((hBar - pillH) / 2),
                left: _indicatorX(w),
                width: pillW,
                height: pillH + 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: GlassContainer.clearGlass(child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: GlassContainer.clearGlass(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 3,
                            ),
                          ],
                        ),

                        child: GlassContainer.clearGlass(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _items[widget.selectedIndex]['icon'],
                              size: 28,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _items[widget.selectedIndex]['label'],
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                          ),
                        ),
                      ),
                    ),
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



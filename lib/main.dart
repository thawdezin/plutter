import 'dart:ui'; // Required for ImageFilter and BackdropFilter

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS 26 Style Glassmorphism Navigation',
      theme: ThemeData.dark().copyWith(
        // Set scaffold background to black for a dark UI theme to better show transparency
        scaffoldBackgroundColor: Colors.black,
        // Customize AppBar theme for a clean, transparent look
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0, // No shadow for the app bar
          centerTitle: true, // Center the app bar title
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
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
  // State variable to keep track of the currently selected navigation item
  int _selectedIndex = 0;

  // List of placeholder pages to display in the body of the Scaffold
  final List<Widget> _pages = <Widget>[
    const Center(child: Text('Calls Page', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('Contacts Page', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('Keypad Page', style: TextStyle(fontSize: 24, color: Colors.white))),
    const Center(child: Text('Search Page', style: TextStyle(fontSize: 24, color: Colors.white))),
  ];

  // Callback function to update the selected index when a navigation item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody property is crucial for glassmorphism effect.
      // It allows the body content to extend underneath the bottom navigation bar,
      // providing the necessary background for the BackdropFilter to blur.
      extendBody: true,
      appBar: AppBar(
        title: const Text('iOS 26 Style Navigation'),
      ),
      // Display the selected page in the body
      body: _pages[_selectedIndex],
      // Custom glassmorphic bottom navigation bar
      bottomNavigationBar: GlassmorphicBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// GlassmorphicBottomNavBar is now a StatefulWidget to manage drag state
class GlassmorphicBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const GlassmorphicBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<GlassmorphicBottomNavBar> createState() => _GlassmorphicBottomNavBarState();
}

class _GlassmorphicBottomNavBarState extends State<GlassmorphicBottomNavBar> {
  // Current horizontal drag offset from the initially selected item's position
  double _currentDragOffset = 0.0;

  // Data for navigation items (used for rendering both fixed items and the pill's content)
  final List<Map<String, dynamic>> _navItemsData = [
    {'icon': Icons.watch_later_outlined, 'label': 'Calls'},
    {'icon': Icons.person_outline, 'label': 'Contacts'},
    {'icon': Icons.apps_outlined, 'label': 'Keypad'},
    {'icon': Icons.search, 'label': 'Search'},
  ];

  @override
  void didUpdateWidget(covariant GlassmorphicBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When the selected index changes programmatically (e.g., via tap),
    // reset the drag offset so the pill snaps to the new position.
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      _currentDragOffset = 0.0;
    }
  }

  // Helper method to calculate the left position of the draggable indicator
  double _getIndicatorLeftPosition(double navBarWidth, int numItems) {
    final double itemWidth = navBarWidth / numItems;
    // Base position is the start of the currently selected item
    final double basePosition = widget.selectedIndex * itemWidth;
    // Add the current drag offset to the base position
    return basePosition + _currentDragOffset;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Calculate the width available for the inner row of items (excluding padding)
    final double innerNavBarWidth = screenWidth - (16.0 * 2); // 16.0 padding on each side
    final double itemWidth = innerNavBarWidth / _navItemsData.length;

    // Get the data for the currently selected item to display inside the pill
    final Map<String, dynamic> currentPillItemData = _navItemsData[widget.selectedIndex];

    return Padding(
      // Add padding to the navigation bar, pulling it away from the screen edges
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: GestureDetector(
        // GestureDetector on the entire navigation bar to capture horizontal drag events
        onHorizontalDragStart: (details) {
          // Reset drag offset when a new drag starts to ensure smooth relative movement
          setState(() {
            _currentDragOffset = 0.0;
          });
        },
        onHorizontalDragUpdate: (details) {
          setState(() {
            _currentDragOffset += details.primaryDelta!; // Accumulate drag delta

            // Clamp the drag offset to prevent the pill from going beyond the navigation bar limits
            _currentDragOffset = _currentDragOffset.clamp(
              // Max drag to the left: negative offset covering previous items
              -widget.selectedIndex * itemWidth,
              // Max drag to the right: positive offset covering remaining items
              (_navItemsData.length - 1 - widget.selectedIndex) * itemWidth,
            );
          });
        },
        onHorizontalDragEnd: (details) {
          // Calculate the target index based on the final drag offset and item width
          final double snapThreshold = itemWidth / 2; // Snap if dragged past half an item
          int newIndex = widget.selectedIndex;

          if (_currentDragOffset > snapThreshold) {
            // Dragged significantly to the right (visually moving left)
            newIndex = (widget.selectedIndex - (_currentDragOffset / itemWidth).round());
          } else if (_currentDragOffset < -snapThreshold) {
            // Dragged significantly to the left (visually moving right)
            newIndex = (widget.selectedIndex - (_currentDragOffset / itemWidth).round());
          }

          // Clamp the new index to ensure it's within valid bounds
          newIndex = newIndex.clamp(0, _navItemsData.length - 1);

          // If the index has changed, notify the parent and reset drag offset
          if (newIndex != widget.selectedIndex) {
            widget.onItemTapped(newIndex);
          }
          // Always reset drag offset after drag ends, so AnimatedPositioned snaps to the final index
          setState(() {
            _currentDragOffset = 0.0;
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0), // Apply rounded corners to the entire bar
          child: BackdropFilter(
            // Apply a significant blur to the background of the entire navigation bar
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 70, // Fixed height for the navigation bar
              decoration: BoxDecoration(
                // Translucent background color for the bar
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(30.0),
                // Subtle border to give it a more defined glass edge
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Stack(
                children: [
                  // Animated Draggable Indicator (The "pill")
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300), // Smooth animation for snapping
                    curve: Curves.easeInOut,
                    left: _getIndicatorLeftPosition(innerNavBarWidth, _navItemsData.length),
                    width: itemWidth, // Pill width is same as item width
                    height: 70, // Pill height is same as nav bar height
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E).withOpacity(0.7), // Darker, translucent background
                          borderRadius: BorderRadius.circular(25.0), // Rounded corners for the pill
                          boxShadow: [
                            // Blue glow effect when selected
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.6),
                              blurRadius: 20, // Stronger blur for a more prominent glow
                              spreadRadius: 3,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: BackdropFilter(
                            // Apply an inner blur to the selected item itself, creating the frosted glass look
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min, // Allows content to be snug
                              children: [
                                Icon(currentPillItemData['icon'], color: Colors.white, size: 24), // White icon
                                const SizedBox(width: 8), // Space between icon and text
                                Text(
                                  currentPillItemData['label'],
                                  style: const TextStyle(
                                    color: Colors.white, // White text
                                    fontSize: 14, // Slightly larger font for selected text
                                    fontWeight: FontWeight.bold, // Bold text
                                  ),
                                  overflow: TextOverflow.ellipsis, // Truncate long text with ellipsis
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Navigation Items (always visible and tappable)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(_navItemsData.length, (index) {
                      return _buildNavItem(
                        _navItemsData[index]['icon'],
                        _navItemsData[index]['label'],
                        index,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each individual navigation item (no pill logic here)
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = index == widget.selectedIndex;
    return Expanded(
      // Allows each item to take equal available horizontal space
      child: GestureDetector(
        onTap: () => widget.onItemTapped(index), // Handle tap to change selected index
        child: Column(
          // Centering the item content within its expanded space
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.6), // Transparent if selected (pill covers it)
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.6), // Transparent if selected
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

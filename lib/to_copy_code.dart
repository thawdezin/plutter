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

  // Define fixed dimensions for the draggable pill
  static const double _fixedPillWidth = 100.0; // Fixed width for the pill
  static const double _fixedPillHeight = 90.0; // Fixed height for the pill (already was)

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
    // Base position is the start of the currently selected item's slot
    final double basePosition = widget.selectedIndex * itemWidth;
    // Offset to center the fixed-width pill within its dynamically sized slot
    final double centeringOffset = (_fixedPillWidth - itemWidth) / 2;
    // Add the current drag offset to the base position, adjusted for centering
    return basePosition + _currentDragOffset - centeringOffset;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // Calculate the width available for the inner row of items (excluding padding)
    final double innerNavBarWidth = screenWidth - (16.0 * 2); // 16.0 padding on each side
    final double itemWidth = innerNavBarWidth / _navItemsData.length;

    // Calculate the top position to center the taller pill vertically within the 70.0 high bar
    // This value is negative because the pill starts ABOVE the main container's top edge
    final double pillTopOffset = (70.0 - _fixedPillHeight) / 2;

    // Get the data for the currently selected item to display inside the pill
    final Map<String, dynamic> currentPillItemData = _navItemsData[widget.selectedIndex];

    return Padding(
      // Add padding to the navigation bar, pulling it away from the screen edges
      // Increase bottom padding to ensure the overflowing pill doesn't get cut off by screen edge
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 30.0), // Increased bottom padding
      child: GestureDetector(
        // GestureDetector on the entire navigation bar to capture horizontal drag events
        onHorizontalDragStart: (details) {
          setState(() {
            _currentDragOffset = 0.0;
          });
        },
        onHorizontalDragUpdate: (details) {
          setState(() {
            _currentDragOffset += details.primaryDelta!; // Accumulate drag delta

            // Clamp the drag offset considering the fixed pill width
            _currentDragOffset = _currentDragOffset.clamp(
              // Max drag to the left: negative offset covering previous items, considering pill width
              -(widget.selectedIndex * itemWidth) + (_fixedPillWidth - itemWidth) / 2,
              // Max drag to the right: positive offset covering remaining items, considering pill width
              ((_navItemsData.length - 1 - widget.selectedIndex) * itemWidth) - (_fixedPillWidth - itemWidth) / 2,
            );
          });
        },
        onHorizontalDragEnd: (details) {
          final double snapThreshold = itemWidth / 2;
          int newIndex = widget.selectedIndex;

          // Calculate the target index based on the final drag offset and item width
          // Positive delta means dragging right, which visually moves the pill right, thus decreasing index.
          // Negative delta means dragging left, which visually moves the pill left, thus increasing index.
          if (_currentDragOffset > snapThreshold) {
            newIndex = (widget.selectedIndex - (_currentDragOffset / itemWidth).round());
          } else if (_currentDragOffset < -snapThreshold) {
            newIndex = (widget.selectedIndex - (_currentDragOffset / itemWidth).round());
          }

          newIndex = newIndex.clamp(0, _navItemsData.length - 1);

          if (newIndex != widget.selectedIndex) {
            widget.onItemTapped(newIndex);
          }
          setState(() {
            _currentDragOffset = 0.0;
          });
        },
        child: Container(
          // The total height of this container determines the effective height of the Stack
          // It needs to be tall enough to contain the overflowing pill
          height: _fixedPillHeight, // Now the container height is set to pill height
          child: Stack(
            clipBehavior: Clip.none, // Allow children to go outside the stack's bounds
            children: [
              // --- Background of the Navigation Bar ---
              Positioned.fill( // Fills the parent container
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0), // Rounded corners for the main bar
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Blur for the main bar
                    child: Container(
                      height: 70, // Fixed height for the visible part of the navigation bar
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08), // Translucent background
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                    ),
                  ),
                ),
              ),

              // --- Navigation Items (Static) ---
              // These items sit on top of the background, acting as tap targets
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_navItemsData.length, (index) {
                    return _buildNavItem(
                      _navItemsData[index]['icon'],
                      _navItemsData[index]['label'],
                      index,
                    );
                  }),
                ),
              ),

              // --- Animated Draggable Indicator (The "Pill") ---
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300), // Smooth animation for snapping
                curve: Curves.easeInOut,
                top: pillTopOffset, // Position vertically relative to the 70.0 high background
                left: _getIndicatorLeftPosition(innerNavBarWidth, _navItemsData.length),
                width: _fixedPillWidth, // Pill width is now fixed
                height: _fixedPillHeight, // Pill height is now fixed
                child: Center(
                  child: Container(
                    width: 90, // Explicitly setting the width of the pill's inner container
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.8),
                          blurRadius: 30,
                          spreadRadius: 6,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Row( // Changed from Column back to Row for horizontal layout
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(currentPillItemData['icon'], color: Colors.white, size: 28),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                currentPillItemData['label'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  // Helper method to build each individual navigation item (no pill logic here)
  Widget _buildNavItem(IconData icon, String label, int index) {
    // Note: The onTap is removed from here to prevent tap actions during drag
    final bool isSelected = index == widget.selectedIndex;
    return Expanded(
      child: Column( // This GestureDetector was removed.
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(isSelected ? 0.2 : 0.6),
            size: 24,
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(isSelected ? 0.2 : 0.6),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

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

class GlassmorphicBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const GlassmorphicBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add padding to the navigation bar, pulling it away from the screen edges
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribute items evenly
              children: [
                // Build individual navigation items
                _buildNavItem(Icons.watch_later_outlined, 'Calls', 0),
                _buildNavItem(Icons.person_outline, 'Contacts', 1),
                _buildNavItem(Icons.apps_outlined, 'Keypad', 2), // Changed icon for better representation
                _buildNavItem(Icons.search, 'Search', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build each individual navigation item
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = index == selectedIndex;
    return Expanded(
      // Allows each item to take equal available horizontal space
      child: GestureDetector(
        onTap: () => onItemTapped(index), // Handle tap to change selected index
        child: Column(
          // Centering the item content within its expanded space
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Smooth animation duration
              curve: Curves.easeInOut, // Animation curve for a natural feel
              // Adjust padding based on selection to make the pill larger when active
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16.0 : 8.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                // Background color for the pill, more opaque when selected
                color: isSelected
                    ? const Color(0xFF1E1E1E).withOpacity(0.7) // Darker, translucent when selected
                    : Colors.transparent, // Transparent when not selected
                borderRadius: BorderRadius.circular(25.0), // Rounded corners for the pill
                boxShadow: isSelected
                    ? [
                  // Blue glow effect when selected
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.6),
                    blurRadius: 20, // Stronger blur for a more prominent glow
                    spreadRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ]
                    : [], // No shadow when not selected
              ),
              child: isSelected
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: BackdropFilter(
                  // Apply an inner blur to the selected item itself, creating the frosted glass look
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Row(
                    // Icon and text arranged side-by-side when selected
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Removed mainAxisSize: MainAxisSize.min to allow Expanded to work
                    children: [
                      Icon(icon, color: Colors.white, size: 24), // White icon
                      const SizedBox(width: 8), // Space between icon and text
                      Expanded( // Added Expanded to text to prevent overflow
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white, // White text
                            fontSize: 14, // Slightly larger font for selected text
                            fontWeight: FontWeight.bold, // Bold text
                          ),
                          overflow: TextOverflow.ellipsis, // Truncate long text with ellipsis
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : Column(
                // Icon and text stacked vertically when not selected
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Make the Column take minimum vertical space
                children: [
                  Icon(icon, color: Colors.white.withOpacity(0.6), size: 24), // Subdued icon
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6), // Subdued text
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

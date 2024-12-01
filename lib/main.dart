import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const AndroidTvApp());
}

class AndroidTvApp extends StatelessWidget {
  const AndroidTvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Android TV App',
      theme: ThemeData(
        brightness: Brightness.dark, // Recommended for TV interfaces
        primarySwatch: Colors.blue,
        // TV-specific theme configurations
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 24),
        ),
      ),
      home: const MainTvScreen(),
    );
  }
}

class MainTvScreen extends StatefulWidget {
  const MainTvScreen({super.key});

  @override
  State<MainTvScreen> createState() => _MainTvScreenState();
}

class _MainTvScreenState extends State<MainTvScreen> {
  // Focus node for handling TV remote navigation
  final FocusNode _mainFocusNode = FocusNode();

  // Sample content for TV app
  final List<String> _menuItems = ['Movies', 'TV Shows', 'Settings', 'About'];

  // Currently selected menu item
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set up remote control handling
    KeyboardListener(
      focusNode: _mainFocusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          // Handle remote control navigation
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowDown:
              _navigateDown();
              break;
            case LogicalKeyboardKey.arrowUp:
              _navigateUp();
              break;
            case LogicalKeyboardKey.select:
              _selectMenuItem();
              break;
          }
        }
      },
      child: Container(), // Placeholder child
    );
  }

  void _navigateDown() {
    setState(() {
      _selectedIndex = (_selectedIndex + 1) % _menuItems.length;
    });
  }

  void _navigateUp() {
    setState(() {
      _selectedIndex =
          (_selectedIndex - 1 + _menuItems.length) % _menuItems.length;
    });
  }

  void _selectMenuItem() {
    // Handle menu item selection
    print('Selected: ${_menuItems[_selectedIndex]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side navigation menu
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: _menuItems
                .map((item) => NavigationRailDestination(
                      icon: const Icon(Icons.menu),
                      label: Text(item),
                    ))
                .toList(),
          ),

          // Main content area
          Expanded(
            child: Center(
              child: Text(
                'Welcome to ${_menuItems[_selectedIndex]}',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mainFocusNode.dispose();
    super.dispose();
  }
}

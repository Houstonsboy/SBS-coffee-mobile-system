import 'package:flutter/material.dart';
import 'orders.dart'; // Import OrdersScreen
import 'summer_coolers_screen.dart';
import 'winter_warmers_screen.dart';
import 'classic_drinks_screen.dart';
import 'signatures_screen.dart';

class BaristaDashboard extends StatefulWidget {
  const BaristaDashboard({Key? key}) : super(key: key);

  @override
  State<BaristaDashboard> createState() => _BaristaDashboardState();
}

class _BaristaDashboardState extends State<BaristaDashboard> {
  int _selectedIndex = 0;
  bool _isCollapsed = false; // Tracks sidebar state (collapsed or expanded)
  int? _hoveredIndex; // Tracks the index of the hovered item

  final List<Widget> _screens = const [
    OrdersScreen(),
    SummerCoolersScreen(),
    WinterWarmersScreen(),
    ClassicDrinksScreen(),
    SignaturesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isCollapsed ? 80 : 250,
            color: Colors.brown[800],
            child: Column(
              children: [
                // Sidebar header with toggle button
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: Colors.brown[700],
                  child: Row(
                    mainAxisAlignment: _isCollapsed
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (!_isCollapsed)
                        const Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      IconButton(
                        icon: Icon(
                          _isCollapsed
                              ? Icons.chevron_right
                              : Icons.chevron_left,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isCollapsed = !_isCollapsed;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Sidebar menu items
                Expanded(
                  child: ListView(
                    children: [
                      _buildMenuItem(
                        index: 0,
                        icon: Icons.receipt_long,
                        label: 'Orders',
                      ),
                      _buildMenuItem(
                        index: 1,
                        icon: Icons.wb_sunny,
                        label: 'Summer Coolers',
                      ),
                      _buildMenuItem(
                        index: 2,
                        icon: Icons.ac_unit,
                        label: 'Winter Warmers',
                      ),
                      _buildMenuItem(
                        index: 3,
                        icon: Icons.local_drink,
                        label: 'Classic Drinks',
                      ),
                      _buildMenuItem(
                        index: 4,
                        icon: Icons.star,
                        label: 'Signatures',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredIndex = null;
        });
      },
      child: InkWell(
        onTap: () {
          _onItemTapped(index);
        },
        child: Container(
          color: isSelected
              ? Colors.brown[600]
              : (isHovered ? Colors.brown[700] : Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(
                icon,
                color:
                    isSelected || isHovered ? Colors.white : Colors.grey[300],
              ),
              if (!_isCollapsed) ...[
                const SizedBox(width: 15.0),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected || isHovered
                        ? Colors.white
                        : Colors.grey[300],
                    fontSize: 16.0,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

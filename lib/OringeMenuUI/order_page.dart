// order_page.dart

import 'package:flutter/material.dart';
import 'favourites.dart';
import 'menu.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int _quantity = 1;
  double _sizeValue = 0.0;
  double _caffeineValue = 1.0;
  double _pickupValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Handle notification icon press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'images/icedTea.jpg',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Passion Iced Tea',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Ksh 380',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1
                                  ? () {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  : null,
                            ),
                            Text('$_quantity'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Natural chilled caffeine-free blend',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Size Slider
              const Text(
                'Size',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildSlider(
                value: _sizeValue,
                divisions: 1,
                labels: ['S', 'L'],
                onChanged: (value) {
                  setState(() {
                    _sizeValue = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Caffeine Slider
              const Text(
                'Caffeine',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildSlider(
                value: _caffeineValue,
                divisions: 2,
                labels: ['Low', 'Medium', 'High'],
                onChanged: (value) {
                  setState(() {
                    _caffeineValue = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Pickup Slider
              const Text(
                'Pickup',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildSlider(
                value: _pickupValue,
                divisions: 1,
                labels: ['STC', 'SBS'],
                onChanged: (value) {
                  setState(() {
                    _pickupValue = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Add to Order Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    // TODO: Handle add to order action
                  },
                  child: const Text(
                    'ADD TO ORDER',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 0, // Start at the 'Home' index
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to Home page
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              // Navigate to Menu page
              Navigator.push(
                // Use Navigator.push here
                context,
                MaterialPageRoute(builder: (context) => const MenuPage()),
              );
              break;
            case 2:
              // Navigate to Favourites page
              Navigator.push(
                // Use Navigator.push here
                context,
                MaterialPageRoute(builder: (context) => const FavouritesPage()),
              );
              break;
            case 3:
              // Navigate to Profile page
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
          // TODO: Handle navigation for other indices (Home, Menu, Profile)
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required double value,
    required int divisions,
    required List<String> labels,
    required Function(double) onChanged,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Stack(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 10,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 20,
                    disabledThumbRadius: 20,
                  ),
                  trackShape: const RoundedRectSliderTrackShape(),
                  activeTrackColor: Colors.brown,
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: Colors.brown,
                  overlayColor: Colors.brown.withOpacity(0.2),
                ),
                child: Slider(
                  value: value,
                  onChanged: onChanged,
                  min: 0,
                  max: divisions.toDouble(),
                  divisions: divisions,
                ),
              ),
              Positioned(
                left: value *
                    (MediaQuery.of(context).size.width - 32 - 40) /
                    divisions,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.brown,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.map((label) => Text(label)).toList(),
        ),
      ],
    );
  }
}

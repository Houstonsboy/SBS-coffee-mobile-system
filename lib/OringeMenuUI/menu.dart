import 'package:flutter/material.dart';
import 'favourites.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop Menu',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _selectedCategory = 'Classics';
  final Map<String, List<Map<String, dynamic>>> _menuItems = {
    'Classics': [
      {
        'name': 'Cappuccino',
        'price': 300,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Cappuccino',
        'price': 300,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Cappuccino',
        'price': 300,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Cappuccino',
        'price': 300,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Cappuccino',
        'price': 300,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Cappuccino',
        'price': 300,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Cappuccino',
        'price': 300,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Cappuccino',
        'price': 300,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      // Add more Classics items...
    ],
    'Smoothies': [
      {
        'name': 'Mango Smoothie',
        'price': 450,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Mango Smoothie',
        'price': 450,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Mango Smoothie',
        'price': 450,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Mango Smoothie',
        'price': 450,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Mango Smoothie',
        'price': 450,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Mango Smoothie',
        'price': 450,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Mango Smoothie',
        'price': 450,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Mango Smoothie',
        'price': 450,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      // Add more Smoothies items...
    ],
    'Winter Warmers': [
      {
        'name': 'Cuppa Chai Latte',
        'price': 200,
        'image': 'images/Coffee1.jpg',
        'availability': 'out of stock',
      },
      {
        'name': 'Snow White Hot Chocolate',
        'price': 280,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Snow White Hot Chocolate',
        'price': 280,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Snow White Hot Chocolate',
        'price': 280,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Snow White Hot Chocolate',
        'price': 280,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Snow White Hot Chocolate',
        'price': 280,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Snow White Hot Chocolate',
        'price': 280,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Snow White Hot Chocolate',
        'price': 280,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      // Add more Winter Warmers items...
    ],
    'Summer Coolers': [
      {
        'name': 'Iced Coffee',
        'price': 250,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Iced Coffee',
        'price': 250,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Iced Coffee',
        'price': 250,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Iced Coffee',
        'price': 250,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Iced Coffee',
        'price': 250,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Iced Coffee',
        'price': 250,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Iced Coffee',
        'price': 250,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Iced Coffee',
        'price': 250,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      // Add more Summer Coolers items...
    ],
    'Signatures': [
      {
        'name': 'Special Coffee',
        'price': 500,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Special Coffee',
        'price': 500,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Special Coffee',
        'price': 500,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Special Coffee',
        'price': 500,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Special Coffee',
        'price': 500,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Special Coffee',
        'price': 500,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Special Coffee',
        'price': 500,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      {
        'name': 'Special Coffee',
        'price': 500,
        'image': 'images/Coffee1.jpg',
        'availability': 'order now',
      },
      // Add more Signatures items...
    ],
  };

  final Map<String, String> _categoryImages = {
    'Classics': 'images/Cat-Classics.jpg',
    'Smoothies': 'images/Cat-Smoothies.jpg',
    'Winter Warmers': 'images/Cat-WinterWarmer.jpg',
    'Summer Coolers': 'images/Cat-SummerCoolers.jpg',
    'Signatures': 'images/Cat-Signatures.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag),
            onPressed: () {
              // TODO: Handle shopping bag icon press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Image
          SizedBox(
            width: MediaQuery.of(context).size.width, // Full screen width
            height: 250,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(100), // Adjust radius as needed
              ),
              child: Image.asset(
                _categoryImages[_selectedCategory]!,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),

          // Category Navigation Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _menuItems.keys.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.brown,
                    labelStyle: TextStyle(
                      color: _selectedCategory == category
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Menu Items List
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems[_selectedCategory]!.length,
              itemBuilder: (context, index) {
                final item = _menuItems[_selectedCategory]![index];
                return Card(
                  child: ListTile(
                    leading: Image.asset(item['image']),
                    title: Text(item['name']),
                    subtitle: Text('Ksh ${item['price']}'),
                    trailing: Text(
                      item['availability'],
                      style: TextStyle(
                        color: item['availability'] == 'order now'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 1, // Set current index to 1 for Menu
        onTap: (index) {
          // Implement navigation based on index
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
}

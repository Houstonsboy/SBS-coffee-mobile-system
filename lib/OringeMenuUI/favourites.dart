import 'package:flutter/material.dart';
import 'menu.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Map<String, dynamic>> favouriteItems = [
    {
      'name': 'Passion Iced Tea',
      'price': 380,
      'image': 'images/icedTea.jpg', // Replace with your image
    },
    {
      'name': 'Cappuccino',
      'price': 300,
      'image': 'images/Coffee1.jpg', // Replace with your image
    },
    // Add more favorite items here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: ListView.builder(
        itemCount: favouriteItems.length,
        itemBuilder: (context, index) {
          final item = favouriteItems[index];
          return Card(
            child: ListTile(
              leading: Image.asset(item['image']),
              title: Text(item['name']),
              subtitle: Text('Ksh ${item['price']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // TODO: Remove item from favorites
                  setState(() {
                    favouriteItems.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 2, // Set current index to 2 for Favourites
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

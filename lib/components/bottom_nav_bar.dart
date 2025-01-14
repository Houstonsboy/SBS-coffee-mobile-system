import 'package:coffee_system/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget 
{
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GNav(
      rippleColor: Colors.white, // tab button ripple color when pressed
      hoverColor:Colors.white, // tab button hover color
      haptic: true, // haptic feedback
      tabBorderRadius: 15, 
      tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
      curve: Curves.easeOutExpo, // tab animation curves
      duration: Duration(milliseconds: 100), // tab animation duration
      gap: 8, // the tab button gap between icon and text 
      color: Colors.grey[800], // unselected icon color
      activeColor: primaryColor, // selected icon and text color
      iconSize: 24, // tab button icon size
      tabBackgroundColor: secondaryColor, // selected tab background color
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
      tabs: [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.menu,
          text: 'Menu',
        ),
        GButton(
          icon: Icons.receipt,
          text: 'Receipts',
        ),
        GButton(
          icon: Icons.person,
          text: 'Profile',
        ),
      ]);
  }
}
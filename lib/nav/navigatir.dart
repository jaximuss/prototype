import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:prototype/main.dart';
import 'package:prototype/screens/resultScreen.dart';
import 'forum.dart';

class NavigationTab extends StatefulWidget {
  const NavigationTab({super.key});
  @override
  _Navigator createState() => _Navigator();
}

class _Navigator extends State<NavigationTab> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    //const MainMenu(),//const settings(),
    DashboardScreen(),
    const ForumScreen(),

  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.discover),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.people),
            label: 'communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Iconsax.setting),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: dark?  Colors.white : Colors.purple,
        unselectedItemColor: dark? Colors.white : Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}




//global navigation bar
import 'package:flutter/material.dart';
import 'package:maaakanmoney/components/constants.dart';

enum BottomNavType { standard, floating, labeled }

class GlobalBottomNav extends StatefulWidget {
  final BottomNavType type;
  final int currentIndex;
  final Function(int) onTap;

  const GlobalBottomNav({
    Key? key,
    required this.type,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _GlobalBottomNavState createState() => _GlobalBottomNavState();
}

class _GlobalBottomNavState extends State<GlobalBottomNav> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case BottomNavType.standard:
        return BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: widget.onTap,
          selectedItemColor: Constants.colorFoodCPrimary, // Color for selected item
          unselectedItemColor: Constants.colorFoodCSecondaryGrey3,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home,color: widget.currentIndex == 0 ? Constants.colorFoodCPrimary : Colors.grey), label: 'Home',),
             BottomNavigationBarItem(icon: Icon(Icons.shopping_cart,color: widget.currentIndex == 0 ? Colors.grey : Constants.colorFoodCPrimary), label: 'Cart'),
            // BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );

      case BottomNavType.floating:
        return BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: Icon(Icons.home), onPressed: () => widget.onTap(0)),
              SizedBox(width: 40),
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => widget.onTap(1)),
            ],
          ),
        );

      case BottomNavType.labeled:
        return BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: widget.onTap,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        );
    }
  }
}
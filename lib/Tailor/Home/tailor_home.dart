import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges; // Add a prefix to the badges package
import 'package:tailormade/Tailor/Status/completed_status/completed_order.dart';
import 'package:tailormade/Tailor/Status/current_status/current_order.dart';
import 'package:tailormade/utils/helpers/helper_functions.dart';
import '../../utils/constants/colors.dart';
import '../Status/active_status/active_order.dart';

class TailorHomeScreen extends StatefulWidget {
  const TailorHomeScreen({super.key});

  @override
  _TailorHomeScreenState createState() => _TailorHomeScreenState();
}

class _TailorHomeScreenState extends State<TailorHomeScreen> {
  int _selectedIndex = 1; // Default to 'Current'

  // Example counts for active, current, and completed orders
  int activeOrderCount = 1;
  // int currentOrderCount = 3;
  // int completedOrderCount = 10;

  final List<Widget> _pages = [
    TActiveOrders(),
    TCurrentOrders(),
    TCompletedOrders(),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunction.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logos/logo11.png',
          height: 40,
        ),
        centerTitle: true,
        backgroundColor: dark ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: dark ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            color: dark ? Colors.white : Colors.black,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 0),
                child: badges.Badge(
                  showBadge: activeOrderCount > 0,
                  badgeContent: Text(
                    activeOrderCount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  badgeStyle: badges.BadgeStyle(badgeColor: Colors.brown),
                  child: Text('Active',
                      style: TextStyle(
                          color: _selectedIndex == 0
                              ? (dark ? Colors.white : TColors.darkerGrey)
                              : (dark ? Colors.grey : Colors.black),
                          fontSize: 16,
                          fontWeight: _selectedIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal)),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 1),
                child: Text('Current',
                    style: TextStyle(
                        color: _selectedIndex == 1
                            ? (dark ? Colors.white : TColors.darkerGrey)
                            : (dark ? Colors.grey : Colors.black),
                        fontSize: 16,
                        fontWeight: _selectedIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal)),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 2),
                child: Text('Completed',
                    style: TextStyle(
                        color: _selectedIndex == 2
                            ? (dark ? Colors.white : TColors.darkerGrey)
                            : (dark ? Colors.grey : Colors.black),
                        fontSize: 16,
                        fontWeight: _selectedIndex == 2
                            ? FontWeight.bold
                            : FontWeight.normal)),
              ),
            ],
          ),
          Expanded(child: _pages[_selectedIndex]),
          const SizedBox(height: 10),
        ],
      ),
      backgroundColor: dark ? Colors.black : Colors.white,
    );
  }
}
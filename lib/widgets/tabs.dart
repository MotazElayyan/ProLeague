import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:grad_project/screens/pages/FavTeams.dart';
import 'package:grad_project/screens/pages/newsPage.dart';
import 'package:grad_project/screens/pages/profilePage.dart';
import 'package:grad_project/screens/pages/statsPage.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({super.key});

  @override
  ConsumerState<Tabs> createState() => _TabsState();
}

class _TabsState extends ConsumerState<Tabs> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const NewsPage();
    String activePageTitle = 'News';

    if (_selectedPageIndex == 1) {
      activePage = const FavTeamsScreen();
      activePageTitle = 'Favourites';
    } else if (_selectedPageIndex == 2) {
      activePage = const StatsPage();
      activePageTitle = 'Statistics';
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(activePageTitle),
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: activePage,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.primaryContainer,
        animationDuration: const Duration(milliseconds: 400),
        onTap: _selectPage,
        index: _selectedPageIndex,
        items: [
          const Icon(Icons.newspaper),
          Image.asset('assets/images/logo1.png', width: 30, height: 30),
          const Icon(Icons.bar_chart),
        ],
      ),
    );
  }
}

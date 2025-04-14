import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:grad_project/screens/pages/FavTeams.dart';

import 'package:grad_project/screens/pages/newsPage.dart';
import 'package:grad_project/screens/pages/profilePage.dart';
import 'package:grad_project/screens/pages/statsPage.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() {
    return _TabsState();
  }
}

class _TabsState extends State<Tabs> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const NewsPage();
    var activePageTitle = 'News';

    if (_selectedPageIndex == 1) {
      activePage = const FavTeams();
      activePageTitle = 'Favourites';
    }

    if (_selectedPageIndex == 2) {
      activePage = const StatsPage();
      activePageTitle = 'Statistics';
    }

    /*if (_selectedPageIndex == 3) {
      activePage = const ProfilePage();
      activePageTitle = 'Profile';
    }*/

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
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => ProfilePage()),
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
        animationDuration: Duration(milliseconds: 400),
        onTap: _selectPage,
        index: _selectedPageIndex,
        items: [
          Icon(Icons.newspaper),
          Image.asset('assets/images/logo1.png', width: 30, height: 30),
          Icon(Icons.bar_chart),
        ],
      ),
    );
  }
}

      /*bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.newspaper,
              color: Theme.of(context).colorScheme.secondary,
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/logo1.png', width: 30, height: 30),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart,
              color: Theme.of(context).colorScheme.secondary,
            ),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.secondary,
            ),
            label: 'Profile',
          ),
        ],
      ),*/
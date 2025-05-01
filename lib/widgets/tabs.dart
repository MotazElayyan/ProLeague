import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad_project/providers/favoritesProvider.dart';

import 'package:grad_project/screens/pages/FavTeams.dart';
import 'package:grad_project/screens/pages/newsPage.dart';
import 'package:grad_project/screens/pages/statsPage.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({super.key});

  @override
  ConsumerState<Tabs> createState() => _TabsState();
}

class _TabsState extends ConsumerState<Tabs> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteTeamsProvider.notifier).loadFavorites();
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const NewsPage();

    if (_selectedPageIndex == 1) {
      activePage = const FavTeamsScreen();
    } else if (_selectedPageIndex == 2) {
      activePage = const StatsPage();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
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

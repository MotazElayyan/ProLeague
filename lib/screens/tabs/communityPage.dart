import 'package:flutter/material.dart';

import 'package:grad_project/screens/pages/AllusersPage.dart';
import 'package:grad_project/widgets/buildDrawer.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text('Community', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.chat_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => const Users()));
            },
          ),
        ],
      ),
      drawer: BuildDrawer(),
      body: const Center(child: Text('posts & more')),
    );
  }
}

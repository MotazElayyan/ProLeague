import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grad_project/core/widgets/tableWidgets.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text('Table', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Table').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No table data available.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final teams =
              snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

          teams.sort((a, b) {
            final pointsA = a['points'] ?? 0;
            final pointsB = b['points'] ?? 0;
            if (pointsA != pointsB) return pointsB.compareTo(pointsA);

            final gdA = a['goalDifference'] ?? 0;
            final gdB = b['goalDifference'] ?? 0;
            if (gdA != gdB) return gdB.compareTo(gdA);

            final wonA = a['won'] ?? 0;
            final wonB = b['won'] ?? 0;
            return wonB.compareTo(wonA);
          });

          for (final team in teams) {
            print(
              'Team: ${team['team']}, Points: ${team['points']}, Won: ${team['won']}',
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                header(context),
                ...List.generate(teams.length, (index) {
                  final team = teams[index];
                  return teamRow(context, team, index + 1);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

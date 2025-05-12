import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grad_project/teamsData/teamSheet.dart';

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
                _buildHeader(context),
                ...List.generate(teams.length, (index) {
                  final team = teams[index];
                  return _buildTeamRow(context, team, index + 1);
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: const [
          _HeaderCell('Pos', width: 50),
          _HeaderCell('Club', width: 100),
          _HeaderCell('PL', width: 40),
          _HeaderCell('W', width: 40),
          _HeaderCell('D', width: 40),
          _HeaderCell('L', width: 40),
          _HeaderCell('GD', width: 50),
          _HeaderCell('Pts', width: 50),
        ],
      ),
    );
  }

  Widget _buildTeamRow(
    BuildContext context,
    Map<String, dynamic> team,
    int position,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (ctx) => TeamSheet(
                  teamName: team['team'] ?? '',
                  logoUrl: team['team-logo'] ?? '',
                ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            _DataCell('$position', width: 50),
            SizedBox(
              width: 100,
              child: Row(
                children: [
                  if ((team['team-logo'] ?? '').toString().isNotEmpty)
                    Image.network(
                      team['team-logo'],
                      width: 24,
                      height: 24,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 20),
                    ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      team['team'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            _DataCell('${team['played'] ?? 0}', width: 40),
            _DataCell('${team['won'] ?? 0}', width: 40),
            _DataCell('${team['drawn'] ?? 0}', width: 40),
            _DataCell('${team['lost'] ?? 0}', width: 40),
            _DataCell('${team['goalDifference'] ?? 0}', width: 50),
            _DataCell('${team['points'] ?? 0}', width: 50, bold: true),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final double width;
  const _HeaderCell(this.text, {required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  final double width;
  final bool bold;
  const _DataCell(this.text, {required this.width, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

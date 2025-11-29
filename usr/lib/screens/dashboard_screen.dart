import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/project.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Re-fetch data on build to show updates after returning from other screens
    final projects = MockData.projects;
    final activeProjects = projects.where((p) => p.status != 'Tape-out').length;
    final upcomingTapeouts = projects.where((p) => p.tapeOutDate.difference(DateTime.now()).inDays < 60 && p.tapeOutDate.isAfter(DateTime.now())).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RFIC Manager Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSummaryCard(context, 'Active Projects', activeProjects.toString(), Icons.developer_board, Colors.blue),
                const SizedBox(width: 16),
                _buildSummaryCard(context, 'Upcoming Tape-outs', upcomingTapeouts.toString(), Icons.timer, Colors.orange),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('LNA-5G-Sub6 passed DRC'),
                subtitle: const Text('2 hours ago'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: const Text('PA-XBand-Radar Gain Spec Failed'),
                subtitle: const Text('5 hours ago - Simulation Corner SS'),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/projects').then((_) => setState(() {}));
                },
                icon: const Icon(Icons.list),
                label: const Text('View All Projects'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/project_edit').then((_) => setState(() {}));
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

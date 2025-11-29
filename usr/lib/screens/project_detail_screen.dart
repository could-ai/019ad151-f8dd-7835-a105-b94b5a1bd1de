import 'package:flutter/material.dart';
import '../models/project.dart';
import '../data/mock_data.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({super.key});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context)!.settings.arguments as Project;
    // Get fresh data in case it was edited
    final freshProject = MockData.projects.firstWhere(
      (p) => p.id == project.id, 
      orElse: () => project
    );
    final specs = MockData.getSpecsForProject(freshProject.id);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(freshProject.name),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.pushNamed(
                  context, 
                  '/project_edit', 
                  arguments: freshProject
                );
                setState(() {}); // Refresh after edit
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Specs'),
              Tab(text: 'Timeline'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(context, freshProject),
            _buildSpecsTab(context, specs),
            _buildTimelineTab(context, freshProject),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, Project project) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Project Details'),
          _buildDetailRow('Description', project.description),
          _buildDetailRow('Technology', project.technologyNode),
          _buildDetailRow('Frequency Range', '${project.frequencyStart} - ${project.frequencyStop} GHz'),
          _buildDetailRow('Status', project.status),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Team'),
          const ListTile(
            leading: CircleAvatar(child: Text('JD')),
            title: Text('John Doe'),
            subtitle: Text('Lead Designer'),
          ),
          const ListTile(
            leading: CircleAvatar(child: Text('AS')),
            title: Text('Alice Smith'),
            subtitle: Text('Layout Engineer'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecsTab(BuildContext context, List<Specification> specs) {
    if (specs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No specifications defined yet.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement add spec
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Spec feature coming next')));
              },
              child: const Text('Add Specification'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: specs.length,
      itemBuilder: (context, index) {
        final spec = specs[index];
        final isPassing = spec.currentSimulated != null && 
            ((spec.name.contains('Noise') || spec.name.contains('Power')) 
                ? spec.currentSimulated! <= spec.target 
                : spec.currentSimulated! >= spec.target);
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(spec.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Target: ${spec.target} ${spec.unit}'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Current Simulated:'),
                    Row(
                      children: [
                        Text(
                          '${spec.currentSimulated ?? "N/A"} ${spec.unit}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isPassing ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isPassing ? Icons.check_circle : Icons.warning,
                          color: isPassing ? Colors.green : Colors.red,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimelineTab(BuildContext context, Project project) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTimelineItem(
          title: 'Project Kickoff',
          date: '2023-01-15',
          isCompleted: true,
        ),
        _buildTimelineItem(
          title: 'Schematic Freeze',
          date: '2023-03-01',
          isCompleted: true,
        ),
        _buildTimelineItem(
          title: 'Layout Start',
          date: '2023-03-05',
          isCompleted: true,
        ),
        _buildTimelineItem(
          title: 'Tape-out',
          date: project.tapeOutDate.toString().split(' ')[0],
          isCompleted: false,
          isMajor: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem({required String title, required String date, required bool isCompleted, bool isMajor = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.green : (isMajor ? Colors.red : Colors.grey),
                ),
              ),
              Container(
                width: 2,
                height: 40,
                color: Colors.grey[300],
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              color: isMajor ? Colors.red[50] : null,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isMajor ? Colors.red : Colors.black)),
                    Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.indigo,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

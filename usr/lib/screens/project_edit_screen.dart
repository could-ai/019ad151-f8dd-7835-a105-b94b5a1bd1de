import 'package:flutter/material.dart';
import '../models/project.dart';
import '../data/mock_data.dart';

class ProjectEditScreen extends StatefulWidget {
  const ProjectEditScreen({super.key});

  @override
  State<ProjectEditScreen> createState() => _ProjectEditScreenState();
}

class _ProjectEditScreenState extends State<ProjectEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _techNodeController;
  late TextEditingController _freqStartController;
  late TextEditingController _freqStopController;
  
  DateTime _tapeOutDate = DateTime.now().add(const Duration(days: 90));
  String _status = 'Planning';
  bool _isEditing = false;
  String? _projectId;

  final List<String> _statusOptions = [
    'Planning',
    'Design',
    'Layout',
    'Verification',
    'Tape-out',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Project) {
      _isEditing = true;
      _projectId = args.id;
      _nameController = TextEditingController(text: args.name);
      _descController = TextEditingController(text: args.description);
      _techNodeController = TextEditingController(text: args.technologyNode);
      _freqStartController = TextEditingController(text: args.frequencyStart.toString());
      _freqStopController = TextEditingController(text: args.frequencyStop.toString());
      _tapeOutDate = args.tapeOutDate;
      _status = args.status;
    } else {
      _nameController = TextEditingController();
      _descController = TextEditingController();
      _techNodeController = TextEditingController();
      _freqStartController = TextEditingController();
      _freqStopController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _techNodeController.dispose();
    _freqStartController.dispose();
    _freqStopController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tapeOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _tapeOutDate) {
      setState(() {
        _tapeOutDate = picked;
      });
    }
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      final newProject = Project(
        id: _projectId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descController.text,
        technologyNode: _techNodeController.text,
        frequencyStart: double.tryParse(_freqStartController.text) ?? 0.0,
        frequencyStop: double.tryParse(_freqStopController.text) ?? 0.0,
        tapeOutDate: _tapeOutDate,
        status: _status,
      );

      if (_isEditing) {
        // Find and replace in mock data
        final index = MockData.projects.indexWhere((p) => p.id == _projectId);
        if (index != -1) {
          MockData.projects[index] = newProject;
        }
      } else {
        // Add to mock data
        MockData.projects.add(newProject);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Project updated' : 'Project created')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Project' : 'New Project'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProject,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Basic Info'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle('Technical Details'),
              TextFormField(
                controller: _techNodeController,
                decoration: const InputDecoration(
                  labelText: 'Technology Node (e.g., 28nm CMOS)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.memory),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter technology node' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _freqStartController,
                      decoration: const InputDecoration(
                        labelText: 'Freq Start (GHz)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _freqStopController,
                      decoration: const InputDecoration(
                        labelText: 'Freq Stop (GHz)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Status & Timeline'),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Current Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tape-out Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    "${_tapeOutDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(_isEditing ? 'Update Project' : 'Create Project'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }
}

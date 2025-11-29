import '../models/project.dart';

class MockData {
  static List<Project> projects = [
    Project(
      id: '1',
      name: 'LNA-5G-Sub6',
      description: 'Low Noise Amplifier for 5G Sub-6GHz applications.',
      technologyNode: '28nm CMOS',
      frequencyStart: 3.3,
      frequencyStop: 4.2,
      tapeOutDate: DateTime.now().add(const Duration(days: 45)),
      status: 'Layout',
    ),
    Project(
      id: '2',
      name: 'PA-XBand-Radar',
      description: 'High efficiency Power Amplifier for X-Band Radar.',
      technologyNode: '0.15um GaN',
      frequencyStart: 8.0,
      frequencyStop: 12.0,
      tapeOutDate: DateTime.now().add(const Duration(days: 120)),
      status: 'Design',
    ),
    Project(
      id: '3',
      name: 'Mixer-Wideband',
      description: 'Wideband active mixer for instrumentation.',
      technologyNode: '65nm CMOS',
      frequencyStart: 0.1,
      frequencyStop: 20.0,
      tapeOutDate: DateTime.now().subtract(const Duration(days: 10)),
      status: 'Verification',
    ),
  ];

  static List<Specification> getSpecsForProject(String projectId) {
    if (projectId == '1') {
      return [
        Specification(name: 'Gain', unit: 'dB', target: 15.0, currentSimulated: 14.8),
        Specification(name: 'Noise Figure', unit: 'dB', target: 1.5, currentSimulated: 1.6),
        Specification(name: 'IIP3', unit: 'dBm', target: -5.0, currentSimulated: -4.5),
        Specification(name: 'Power Consumption', unit: 'mW', target: 10.0, currentSimulated: 9.2),
      ];
    }
    return [];
  }
}

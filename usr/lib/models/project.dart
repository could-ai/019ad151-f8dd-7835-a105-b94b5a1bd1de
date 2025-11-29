class Project {
  final String id;
  final String name;
  final String description;
  final String technologyNode; // e.g., 28nm CMOS, 65nm, GaN
  final double frequencyStart; // in GHz
  final double frequencyStop; // in GHz
  final DateTime tapeOutDate;
  final String status; // Planning, Design, Layout, Verification, Tape-out

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.technologyNode,
    required this.frequencyStart,
    required this.frequencyStop,
    required this.tapeOutDate,
    required this.status,
  });
}

class Specification {
  final String name;
  final String unit;
  final double target;
  final double? currentSimulated;
  final double? measured;

  Specification({
    required this.name,
    required this.unit,
    required this.target,
    this.currentSimulated,
    this.measured,
  });
}

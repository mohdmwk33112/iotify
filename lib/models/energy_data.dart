class EnergyData {
  final double consumption;
  final DateTime timestamp;

  EnergyData({
    required this.consumption,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'consumption': consumption,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory EnergyData.fromMap(Map<String, dynamic> map) {
    return EnergyData(
      consumption: map['consumption']?.toDouble() ?? 0.0,
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
} 
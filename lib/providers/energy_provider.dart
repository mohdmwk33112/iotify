import 'package:flutter/foundation.dart';
import 'dart:math';

class EnergyProvider with ChangeNotifier {
  final Map<String, List<EnergyData>> _deviceEnergyData = {};
  final Map<String, List<EnergyData>> _roomEnergyData = {};
  
  // Simulated data for demo purposes
  void initializeData(String deviceId, String roomName) {
    if (!_deviceEnergyData.containsKey(deviceId)) {
      _deviceEnergyData[deviceId] = _generateEnergyData();
    }
    if (!_roomEnergyData.containsKey(roomName)) {
      _roomEnergyData[roomName] = _generateEnergyData();
    }
    notifyListeners();
  }

  List<EnergyData> _generateEnergyData() {
    final random = Random();
    final now = DateTime.now();
    final List<EnergyData> data = [];
    
    for (int i = 0; i < 24; i++) {
      final timestamp = now.subtract(Duration(hours: 23 - i));
      final consumption = random.nextDouble() * 1000; // Watts
      final cost = consumption * 0.15 / 1000; // Assuming $0.15 per kWh
      
      data.add(EnergyData(
        timestamp: timestamp,
        consumption: consumption,
        cost: cost,
      ));
    }
    
    return data;
  }

  List<EnergyData> getDeviceEnergyData(String deviceId) {
    return _deviceEnergyData[deviceId] ?? [];
  }

  List<EnergyData> getRoomEnergyData(String roomName) {
    return _roomEnergyData[roomName] ?? [];
  }

  double getTotalConsumption(String deviceId) {
    final data = getDeviceEnergyData(deviceId);
    return data.fold(0.0, (double sum, item) => sum + item.consumption) / 1000; // Convert to kWh
  }

  double getCurrentConsumption(String deviceId) {
    final data = getDeviceEnergyData(deviceId);
    if (data.isEmpty) return 0;
    return data.last.consumption; // Current consumption in Watts
  }

  double getTotalCost(String deviceId) {
    final data = getDeviceEnergyData(deviceId);
    return data.fold(0, (sum, item) => sum + item.cost);
  }

  double getRoomTotalConsumption(String roomName) {
    final data = getRoomEnergyData(roomName);
    return data.fold(0, (sum, item) => sum + item.consumption);
  }

  double getRoomTotalCost(String roomName) {
    final data = getRoomEnergyData(roomName);
    return data.fold(0, (sum, item) => sum + item.cost);
  }

  DateTime getPeakUsageTime(String roomName) {
    final data = getRoomEnergyData(roomName);
    if (data.isEmpty) return DateTime.now();
    
    var peakTime = data[0].timestamp;
    var peakConsumption = data[0].consumption;
    
    for (var item in data) {
      if (item.consumption > peakConsumption) {
        peakConsumption = item.consumption;
        peakTime = item.timestamp;
      }
    }
    
    return peakTime;
  }

  double getEfficiencyScore(String deviceId) {
    // Simulated efficiency score (0-100)
    final random = Random();
    return random.nextDouble() * 100;
  }

  Map<String, double> getUptimeDowntime(String deviceId) {
    final data = getDeviceEnergyData(deviceId);
    double uptime = 0;
    double downtime = 0;
    
    for (var item in data) {
      if (item.consumption > 0) {
        uptime += 1;
      } else {
        downtime += 1;
      }
    }
    
    return {
      'uptime': uptime,
      'downtime': downtime,
    };
  }

  Map<String, double> getPowerAndCostSaved(String deviceId) {
    final data = getDeviceEnergyData(deviceId);
    double powerSaved = 0;
    double costSaved = 0;
    
    // Calculate potential savings based on optimal usage patterns
    for (var item in data) {
      if (item.consumption > 500) { // Assuming 500W as threshold for high consumption
        powerSaved += (item.consumption - 500);
        costSaved += (item.consumption - 500) * 0.15 / 1000; // $0.15 per kWh
      }
    }
    
    return {
      'powerSaved': powerSaved,
      'costSaved': costSaved,
    };
  }
}

class EnergyData {
  final DateTime timestamp;
  final double consumption; // in Watts
  final double cost; // in dollars

  EnergyData({
    required this.timestamp,
    required this.consumption,
    required this.cost,
  });
} 
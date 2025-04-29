import 'package:flutter/material.dart';

class RoomProvider with ChangeNotifier {
  final List<String> _rooms = [];
  final List<Map<String, dynamic>> _devices = [];

  List<String> get rooms => List.unmodifiable(_rooms);
  List<Map<String, dynamic>> get devices => List.unmodifiable(_devices);

  void addRoom(String roomName) {
    if (roomName.isNotEmpty && !_rooms.contains(roomName)) {
      _rooms.add(roomName);
      notifyListeners();
    }
  }

  void deleteRoom(String roomName) {
    if (_rooms.contains(roomName)) {
      _rooms.remove(roomName);
      // Move devices from deleted room to 'All'
      for (var device in _devices) {
        if (device['room'] == roomName) {
          device['room'] = 'All';
        }
      }
      notifyListeners();
    }
  }

  void addDevice(Map<String, dynamic> device) {
    if (!_devices.any((d) => d['id'] == device['id'])) {
      _devices.add(device);
      notifyListeners();
    }
  }

  void deleteDevice(String deviceId) {
    _devices.removeWhere((device) => device['id'] == deviceId);
    notifyListeners();
  }

  void toggleDevice(String deviceId) {
    final index = _devices.indexWhere((device) => device['id'] == deviceId);
    if (index != -1) {
      _devices[index]['isOn'] = !_devices[index]['isOn'];
      notifyListeners();
    }
  }

  void updateDeviceRoom(String deviceId, String newRoom) {
    if (newRoom != 'All' && !_rooms.contains(newRoom)) {
      addRoom(newRoom);
    }
    final index = _devices.indexWhere((device) => device['id'] == deviceId);
    if (index != -1) {
      _devices[index]['room'] = newRoom;
      notifyListeners();
    }
  }

  void updateDeviceName(String deviceId, String newName) {
    final index = _devices.indexWhere((device) => device['id'] == deviceId);
    if (index != -1) {
      _devices[index]['name'] = newName;
      notifyListeners();
    }
  }

  void updateDeviceButtons(String deviceId, List<Map<String, dynamic>> updatedButtons) {
    final index = _devices.indexWhere((device) => device['id'] == deviceId);
    if (index != -1 && _devices[index]['type'] == 'iron_meter') {
      _devices[index]['buttons'] = updatedButtons;
      notifyListeners();
    }
  }

  void updateSmartBulbBrightness(String deviceId, int brightness) {
    final index = _devices.indexWhere((device) => device['id'] == deviceId && device['type'] == 'smart_bulb');
    if (index != -1) {
      _devices[index]['brightness'] = brightness;
      notifyListeners();
    }
  }

  void updateSmartBulbColor(String deviceId, String color) {
    final index = _devices.indexWhere((device) => device['id'] == deviceId && device['type'] == 'smart_bulb');
    if (index != -1) {
      _devices[index]['color'] = color;
      notifyListeners();
    }
  }

  void sendIRCommand(String deviceId, String buttonName) {
    final deviceIndex = _devices.indexWhere(
      (device) => device['id'] == deviceId && device['type'] == 'iron_meter',
    );

    if (deviceIndex != -1) {
      // TODO: Implement actual IR command sending through platform channel
      // This will be implemented when the hardware integration is ready
    }
  }

  List<Map<String, dynamic>> getDevicesByRoom(String room) {
    if (room == 'All') return List.unmodifiable(_devices);
    return List.unmodifiable(_devices.where((device) => device['room'] == room).toList());
  }
} 
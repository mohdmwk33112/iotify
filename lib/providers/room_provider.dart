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

  List<Map<String, dynamic>> getDevicesByRoom(String room) {
    if (room == 'All') return List.unmodifiable(_devices);
    return List.unmodifiable(_devices.where((device) => device['room'] == room).toList());
  }
} 
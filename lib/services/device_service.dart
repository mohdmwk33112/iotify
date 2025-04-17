import '../models/device.dart';

class DeviceService {
  // In a real app, this would be replaced with actual API calls
  final List<Device> _devices = [];

  Future<List<Device>> getDevices() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_devices);
  }

  Future<void> addDevice(Device device) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _devices.add(device);
  }

  Future<void> updateDevice(Device device) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _devices.indexWhere((d) => d.id == device.id);
    if (index != -1) {
      _devices[index] = device;
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _devices.removeWhere((device) => device.id == deviceId);
  }
} 
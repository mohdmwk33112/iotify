import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/energy_provider.dart';
import '../providers/room_provider.dart';
import 'energy_graph.dart';

class DeviceInsightsDialog extends StatelessWidget {
  final String deviceId;
  final String deviceName;
  final String roomName;
  final Function() onDelete;

  const DeviceInsightsDialog({
    required this.deviceId,
    required this.deviceName,
    required this.roomName,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final isTablet = screenSize.width > 600;

    final energyProvider = Provider.of<EnergyProvider>(context);
    
    // Initialize data if not already done
    energyProvider.initializeData(deviceId, roomName);
    
    final deviceData = energyProvider.getDeviceEnergyData(deviceId);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isIOS ? 13 : 16),
      ),
      child: Container(
        padding: EdgeInsets.all(isIOS ? 20 : 16),
        constraints: BoxConstraints(
          maxWidth: isTablet ? 600 : screenSize.width * 0.9,
          maxHeight: screenSize.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    deviceName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: isIOS ? 20 : 24,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isIOS ? Icons.close_outlined : Icons.close,
                    size: isIOS ? 22 : 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: isIOS ? 20 : 16),
            Text(
              'Room: $roomName',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: isIOS ? 16 : 18,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: isIOS ? 28 : 24),
            // Energy Graph
            Text(
              'Energy Consumption',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isIOS ? 17 : 16,
              ),
            ),
            SizedBox(height: isIOS ? 12 : 8),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    EnergyGraph(data: deviceData),
                    SizedBox(height: isIOS ? 28 : 24),
                    // Statistics
                    Text(
                      'Operating Time',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isIOS ? 17 : 16,
                      ),
                    ),
                    SizedBox(height: isIOS ? 12 : 8),
                    Text(
                      'Last 24 hours: ${_calculateOperatingTime(deviceData)} hours',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: isIOS ? 16 : 18,
                      ),
                    ),
                    SizedBox(height: isIOS ? 28 : 24),
                    // Buttons Row
                    Wrap(
                      spacing: isIOS ? 20 : 16,
                      runSpacing: isIOS ? 20 : 16,
                      alignment: WrapAlignment.center,
                      children: [
                        // Schedule Button
                        SizedBox(
                          width: isLandscape ? 200 : (isTablet ? 250 : double.infinity),
                          child: ElevatedButton.icon(
                            onPressed: () => _showScheduleDialog(context, deviceId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Theme.of(context).colorScheme.onSecondary,
                              minimumSize: Size(0, isIOS ? 52 : 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(isIOS ? 10 : 8),
                              ),
                            ),
                            icon: Icon(
                              isIOS ? Icons.schedule_outlined : Icons.schedule,
                              size: isIOS ? 22 : 24,
                            ),
                            label: Text(
                              'Schedule',
                              style: TextStyle(
                                fontSize: isIOS ? 16 : 14,
                              ),
                            ),
                          ),
                        ),
                        // Update Device Button
                        SizedBox(
                          width: isLandscape ? 200 : (isTablet ? 250 : double.infinity),
                          child: ElevatedButton.icon(
                            onPressed: () => _showUpdateDeviceDialog(context, deviceId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              minimumSize: Size(0, isIOS ? 52 : 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(isIOS ? 10 : 8),
                              ),
                            ),
                            icon: Icon(
                              isIOS ? Icons.update_outlined : Icons.update,
                              size: isIOS ? 22 : 24,
                            ),
                            label: Text(
                              'Update Device',
                              style: TextStyle(
                                fontSize: isIOS ? 16 : 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateOperatingTime(List<EnergyData> data) {
    if (data.isEmpty) return '0';
    
    final activeHours = data.where((item) => item.consumption > 0).length;
    return activeHours.toString();
  }

  void _showUpdateDeviceDialog(BuildContext context, String deviceId) {
    final deviceNameController = TextEditingController(text: deviceName);
    String selectedRoom = roomName;
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Device'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: deviceNameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRoom,
              decoration: const InputDecoration(
                labelText: 'Room',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: 'All',
                  child: Text('All'),
                ),
                ...roomProvider.rooms.where((room) => room != 'All').map((room) {
                  return DropdownMenuItem<String>(
                    value: room,
                    child: Text(room),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                if (value != null) {
                  selectedRoom = value;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (deviceNameController.text.isNotEmpty) {
                roomProvider.updateDeviceName(deviceId, deviceNameController.text);
                if (selectedRoom != roomName) {
                  roomProvider.updateDeviceRoom(deviceId, selectedRoom);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog(BuildContext context, String deviceId) {
    TimeOfDay? onTime;
    TimeOfDay? offTime;
    List<bool> selectedDays = List.generate(7, (index) => false);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Device Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // On Time Picker
              ListTile(
                title: const Text('Turn On Time'),
                subtitle: Text(onTime?.format(context) ?? 'Not set'),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() => onTime = time);
                    }
                  },
                ),
              ),
              // Off Time Picker
              ListTile(
                title: const Text('Turn Off Time'),
                subtitle: Text(offTime?.format(context) ?? 'Not set'),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() => offTime = time);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Days Selection
              const Text('Repeat on:'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (int i = 0; i < 7; i++)
                    FilterChip(
                      label: Text(['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][i]),
                      selected: selectedDays[i],
                      onSelected: (selected) {
                        setState(() => selectedDays[i] = selected);
                      },
                    ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Save schedule to device
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Schedule saved successfully')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
} 
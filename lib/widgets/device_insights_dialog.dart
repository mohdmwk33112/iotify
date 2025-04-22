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
    final energyProvider = Provider.of<EnergyProvider>(context);
    final roomProvider = Provider.of<RoomProvider>(context);
    
    // Initialize data if not already done
    energyProvider.initializeData(deviceId, roomName);
    
    final deviceData = energyProvider.getDeviceEnergyData(deviceId);
    final totalConsumption = energyProvider.getTotalConsumption(deviceId);
    final totalCost = energyProvider.getTotalCost(deviceId);
    final efficiencyScore = energyProvider.getEfficiencyScore(deviceId);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  deviceName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Room: $roomName',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // Energy Graph
            const Text(
              'Energy Consumption',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            EnergyGraph(data: deviceData),
            const SizedBox(height: 24),
            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatCard(
                  title: 'Total Consumption',
                  value: '${totalConsumption.toStringAsFixed(2)}W',
                  icon: Icons.power,
                ),
                _StatCard(
                  title: 'Total Cost',
                  value: '\$${totalCost.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                ),
                _StatCard(
                  title: 'Efficiency',
                  value: '${efficiencyScore.toStringAsFixed(1)}%',
                  icon: Icons.speed,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Operating Time
            const Text(
              'Operating Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last 24 hours: ${_calculateOperatingTime(deviceData)} hours',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // Buttons Row
            Row(
              children: [
                // Schedule Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showScheduleDialog(context, deviceId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSecondary,
                      minimumSize: const Size(0, 48),
                    ),
                    icon: const Icon(Icons.schedule),
                    label: const Text('Schedule'),
                  ),
                ),
                const SizedBox(width: 16),
                // Update Device Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showUpdateDeviceDialog(context, deviceId, deviceName, roomName, roomProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      minimumSize: const Size(0, 48),
                    ),
                    child: Text(
                      'Update Device',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Delete Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Device'),
                    content: Text('Are you sure you want to delete $deviceName?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onDelete();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Delete Device'),
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

  void _showUpdateDeviceDialog(
    BuildContext context,
    String deviceId,
    String deviceName,
    String roomName,
    RoomProvider roomProvider,
  ) {
    final deviceNameController = TextEditingController(text: deviceName);
    String selectedRoom = roomName;

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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 
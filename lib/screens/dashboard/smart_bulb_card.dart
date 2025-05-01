import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../providers/room_provider.dart';
import '../../providers/energy_provider.dart';
import 'package:provider/provider.dart';

class SmartBulbCard extends StatelessWidget {
  final String deviceId;
  final String deviceName;
  final String roomName;
  final bool isOn;
  final int brightness;
  final String color;
  final Function(bool) onToggle;
  final Function(String) onRoomChange;
  final Function() onDelete;
  final Function(int) onBrightnessChange;
  final Function(String) onColorChange;

  const SmartBulbCard({
    required this.deviceId,
    required this.deviceName,
    required this.roomName,
    required this.isOn,
    required this.brightness,
    required this.color,
    required this.onToggle,
    required this.onRoomChange,
    required this.onDelete,
    required this.onBrightnessChange,
    required this.onColorChange,
    super.key,
  });

  void _showDeviceSettings(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    final energyProvider = Provider.of<EnergyProvider>(context, listen: false);
    
    // Initialize data if not already done
    energyProvider.initializeData(deviceId, roomName);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                        fontSize: 24,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Buttons Row
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        // Schedule Button
                        SizedBox(
                          width: isTablet ? 250 : double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showScheduleDialog(context, deviceId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Theme.of(context).colorScheme.onSecondary,
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.schedule),
                            label: const Text(
                              'Schedule',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        // Update Device Button
                        SizedBox(
                          width: isTablet ? 250 : double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showUpdateDeviceDialog(context, deviceId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.update),
                            label: const Text(
                              'Update Device',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        // Delete Device Button
                        SizedBox(
                          width: isTablet ? 250 : double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showDeleteConfirmationDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.delete),
                            label: const Text(
                              'Delete Device',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUpdateDeviceDialog(
    BuildContext context,
    String deviceId,
  ) {
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
                  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
                ].asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  return FilterChip(
                    label: Text(day),
                    selected: selectedDays[index],
                    onSelected: (selected) {
                      setState(() {
                        selectedDays[index] = selected;
                      });
                    },
                  );
                }).toList(),
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
                // TODO: Implement schedule saving
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
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
              Navigator.pop(context); // Close confirmation dialog
              Navigator.pop(context); // Close device dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDeviceSettings(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
            border: Border.all(
              color: isOn 
                  ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
                  : (isDark ? AppColors.darkDeviceOffBackground : AppColors.lightSwitchOffBackground),
              width: isOn ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.black.withValues(alpha: 102)
                    : Colors.black.withValues(alpha: 20),
                blurRadius: isDark ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device icon
              Icon(
                Icons.lightbulb_outline,
                size: 32,
                color: isOn 
                    ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
                    : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 12),
              // Device name and room
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deviceName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground).withValues(alpha: 128),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      roomName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Toggle switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isOn ? 'On' : 'Off',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isOn 
                          ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
                          : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
                    ),
                  ),
                  Switch(
                    value: isOn,
                    onChanged: onToggle,
                    activeColor: isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple,
                    inactiveTrackColor: isDark ? AppColors.darkDeviceOffBackground : AppColors.lightSwitchOffBackground,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
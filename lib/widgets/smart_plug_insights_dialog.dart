import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/energy_provider.dart';
import '../providers/room_provider.dart';
import '../theme/app_colors.dart';
import 'energy_graph.dart';

class SmartPlugInsightsDialog extends StatelessWidget {
  final String deviceId;
  final String deviceName;
  final String roomName;
  final Function() onDelete;

  const SmartPlugInsightsDialog({
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final energyProvider = Provider.of<EnergyProvider>(context, listen: false);
    
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EnergyGraph(data: deviceData),
                    SizedBox(height: isIOS ? 28 : 24),
                    // Energy Insights
                    Text(
                      'Energy Insights',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isIOS ? 17 : 16,
                      ),
                    ),
                    SizedBox(height: isIOS ? 12 : 8),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildInsightTile(
                          context,
                          Icons.bolt,
                          'Current Power',
                          '${_calculateCurrentConsumption(deviceData).toStringAsFixed(1)} W',
                          isDark,
                          isIOS,
                        ),
                        _buildInsightTile(
                          context,
                          Icons.power,
                          'Total Energy',
                          '${_calculateTotalConsumption(deviceData).toStringAsFixed(1)} Wh',
                          isDark,
                          isIOS,
                        ),
                        _buildInsightTile(
                          context,
                          Icons.attach_money,
                          'Total Cost',
                          '\$${_calculateTotalCost(deviceData).toStringAsFixed(2)}',
                          isDark,
                          isIOS,
                        ),
                        _buildInsightTile(
                          context,
                          Icons.timer,
                          'Uptime',
                          '${_calculateTotalUptime(deviceData).toStringAsFixed(1)}h',
                          isDark,
                          isIOS,
                        ),
                        _buildInsightTile(
                          context,
                          Icons.timer_off,
                          'Downtime',
                          '${_calculateTotalDowntime(deviceData).toStringAsFixed(1)}h',
                          isDark,
                          isIOS,
                        ),
                        _buildInsightTile(
                          context,
                          Icons.savings,
                          'Cost Saved',
                          '\$${_calculateTotalSavedCost(deviceData).toStringAsFixed(2)}',
                          isDark,
                          isIOS,
                        ),
                      ],
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
                        // Delete Device Button
                        SizedBox(
                          width: isLandscape ? 200 : (isTablet ? 250 : double.infinity),
                          child: ElevatedButton.icon(
                            onPressed: () => _showDeleteConfirmationDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              minimumSize: Size(0, isIOS ? 52 : 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(isIOS ? 10 : 8),
                              ),
                            ),
                            icon: Icon(
                              isIOS ? Icons.delete_outline : Icons.delete,
                              size: isIOS ? 22 : 24,
                            ),
                            label: Text(
                              'Delete Device',
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

  Widget _buildInsightTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDark,
    bool isIOS,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
            fontSize: isIOS ? 13 : 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: isIOS ? 15 : 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  double _calculateCurrentConsumption(List<EnergyData> data) {
    if (data.isEmpty) return 0;
    return data.last.consumption;
  }

  double _calculateTotalConsumption(List<EnergyData> data) {
    if (data.isEmpty) return 0;
    return data.fold(0, (sum, point) => sum + point.consumption);
  }

  double _calculateTotalCost(List<EnergyData> data) {
    const double costPerKWh = 0.12; // Example rate, adjust as needed
    return (_calculateTotalConsumption(data) / 1000) * costPerKWh;
  }

  double _calculateTotalUptime(List<EnergyData> data) {
    if (data.isEmpty) return 0;
    return data.where((point) => point.consumption > 0).length.toDouble();
  }

  double _calculateTotalDowntime(List<EnergyData> data) {
    if (data.isEmpty) return 0;
    return data.where((point) => point.consumption == 0).length.toDouble();
  }

  double _calculateTotalSavedCost(List<EnergyData> data) {
    const double costPerKWh = 0.12; // Example rate, adjust as needed
    return (_calculatePowerSaved(data) / 1000) * costPerKWh;
  }

  double _calculatePowerSaved(List<EnergyData> data) {
    if (data.isEmpty) return 0;
    // Calculate potential consumption if device was always on
    double potentialConsumption = data.length * 60; // Assuming 60W when on
    return potentialConsumption - _calculateTotalConsumption(data);
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
} 
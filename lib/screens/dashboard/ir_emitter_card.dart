import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../providers/room_provider.dart';
import 'package:provider/provider.dart';

class IrEmitterCard extends StatelessWidget {
  final String deviceId;
  final String deviceName;
  final String roomName;
  final String remoteType;
  final List<Map<String, dynamic>> buttons;
  final bool isConnected;
  final Function(String) onRoomChange;
  final Function() onDelete;
  final Function(String, String) onButtonPress;
  final Function(String, List<Map<String, dynamic>>) onButtonsUpdate;

  const IrEmitterCard({
    required this.deviceId,
    required this.deviceName,
    required this.roomName,
    required this.remoteType,
    required this.buttons,
    required this.isConnected,
    required this.onRoomChange,
    required this.onDelete,
    required this.onButtonPress,
    required this.onButtonsUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showRemotePopup(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
            border: Border.all(
              color: isConnected 
                  ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
                  : (isDark ? AppColors.darkDeviceOffBackground : AppColors.lightSwitchOffBackground),
              width: isConnected ? 2 : 1,
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
                Icons.settings_remote,
                size: 32,
                color: isConnected 
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
              // Connection status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isConnected ? 'Connected' : 'Disconnected',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isConnected 
                          ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
                          : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
                    ),
                  ),
                  Icon(
                    isConnected ? Icons.wifi : Icons.wifi_off,
                    color: isConnected 
                        ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
                        : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemotePopup(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

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
            children: [
              // Header with device info and settings button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deviceName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 24,
                          ),
                          overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Room: $roomName',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => _showConfigurationMenu(context, true),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Remote Type Selection
              Text(
                'Select Remote Type',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isTablet ? 4 : 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.5,
                children: ['TV', 'AC', 'Fan', 'Speaker'].map((type) {
                  final isSelected = type == remoteType;
                  return Card(
                    elevation: isSelected ? 4 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Update the remote type and buttons
                        final defaultButtons = _getDefaultButtons(type);
                        onButtonsUpdate(deviceId, defaultButtons);
                        Navigator.pop(context);
                        _showRemoteButtons(context, type, defaultButtons);
                      },
                      child: Center(
                        child: Text(
                          type,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoteButtons(BuildContext context, String type, List<Map<String, dynamic>> buttons) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    // Group buttons by type for better organization
    final powerButtons = buttons.where((b) => b['name'].toString().toLowerCase().contains('power')).toList();
    final volumeButtons = buttons.where((b) => b['name'].toString().toLowerCase().contains('volume')).toList();
    final channelButtons = buttons.where((b) => b['name'].toString().toLowerCase().contains('channel')).toList();
    final numberButtons = buttons.where((b) => RegExp(r'^[0-9]$').hasMatch(b['name'].toString())).toList();
    final colorButtons = buttons.where((b) => ['Red', 'Green', 'Yellow', 'Blue'].contains(b['name'])).toList();
    final otherButtons = buttons.where((b) => 
      !powerButtons.contains(b) && 
      !volumeButtons.contains(b) && 
      !channelButtons.contains(b) && 
      !numberButtons.contains(b) && 
      !colorButtons.contains(b)
    ).toList();

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
            children: [
              // Header with device info and settings button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deviceName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        type,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings_remote),
                        onPressed: () {
                          Navigator.pop(context);
                          _showRemotePopup(context);
                        },
                        tooltip: 'Change Remote Type',
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => _showConfigurationMenu(context, true),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Main content
              Flexible(
                child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Power button at the top
                    if (powerButtons.isNotEmpty)
                      SizedBox(
                        width: 100,
                        height: 45,
                          child: ElevatedButton.icon(
                            onPressed: () => onButtonPress(deviceId, powerButtons[0]['name']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.error,
                              foregroundColor: Theme.of(context).colorScheme.onError,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(
                              Icons.power_settings_new,
                              size: 20,
                            ),
                            label: Text(
                              powerButtons[0]['name'],
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                    // Volume and Channel controls
                      if (volumeButtons.isNotEmpty || channelButtons.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (volumeButtons.isNotEmpty)
                          Column(
                            children: [
                                  IconButton(
                                    onPressed: () => onButtonPress(deviceId, volumeButtons[0]['name']),
                                    icon: const Icon(
                                      Icons.volume_up,
                                      size: 24,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => onButtonPress(deviceId, volumeButtons[1]['name']),
                                    icon: const Icon(
                                      Icons.volume_down,
                                      size: 24,
                                    ),
                              ),
                            ],
                          ),
                            if (volumeButtons.isNotEmpty && channelButtons.isNotEmpty)
                              const SizedBox(width: 32),
                        if (channelButtons.isNotEmpty)
                          Column(
                            children: [
                                  IconButton(
                                    onPressed: () => onButtonPress(deviceId, channelButtons[0]['name']),
                                    icon: const Icon(
                                      Icons.arrow_upward,
                                      size: 24,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => onButtonPress(deviceId, channelButtons[1]['name']),
                                    icon: const Icon(
                                      Icons.arrow_downward,
                                      size: 24,
                                    ),
                              ),
                            ],
                          ),
                      ],
                    ),
                      const SizedBox(height: 16),
                    // Number pad
                    if (numberButtons.isNotEmpty)
                        GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.5,
                          children: numberButtons.map((button) {
    return ElevatedButton(
                              onPressed: () => onButtonPress(deviceId, button['name']),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
              button['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                      // Color buttons
                      if (colorButtons.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: colorButtons.map((button) {
                            return ElevatedButton(
                              onPressed: () => onButtonPress(deviceId, button['name']),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: button['color'] ?? Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                button['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                      // Other buttons
                      if (otherButtons.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: otherButtons.map((button) {
                            return ElevatedButton.icon(
                              onPressed: () => onButtonPress(deviceId, button['name']),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(
                                button['icon'] ?? Icons.circle_outlined,
                                size: 18,
                              ),
                              label: Text(
                                button['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfigurationMenu(BuildContext context, bool isFromPopup) {
    final deviceNameController = TextEditingController(text: deviceName);
    String selectedRoom = roomName;
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Device Settings'),
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
              items: roomProvider.rooms.map((room) {
                  return DropdownMenuItem<String>(
                    value: room,
                    child: Text(room),
                  );
                }).toList(),
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
                // Update device name
                roomProvider.updateDeviceName(deviceId, deviceNameController.text);
                // Update room
                onRoomChange(selectedRoom);
                Navigator.pop(context);
                if (isFromPopup) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDefaultButtons(String type) {
    switch (type) {
      case 'TV':
        return [
          {'name': 'Power', 'icon': Icons.power_settings_new},
          {'name': 'Volume Up', 'icon': Icons.volume_up},
          {'name': 'Volume Down', 'icon': Icons.volume_down},
          {'name': 'Channel Up', 'icon': Icons.arrow_upward},
          {'name': 'Channel Down', 'icon': Icons.arrow_downward},
          {'name': '1', 'icon': Icons.filter_1},
          {'name': '2', 'icon': Icons.filter_2},
          {'name': '3', 'icon': Icons.filter_3},
          {'name': '4', 'icon': Icons.filter_4},
          {'name': '5', 'icon': Icons.filter_5},
          {'name': '6', 'icon': Icons.filter_6},
          {'name': '7', 'icon': Icons.filter_7},
          {'name': '8', 'icon': Icons.filter_8},
          {'name': '9', 'icon': Icons.filter_9},
          {'name': '0', 'icon': Icons.filter_none},
          {'name': 'Menu', 'icon': Icons.menu},
          {'name': 'Source', 'icon': Icons.input},
          {'name': 'Info', 'icon': Icons.info_outline},
          {'name': 'Exit', 'icon': Icons.close},
        ];
      case 'AC':
        return [
          {'name': 'Power', 'icon': Icons.power_settings_new},
          {'name': 'Temperature Up', 'icon': Icons.arrow_upward},
          {'name': 'Temperature Down', 'icon': Icons.arrow_downward},
          {'name': 'Mode', 'icon': Icons.sync},
          {'name': 'Fan Speed', 'icon': Icons.air},
          {'name': 'Swing', 'icon': Icons.swap_vert},
          {'name': 'Timer', 'icon': Icons.timer},
          {'name': 'Sleep', 'icon': Icons.bedtime},
          {'name': 'Eco', 'icon': Icons.eco},
        ];
      case 'Fan':
        return [
          {'name': 'Power', 'icon': Icons.power_settings_new},
          {'name': 'Speed', 'icon': Icons.speed},
          {'name': 'Timer', 'icon': Icons.timer},
          {'name': 'Swing', 'icon': Icons.swap_vert},
          {'name': 'Mode', 'icon': Icons.sync},
        ];
      case 'Speaker':
        return [
          {'name': 'Power', 'icon': Icons.power_settings_new},
          {'name': 'Volume Up', 'icon': Icons.volume_up},
          {'name': 'Volume Down', 'icon': Icons.volume_down},
          {'name': 'Play/Pause', 'icon': Icons.play_arrow},
          {'name': 'Next', 'icon': Icons.skip_next},
          {'name': 'Previous', 'icon': Icons.skip_previous},
          {'name': 'Bass', 'icon': Icons.graphic_eq},
          {'name': 'Treble', 'icon': Icons.equalizer},
        ];
      default:
        return [];
    }
  }
} 
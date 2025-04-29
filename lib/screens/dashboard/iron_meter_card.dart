import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../providers/room_provider.dart';
import 'package:provider/provider.dart';

class IronMeterCard extends StatelessWidget {
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

  const IronMeterCard({
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

  void _showRemotePopup(BuildContext context) {
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
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with device info and settings button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deviceName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        remoteType,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => _showConfigurationMenu(context, true),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Main content
              Expanded(
                child: Column(
                  children: [
                    // Top row: Power and Volume/Channel controls
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Power button
                        if (powerButtons.isNotEmpty)
                          SizedBox(
                            width: 100,
                            child: _buildRemoteButton(context, powerButtons.first),
                          ),
                        const SizedBox(width: 16),
                        // Volume and Channel controls
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Volume controls
                              Column(
                                children: volumeButtons.map((button) => 
                                  SizedBox(
                                    width: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: _buildRemoteButton(context, button),
                                    ),
                                  ),
                                ).toList(),
                              ),
                              // Channel controls
                              Column(
                                children: channelButtons.map((button) => 
                                  SizedBox(
                                    width: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: _buildRemoteButton(context, button),
                                    ),
                                  ),
                                ).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Middle section: Number pad and other buttons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Number pad
                        if (numberButtons.isNotEmpty)
                          Expanded(
                            flex: 2,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                              itemCount: numberButtons.length,
                              itemBuilder: (context, index) => _buildRemoteButton(context, numberButtons[index]),
                            ),
                          ),
                        const SizedBox(width: 16),
                        // Other buttons
                        if (otherButtons.isNotEmpty)
                          Expanded(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: otherButtons.length,
                              itemBuilder: (context, index) => _buildRemoteButton(context, otherButtons[index]),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Bottom section: Color buttons
                    if (colorButtons.isNotEmpty)
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.2,
                        children: colorButtons.map((button) => 
                          _buildRemoteButton(context, button),
                        ).toList(),
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

  Widget _buildRemoteButton(BuildContext context, Map<String, dynamic> button) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = button['color'] as Color?;
    final isPowerButton = button['name'].toString().toLowerCase().contains('power');

    return SizedBox(
      height: isPowerButton ? 70 : 35,
      child: ElevatedButton(
        onPressed: () {
          onButtonPress(deviceId, button['name']);
          HapticFeedback.lightImpact();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isPowerButton 
              ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
              : (isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground),
          foregroundColor: buttonColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: buttonColor ?? (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
              width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              button['icon'] as IconData,
              size: isPowerButton ? 24 : 16,
            ),
            const SizedBox(height: 2),
            Text(
              button['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isPowerButton ? 10 : 8,
                fontWeight: isPowerButton ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showConfigurationMenu(BuildContext context, [bool keepPopupOpen = false]) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Modify Buttons'),
            onTap: () {
              Navigator.pop(context);
              _showButtonModificationDialog(context);
              if (!keepPopupOpen) {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Modify Device'),
            onTap: () {
              Navigator.pop(context);
              _showDeviceModificationDialog(context);
              if (!keepPopupOpen) {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Device', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context);
              if (!keepPopupOpen) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showButtonModificationDialog(BuildContext context) {
    final List<Map<String, dynamic>> tempButtons = List.from(buttons);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modify Buttons'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add Button button
              ElevatedButton.icon(
                onPressed: () => _showAddButtonDialog(context, tempButtons),
                icon: const Icon(Icons.add),
                label: const Text('Add Button'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 16),
              // Button list
              Flexible(
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  itemCount: tempButtons.length,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = tempButtons.removeAt(oldIndex);
                    tempButtons.insert(newIndex, item);
                  },
                  itemBuilder: (context, index) {
                    final button = tempButtons[index];
                    return ListTile(
                      key: ValueKey(button),
                      leading: Icon(button['icon'] as IconData),
                      title: Text(button['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditButtonDialog(context, tempButtons, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              tempButtons.removeAt(index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onButtonsUpdate(deviceId, tempButtons);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddButtonDialog(BuildContext context, List<Map<String, dynamic>> tempButtons) {
    final nameController = TextEditingController();
    IconData selectedIcon = Icons.circle_outlined;
    Color? selectedColor;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Button'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Button Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Icons.power,
                    Icons.volume_up,
                    Icons.volume_down,
                    Icons.arrow_upward,
                    Icons.arrow_downward,
                    Icons.menu,
                    Icons.input,
                    Icons.circle_outlined,
                    Icons.live_tv,
                    Icons.info_outline,
                    Icons.close,
                    Icons.circle,
                    Icons.sync,
                    Icons.air,
                    Icons.swap_vert,
                    Icons.timer,
                    Icons.bedtime,
                    Icons.eco,
                    Icons.speed,
                    Icons.play_arrow,
                    Icons.skip_next,
                    Icons.skip_previous,
                    Icons.graphic_eq,
                    Icons.equalizer,
                  ].map((icon) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedIcon == icon
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          color: selectedIcon == icon
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Colors.red,
                    Colors.green,
                    Colors.yellow,
                    Colors.blue,
                    Colors.purple,
                    Colors.orange,
                  ].map((color) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  tempButtons.add({
                    'name': nameController.text,
                    'icon': selectedIcon,
                    if (selectedColor != null) 'color': selectedColor,
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditButtonDialog(BuildContext context, List<Map<String, dynamic>> tempButtons, int index) {
    final button = tempButtons[index];
    final nameController = TextEditingController(text: button['name']);
    IconData selectedIcon = button['icon'] as IconData;
    Color? selectedColor = button['color'] as Color?;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Button'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Button Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Icons.power,
                    Icons.volume_up,
                    Icons.volume_down,
                    Icons.arrow_upward,
                    Icons.arrow_downward,
                    Icons.menu,
                    Icons.input,
                    Icons.circle_outlined,
                    Icons.live_tv,
                    Icons.info_outline,
                    Icons.close,
                    Icons.circle,
                    Icons.sync,
                    Icons.air,
                    Icons.swap_vert,
                    Icons.timer,
                    Icons.bedtime,
                    Icons.eco,
                    Icons.speed,
                    Icons.play_arrow,
                    Icons.skip_next,
                    Icons.skip_previous,
                    Icons.graphic_eq,
                    Icons.equalizer,
                  ].map((icon) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedIcon == icon
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          color: selectedIcon == icon
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Colors.red,
                    Colors.green,
                    Colors.yellow,
                    Colors.blue,
                    Colors.purple,
                    Colors.orange,
                  ].map((color) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  tempButtons[index] = {
                    'name': nameController.text,
                    'icon': selectedIcon,
                    if (selectedColor != null) 'color': selectedColor,
                  };
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeviceModificationDialog(BuildContext context) {
    final nameController = TextEditingController(text: deviceName);
    String selectedRoom = roomName;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modify Device'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
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
                ...Provider.of<RoomProvider>(context).rooms
                    .where((room) => room != 'All')
                    .map((room) {
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
              if (nameController.text.isNotEmpty) {
                onRoomChange(selectedRoom);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Device'),
        content: const Text('Are you sure you want to delete this device?'),
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
  }

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
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device icon and menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.tv,
                    size: 32,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showConfigurationMenu(context),
                    color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Device info
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
                  Text(
                    remoteType,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    );
  }
} 
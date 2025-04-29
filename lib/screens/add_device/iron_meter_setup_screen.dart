import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../providers/room_provider.dart';
import 'package:provider/provider.dart';
import '../dashboard/dashboard_screen.dart';

class IronMeterSetupScreen extends StatefulWidget {
  const IronMeterSetupScreen({super.key});

  @override
  State<IronMeterSetupScreen> createState() => _IronMeterSetupScreenState();
}

class _IronMeterSetupScreenState extends State<IronMeterSetupScreen> {
  String _selectedRoom = '';
  String _selectedRemoteType = '';
  final _deviceNameController = TextEditingController();
  final List<Map<String, dynamic>> _buttons = [];

  final Map<String, List<Map<String, dynamic>>> _defaultButtons = {
    'TV': [
      {'name': 'Power', 'icon': Icons.power},
      {'name': 'Volume Up', 'icon': Icons.volume_up},
      {'name': 'Volume Down', 'icon': Icons.volume_down},
      {'name': 'Channel Up', 'icon': Icons.arrow_upward},
      {'name': 'Channel Down', 'icon': Icons.arrow_downward},
      {'name': 'Mute', 'icon': Icons.volume_off},
      {'name': 'Menu', 'icon': Icons.menu},
      {'name': 'Source', 'icon': Icons.input},
      {'name': '0', 'icon': Icons.circle_outlined},
      {'name': '1', 'icon': Icons.circle_outlined},
      {'name': '2', 'icon': Icons.circle_outlined},
      {'name': '3', 'icon': Icons.circle_outlined},
      {'name': '4', 'icon': Icons.circle_outlined},
      {'name': '5', 'icon': Icons.circle_outlined},
      {'name': '6', 'icon': Icons.circle_outlined},
      {'name': '7', 'icon': Icons.circle_outlined},
      {'name': '8', 'icon': Icons.circle_outlined},
      {'name': '9', 'icon': Icons.circle_outlined},
      {'name': 'Guide', 'icon': Icons.live_tv},
      {'name': 'Info', 'icon': Icons.info_outline},
      {'name': 'Exit', 'icon': Icons.close},
      {'name': 'Red', 'icon': Icons.circle, 'color': Colors.red},
      {'name': 'Green', 'icon': Icons.circle, 'color': Colors.green},
      {'name': 'Yellow', 'icon': Icons.circle, 'color': Colors.yellow},
      {'name': 'Blue', 'icon': Icons.circle, 'color': Colors.blue},
    ],
    'AC': [
      {'name': 'Power', 'icon': Icons.power},
      {'name': 'Temperature Up', 'icon': Icons.arrow_upward},
      {'name': 'Temperature Down', 'icon': Icons.arrow_downward},
      {'name': 'Mode', 'icon': Icons.sync},
      {'name': 'Fan Speed', 'icon': Icons.air},
      {'name': 'Swing', 'icon': Icons.swap_vert},
      {'name': 'Timer', 'icon': Icons.timer},
      {'name': 'Sleep', 'icon': Icons.bedtime},
      {'name': 'Eco', 'icon': Icons.eco},
      {'name': 'Turbo', 'icon': Icons.speed},
    ],
    'Fan': [
      {'name': 'Power', 'icon': Icons.power},
      {'name': 'Speed', 'icon': Icons.speed},
      {'name': 'Mode', 'icon': Icons.sync},
      {'name': 'Timer', 'icon': Icons.timer},
      {'name': 'Swing', 'icon': Icons.swap_vert},
      {'name': 'Sleep', 'icon': Icons.bedtime},
      {'name': 'Natural', 'icon': Icons.eco},
      {'name': 'Turbo', 'icon': Icons.speed},
    ],
    'Speaker': [
      {'name': 'Power', 'icon': Icons.power},
      {'name': 'Volume Up', 'icon': Icons.volume_up},
      {'name': 'Volume Down', 'icon': Icons.volume_down},
      {'name': 'Play/Pause', 'icon': Icons.play_arrow},
      {'name': 'Next', 'icon': Icons.skip_next},
      {'name': 'Previous', 'icon': Icons.skip_previous},
      {'name': 'Mode', 'icon': Icons.sync},
      {'name': 'Mute', 'icon': Icons.volume_off},
      {'name': 'Bass Up', 'icon': Icons.graphic_eq},
      {'name': 'Bass Down', 'icon': Icons.graphic_eq},
      {'name': 'Treble Up', 'icon': Icons.graphic_eq},
      {'name': 'Treble Down', 'icon': Icons.graphic_eq},
      {'name': 'EQ', 'icon': Icons.equalizer},
    ],
  };

  @override
  void initState() {
    super.initState();
    _deviceNameController.text = 'Remote Control';
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  void _showAddButtonDialog(BuildContext context) {
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
                  this.setState(() {
                    _buttons.add({
                      'name': nameController.text,
                      'icon': selectedIcon,
                      if (selectedColor != null) 'color': selectedColor,
                    });
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

  void _showButtonEditDialog(BuildContext context, int index) {
    final button = _buttons[index];
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
              onPressed: () {
                this.setState(() {
                  _buttons.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  this.setState(() {
                    _buttons[index] = {
                      'name': nameController.text,
                      'icon': selectedIcon,
                      if (selectedColor != null) 'color': selectedColor,
                    };
                  });
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Remote Control'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Room Selection
            Text(
              'Select Room',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: roomProvider.rooms.where((room) => room != 'All').map((room) {
                final isSelected = room == _selectedRoom;
                return FilterChip(
                  label: Text(room),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedRoom = room;
                    });
                  },
                  backgroundColor: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
                  selectedColor: isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Remote Type Selection
            Text(
              'Select Remote Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.5,
              children: _defaultButtons.keys.map((type) {
                final isSelected = type == _selectedRemoteType;
                return Card(
                  color: isSelected
                      ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
                      : (isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRemoteType = type;
                        _buttons.clear();
                        _buttons.addAll(_defaultButtons[type]!);
                      });
                    },
                    child: Center(
                      child: Text(
                        type,
                        style: TextStyle(
                          color: isSelected
                              ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                              : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Device Name
            TextField(
              controller: _deviceNameController,
              decoration: InputDecoration(
                labelText: 'Device Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Button Preview
            if (_selectedRemoteType.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Button Layout',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddButtonDialog(context),
                    tooltip: 'Add Button',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _buttons.length,
                itemBuilder: (context, index) {
                  final button = _buttons[index];
                  return Card(
                    color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
                    child: InkWell(
                      onTap: () => _showButtonEditDialog(context, index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            button['icon'] as IconData,
                            color: button['color'] as Color? ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            button['name'] as String,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _selectedRoom.isNotEmpty && _selectedRemoteType.isNotEmpty
                  ? () => _saveDevice(context)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple,
                foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Device',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveDevice(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    
    final newDevice = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _deviceNameController.text,
      'room': _selectedRoom,
      'type': 'iron_meter',
      'remoteType': _selectedRemoteType,
      'buttons': _buttons,
      'isOn': false,
    };
    
    roomProvider.addDevice(newDevice);
    
    // Navigate back to dashboard and switch to the specific room
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (_selectedRoom != 'All') {
      final dashboardState = context.findAncestorStateOfType<DashboardScreenState>();
      if (dashboardState != null) {
        dashboardState.switchToRoom(_selectedRoom);
      }
    }
  }
} 
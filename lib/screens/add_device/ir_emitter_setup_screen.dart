import 'package:flutter/material.dart';
import '../../providers/room_provider.dart';
import 'package:provider/provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../../theme/app_colors.dart';

class IrEmitterSetupScreen extends StatefulWidget {
  const IrEmitterSetupScreen({super.key});

  @override
  State<IrEmitterSetupScreen> createState() => _IrEmitterSetupScreenState();
}

class _IrEmitterSetupScreenState extends State<IrEmitterSetupScreen> {
  String _selectedRoom = 'All';
  final _deviceNameController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final roomProvider = Provider.of<RoomProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add IR Emitter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device Name
            TextField(
              controller: _deviceNameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
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
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedRoom == 'All',
                  onSelected: (selected) {
                    setState(() {
                      _selectedRoom = 'All';
                    });
                  },
                  backgroundColor: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
                  selectedColor: isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple,
                ),
                ...roomProvider.rooms.where((room) => room != 'All').map((room) {
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
              ],
            ),
            const SizedBox(height: 32),
            // Save Button
            ElevatedButton(
              onPressed: () {
                if (_deviceNameController.text.isNotEmpty) {
                  // Create and add the IR emitter device
                  final device = {
                    'id': 'ir_${DateTime.now().millisecondsSinceEpoch}',
                    'name': _deviceNameController.text,
                    'type': 'ir_emitter',
                    'room': _selectedRoom,
                    'isConnected': true,
                    'isOn': false,
                    'remoteType': 'TV',
                    'buttons': [
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
                    ],
                  };
                  
                  roomProvider.addDevice(device);
                  
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const DashboardScreen()),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Save Device'),
            ),
          ],
        ),
      ),
    );
  }
} 
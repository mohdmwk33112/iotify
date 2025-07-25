import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/room_provider.dart';
import '../../theme/app_colors.dart';
import '../dashboard/dashboard_screen.dart';

class AddDeviceScreen extends StatefulWidget {
  final String deviceType;
  
  const AddDeviceScreen({
    required this.deviceType,
    super.key,
  });

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _deviceNameController = TextEditingController();
  String _selectedRoom = 'All';

  @override
  void initState() {
    super.initState();
    _deviceNameController.text = widget.deviceType == 'smart_plug' ? 'Smart Plug' : 'Smart Bulb';
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  void _connectDevice() {
    if (_deviceNameController.text.isNotEmpty) {
      final roomProvider = Provider.of<RoomProvider>(context, listen: false);
      
      // Create new device
      final newDevice = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _deviceNameController.text,
        'room': _selectedRoom,
        'type': widget.deviceType,
        'isOn': false,
      };
      
      // Add device to provider
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.deviceType == 'smart_plug' ? 'Smart Plug' : 'Smart Bulb'}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            // Connect button
            ElevatedButton(
              onPressed: _connectDevice,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple,
                foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Connect Device',
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
} 
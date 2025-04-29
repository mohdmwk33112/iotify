import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../providers/room_provider.dart';
import 'package:provider/provider.dart';
import '../dashboard/dashboard_screen.dart';

class SmartBulbSetupScreen extends StatefulWidget {
  const SmartBulbSetupScreen({super.key});

  @override
  State<SmartBulbSetupScreen> createState() => _SmartBulbSetupScreenState();
}

class _SmartBulbSetupScreenState extends State<SmartBulbSetupScreen> {
  final _deviceNameController = TextEditingController();
  String _selectedRoom = '';

  @override
  void initState() {
    super.initState();
    _deviceNameController.text = 'Smart Bulb';
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    super.dispose();
  }

  void _connectDevice() {
    if (_deviceNameController.text.isNotEmpty && _selectedRoom.isNotEmpty) {
      final roomProvider = Provider.of<RoomProvider>(context, listen: false);
      
      // Create new device
      final newDevice = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _deviceNameController.text,
        'room': _selectedRoom,
        'type': 'smart_bulb',
        'isOn': false,
        'brightness': 100,
        'color': '#FFFFFF',
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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Smart Bulb'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Device illustration
            Container(
              height: isSmallScreen ? 200 : 300,
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                size: 100,
                color: isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple,
              ),
            ),
            // Device name input
            TextField(
              controller: _deviceNameController,
              decoration: InputDecoration(
                labelText: 'Device Name',
                hintText: 'Enter device name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(
                  Icons.lightbulb_outline,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                labelStyle: TextStyle(
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Room selection
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
            const SizedBox(height: 32),
            // Connect button
            ElevatedButton(
              onPressed: _selectedRoom.isNotEmpty ? _connectDevice : null,
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
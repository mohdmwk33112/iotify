import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/navigation_service.dart';
import '../../providers/room_provider.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _deviceNameController = TextEditingController();
  String _selectedRoom = 'All';

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
        'isOn': false,
      };
      
      // Add device to provider
      roomProvider.addDevice(newDevice);
      
      // Navigate back
      NavigationService.goBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
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
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.power,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
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
                  Icons.devices,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Room selection
            Text(
              'Select Room',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
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
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 128),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
                  ),
                  showCheckmark: false,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            // Connect button
            ElevatedButton(
              onPressed: _connectDevice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
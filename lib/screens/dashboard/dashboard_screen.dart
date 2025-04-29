import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/room_provider.dart';
import '../../providers/energy_provider.dart';
import '../../services/navigation_service.dart';
import '../../widgets/room_insights.dart';
import '../../widgets/add_room_dialog.dart';
import '../../widgets/energy_graph.dart';
import 'device_card.dart';
import 'iron_meter_card.dart';
import 'smart_bulb_card.dart';
import '../add_device/device_type_selection_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  void _initializeTabController() {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    _tabController = TabController(
      length: roomProvider.rooms.length + 1,
      vsync: this,
      initialIndex: _selectedTabIndex.clamp(0, roomProvider.rooms.length),
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final roomProvider = Provider.of<RoomProvider>(context);
    if (_tabController.length != roomProvider.rooms.length + 1) {
      final oldIndex = _tabController.index;
      _tabController.dispose();
      _initializeTabController();
      if (oldIndex < roomProvider.rooms.length + 1) {
        _tabController.animateTo(oldIndex);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddRoomDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddRoomDialog(),
    ).then((_) {
      if (mounted) {
        setState(() {
          _tabController.dispose();
          _initializeTabController();
        });
      }
    });
  }

  void _navigateToAddDevice() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeviceTypeSelectionScreen()),
    );
  }

  void _showRoomOptions(String roomName) {
    if (roomName == 'All') return;

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete Room', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteRoomConfirmation(roomName);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteRoomConfirmation(String roomName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Room'),
        content: Text('Are you sure you want to delete $roomName? All devices will be moved to "All".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<RoomProvider>(context, listen: false).deleteRoom(roomName);
              Navigator.pop(context);
              if (mounted) {
                setState(() {
                  _tabController.dispose();
                  _initializeTabController();
                });
              }
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

  void switchToRoom(String roomName) {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final roomIndex = roomProvider.rooms.indexOf(roomName);
    if (roomIndex != -1) {
      _tabController.animateTo(roomIndex + 1); // +1 because first tab is "All"
    }
  }

  Widget _buildAllDevicesView(BuildContext context, List<Map<String, dynamic>> devices) {
    final energyProvider = Provider.of<EnergyProvider>(context);

    return Column(
      children: [
        // Overall Statistics
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overall Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatCard(
                    title: 'Total Devices',
                    value: devices.length.toString(),
                    icon: Icons.devices,
                  ),
                  _StatCard(
                    title: 'Active Devices',
                    value: devices.where((d) => d['isOn']).length.toString(),
                    icon: Icons.power,
                  ),
                  _StatCard(
                    title: 'Total Rooms',
                    value: Provider.of<RoomProvider>(context).rooms.length.toString(),
                    icon: Icons.room,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Energy Consumption Graph
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Energy Consumption',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              EnergyGraph(
                data: energyProvider.getRoomEnergyData('All'),
                isDevice: false,
              ),
            ],
          ),
        ),
        // Devices Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return device['type'] == 'iron_meter'
                  ? IronMeterCard(
                      deviceId: device['id'],
                      deviceName: device['name'],
                      roomName: device['room'],
                      remoteType: device['remoteType'],
                      buttons: List<Map<String, dynamic>>.from(device['buttons']),
                      isConnected: true, // TODO: Implement actual connection state
                      onRoomChange: (newRoom) {
                        Provider.of<RoomProvider>(context, listen: false)
                            .updateDeviceRoom(device['id'], newRoom);
                      },
                      onDelete: () {
                        Provider.of<RoomProvider>(context, listen: false)
                            .deleteDevice(device['id']);
                      },
                      onButtonPress: (deviceId, buttonName) {
                        Provider.of<RoomProvider>(context, listen: false)
                            .sendIRCommand(deviceId, buttonName);
                      },
                      onButtonsUpdate: (deviceId, updatedButtons) {
                        Provider.of<RoomProvider>(context, listen: false)
                            .updateDeviceButtons(deviceId, updatedButtons);
                      },
                    )
                  : device['type'] == 'smart_bulb'
                      ? SmartBulbCard(
                          deviceId: device['id'],
                          deviceName: device['name'],
                          roomName: device['room'],
                          isOn: device['isOn'],
                          brightness: device['brightness'] ?? 100,
                          color: device['color'] ?? '#FFFFFF',
                          onToggle: (value) {
                            Provider.of<RoomProvider>(context, listen: false)
                                .toggleDevice(device['id']);
                          },
                          onRoomChange: (newRoom) {
                            Provider.of<RoomProvider>(context, listen: false)
                                .updateDeviceRoom(device['id'], newRoom);
                          },
                          onDelete: () {
                            Provider.of<RoomProvider>(context, listen: false)
                                .deleteDevice(device['id']);
                          },
                          onBrightnessChange: (brightness) {
                            Provider.of<RoomProvider>(context, listen: false)
                                .updateSmartBulbBrightness(device['id'], brightness);
                          },
                          onColorChange: (color) {
                            Provider.of<RoomProvider>(context, listen: false)
                                .updateSmartBulbColor(device['id'], color);
                          },
                        )
                      : DeviceCard(
                          deviceId: device['id'],
                          deviceName: device['name'],
                          roomName: device['room'],
                          isOn: device['isOn'],
                          onToggle: (value) {
                            Provider.of<RoomProvider>(context, listen: false)
                                .toggleDevice(device['id']);
                          },
                          onRoomChange: (newRoom) {
                            Provider.of<RoomProvider>(context, listen: false)
                                .updateDeviceRoom(device['id'], newRoom);
                          },
                          onDelete: () {
                            Provider.of<RoomProvider>(context, listen: false)
                                .deleteDevice(device['id']);
                          },
                        );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoomView(BuildContext context, String room, List<Map<String, dynamic>> devices) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Room Header with Options
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  room,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () => _showRoomOptions(room),
                ),
              ],
            ),
          ),
          // Devices Grid
          GridView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: devices.length + 1, // Add 1 for the default card
            itemBuilder: (context, index) {
              if (index == 0) {
                // Default card for adding device
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 128),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: _navigateToAddDevice,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add Device',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              final device = devices[index - 1];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 128),
                    width: 1,
                  ),
                ),
                child: device['type'] == 'iron_meter'
                    ? IronMeterCard(
                        deviceId: device['id'],
                        deviceName: device['name'],
                        roomName: device['room'],
                        remoteType: device['remoteType'],
                        buttons: List<Map<String, dynamic>>.from(device['buttons']),
                        isConnected: true, // TODO: Implement actual connection state
                        onRoomChange: (newRoom) {
                          Provider.of<RoomProvider>(context, listen: false)
                              .updateDeviceRoom(device['id'], newRoom);
                        },
                        onDelete: () {
                          Provider.of<RoomProvider>(context, listen: false)
                              .deleteDevice(device['id']);
                        },
                        onButtonPress: (deviceId, buttonName) {
                          Provider.of<RoomProvider>(context, listen: false)
                              .sendIRCommand(deviceId, buttonName);
                        },
                        onButtonsUpdate: (deviceId, updatedButtons) {
                          Provider.of<RoomProvider>(context, listen: false)
                              .updateDeviceButtons(deviceId, updatedButtons);
                        },
                      )
                    : device['type'] == 'smart_bulb'
                        ? SmartBulbCard(
                            deviceId: device['id'],
                            deviceName: device['name'],
                            roomName: device['room'],
                            isOn: device['isOn'],
                            brightness: device['brightness'] ?? 100,
                            color: device['color'] ?? '#FFFFFF',
                            onToggle: (value) {
                              Provider.of<RoomProvider>(context, listen: false)
                                  .toggleDevice(device['id']);
                            },
                            onRoomChange: (newRoom) {
                              Provider.of<RoomProvider>(context, listen: false)
                                  .updateDeviceRoom(device['id'], newRoom);
                            },
                            onDelete: () {
                              Provider.of<RoomProvider>(context, listen: false)
                                  .deleteDevice(device['id']);
                            },
                            onBrightnessChange: (brightness) {
                              Provider.of<RoomProvider>(context, listen: false)
                                  .updateSmartBulbBrightness(device['id'], brightness);
                            },
                            onColorChange: (color) {
                              Provider.of<RoomProvider>(context, listen: false)
                                  .updateSmartBulbColor(device['id'], color);
                            },
                          )
                        : DeviceCard(
                            deviceId: device['id'],
                            deviceName: device['name'],
                            roomName: device['room'],
                            isOn: device['isOn'],
                            onToggle: (value) {
                              Provider.of<RoomProvider>(context, listen: false)
                                  .toggleDevice(device['id']);
                            },
                            onRoomChange: (newRoom) {
                              Provider.of<RoomProvider>(context, listen: false)
                                  .updateDeviceRoom(device['id'], newRoom);
                            },
                            onDelete: () {
                              Provider.of<RoomProvider>(context, listen: false)
                                  .deleteDevice(device['id']);
                            },
                          ),
              );
            },
          ),
          // Room Insights
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoomInsights(roomName: room),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IOTIFY',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: const [],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                // Add Room Button
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: _showAddRoomDialog,
                    tooltip: 'Add Room',
                  ),
                ),
                // TabBar for All and Rooms
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: AppTheme.primaryColor,
                    labelColor: AppTheme.primaryColor,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
                    tabs: [
                      const Tab(text: 'All'),
                      ...roomProvider.rooms.map((room) => Tab(
                        text: room,
                      )).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllDevicesView(context, roomProvider.devices),
          ...roomProvider.rooms.map((room) => _buildRoomView(context, room, roomProvider.getDevicesByRoom(room))),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              NavigationService.navigateTo('/insights');
              break;
            case 2:
              NavigationService.navigateTo('/settings');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/room_provider.dart';
import '../../providers/energy_provider.dart';
import '../../widgets/room_insights.dart';
import '../../widgets/energy_graph.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String _selectedRoom = 'All';

  Widget _buildAllInsights(BuildContext context, RoomProvider roomProvider, EnergyProvider energyProvider) {
    return Column(
      children: [
        // Overall Statistics
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
              Text(
                'Overall Statistics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatCard(
                    title: 'Total Devices',
                    value: roomProvider.devices.length.toString(),
                    icon: Icons.devices,
                  ),
                  _StatCard(
                    title: 'Active Devices',
                    value: roomProvider.devices.where((d) => d['isOn']).length.toString(),
                    icon: Icons.power,
                  ),
                  _StatCard(
                    title: 'Total Rooms',
                    value: roomProvider.rooms.length.toString(),
                    icon: Icons.room,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Total Energy Consumption
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
              Text(
                'Total Energy Consumption',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              EnergyGraph(
                data: energyProvider.getRoomEnergyData('All'),
                isDevice: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Room-wise Statistics
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
              Text(
                'Room-wise Statistics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...roomProvider.rooms.where((room) => room != 'All').map((room) {
                final devices = roomProvider.getDevicesByRoom(room);
                final activeDevices = devices.where((d) => d['isOn']).length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(room, style: Theme.of(context).textTheme.titleMedium),
                      Row(
                        children: [
                          Icon(
                            Icons.devices,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text('${devices.length} devices'),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.power,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text('$activeDevices active'),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoomInsights(BuildContext context, String roomName, RoomProvider roomProvider, EnergyProvider energyProvider) {
    final devices = roomProvider.getDevicesByRoom(roomName);
    final activeDevices = devices.where((d) => d['isOn']).length;

    return Column(
      children: [
        // Room Statistics
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
              Text(
                '$roomName Statistics',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatCard(
                    title: 'Devices',
                    value: devices.length.toString(),
                    icon: Icons.devices,
                  ),
                  _StatCard(
                    title: 'Active',
                    value: activeDevices.toString(),
                    icon: Icons.power,
                  ),
                  _StatCard(
                    title: 'Energy Usage',
                    value: '${energyProvider.getRoomEnergyData(roomName).isNotEmpty ? energyProvider.getRoomEnergyData(roomName).last.consumption.toStringAsFixed(1) : '0.0'} kWh',
                    icon: Icons.bolt,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Room Energy Consumption
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
              Text(
                'Room Energy Consumption',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              EnergyGraph(
                data: energyProvider.getRoomEnergyData(roomName),
                isDevice: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Room Insights
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RoomInsights(roomName: roomName),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);
    final energyProvider = Provider.of<EnergyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Room selector
            Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedRoom == 'All',
                      onSelected: (selected) {
                        setState(() {
                          _selectedRoom = 'All';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ...roomProvider.rooms.where((room) => room != 'All').map((room) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(room),
                          selected: _selectedRoom == room,
                          onSelected: (selected) {
                            setState(() {
                              _selectedRoom = room;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            // Content based on selected room
            _selectedRoom == 'All'
                ? _buildAllInsights(context, roomProvider, energyProvider)
                : _buildRoomInsights(context, _selectedRoom, roomProvider, energyProvider),
          ],
        ),
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
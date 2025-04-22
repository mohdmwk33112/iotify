import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/energy_provider.dart';
import 'energy_graph.dart';

class RoomInsights extends StatelessWidget {
  final String roomName;

  const RoomInsights({
    required this.roomName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final energyProvider = Provider.of<EnergyProvider>(context);
    
    // Initialize data if not already done
    energyProvider.initializeData('', roomName);
    
    final roomData = energyProvider.getRoomEnergyData(roomName);
    final totalConsumption = energyProvider.getRoomTotalConsumption(roomName);
    final totalCost = energyProvider.getRoomTotalCost(roomName);
    final peakUsageTime = energyProvider.getPeakUsageTime(roomName);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room Insights',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          // Energy Graph
          const Text(
            'Energy Consumption',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          EnergyGraph(data: roomData, isDevice: false),
          const SizedBox(height: 24),
          // Statistics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatCard(
                title: 'Total Consumption',
                value: '${totalConsumption.toStringAsFixed(2)}W',
                icon: Icons.power,
              ),
              _StatCard(
                title: 'Total Cost',
                value: '\$${totalCost.toStringAsFixed(2)}',
                icon: Icons.attach_money,
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Peak Usage Time
          const Text(
            'Peak Usage Time',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${peakUsageTime.hour}:00',
            style: Theme.of(context).textTheme.bodyLarge,
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
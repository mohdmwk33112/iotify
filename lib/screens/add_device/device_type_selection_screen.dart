import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'smart_bulb_setup_screen.dart';
import 'ir_emitter_setup_screen.dart';
import '../add_device/add_device_screen.dart';

class DeviceTypeSelectionScreen extends StatelessWidget {
  const DeviceTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Device Type'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose a device type to add',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isSmallScreen ? 1 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildDeviceTypeCard(
                  context,
                  'Smart Plug',
                  Icons.power,
                  'Control any device with a plug',
                  () => _navigateToDeviceSetup(context, 'smart_plug'),
                ),
                _buildDeviceTypeCard(
                  context,
                  'Smart Bulb',
                  Icons.lightbulb_outline,
                  'Control your lighting',
                  () => _navigateToDeviceSetup(context, 'smart_bulb'),
                ),
                _buildDeviceTypeCard(
                  context,
                  'IR Emitter',
                  Icons.settings_remote,
                  'Control your IR devices',
                  () => _navigateToDeviceSetup(context, 'ir_emitter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceTypeCard(
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDeviceSetup(BuildContext context, String deviceType) {
    switch (deviceType) {
      case 'smart_plug':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddDeviceScreen(deviceType: deviceType)),
        );
        break;
      case 'smart_bulb':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SmartBulbSetupScreen()),
        );
        break;
      case 'ir_emitter':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const IrEmitterSetupScreen()),
        );
        break;
    }
  }
} 
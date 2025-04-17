import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/platform_widgets.dart';
import '../../models/device.dart';
import '../../services/device_service.dart';
import '../../routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _deviceService = DeviceService();
  List<Device> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    try {
      final devices = await _deviceService.getDevices();
      if (!mounted) return;
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            PlatformDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidgets.pageScaffold(
      context: context,
      appBar: PlatformWidgets.appBar(
        context: context,
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addDevice),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _devices.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No devices found'),
                      const SizedBox(height: 16),
                      PlatformWidgets.button(
                        context: context,
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.addDevice),
                        child: const Text('Add Device'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    final device = _devices[index];
                    return ListTile(
                      title: Text(device.name),
                      subtitle: Text('${device.type} - ${device.status}'),
                      trailing: Text(device.location),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.deviceDetail,
                        arguments: device,
                      ),
                    );
                  },
                ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/platform_widgets.dart';
import '../../models/device.dart';
import '../../services/device_service.dart';

class DeviceDetailScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailScreen({super.key, required this.device});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  final _deviceService = DeviceService();
  bool _isLoading = false;

  Future<void> _toggleDeviceStatus() async {
    setState(() => _isLoading = true);

    try {
      final updatedDevice = Device(
        id: widget.device.id,
        name: widget.device.name,
        type: widget.device.type,
        status: widget.device.status == 'Online' ? 'Offline' : 'Online',
        location: widget.device.location,
        createdAt: widget.device.createdAt,
      );
      await _deviceService.updateDevice(updatedDevice);
      if (!mounted) return;
      setState(() => widget.device.status = updatedDevice.status);
    } catch (e) {
      if (!mounted) return;
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteDevice() async {
    setState(() => _isLoading = true);

    try {
      await _deviceService.deleteDevice(widget.device.id);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidgets.pageScaffold(
      context: context,
      appBar: PlatformWidgets.appBar(
        context: context,
        title: widget.device.name,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Device Details',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Name', widget.device.name),
                    _buildDetailRow('Type', widget.device.type),
                    _buildDetailRow('Location', widget.device.location),
                    _buildDetailRow('Status', widget.device.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: PlatformWidgets.button(
                    context: context,
                    onPressed: _isLoading ? () {} : _toggleDeviceStatus,
                    child: Text(
                      widget.device.status == 'Online' ? 'Turn Off' : 'Turn On',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PlatformWidgets.button(
                    context: context,
                    onPressed: _isLoading ? () {} : _deleteDevice,
                    color: Colors.red,
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
} 
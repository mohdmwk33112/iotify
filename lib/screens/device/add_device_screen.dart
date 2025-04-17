import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../core/platform_widgets.dart';
import '../../models/device.dart';
import '../../services/device_service.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _locationController = TextEditingController();
  final _deviceService = DeviceService();
  bool _isLoading = false;

  Future<void> _addDevice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final device = Device(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _typeController.text,
        status: 'Offline',
        location: _locationController.text,
        createdAt: DateTime.now(),
      );
      await _deviceService.addDevice(device);
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
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidgets.pageScaffold(
      context: context,
      appBar: PlatformWidgets.appBar(
        context: context,
        title: 'Add Device',
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              PlatformWidgets.textField(
                context: context,
                controller: _nameController,
                placeholder: 'Device Name',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a device name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PlatformWidgets.textField(
                context: context,
                controller: _typeController,
                placeholder: 'Device Type',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a device type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PlatformWidgets.textField(
                context: context,
                controller: _locationController,
                placeholder: 'Location',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              PlatformWidgets.button(
                context: context,
                onPressed: () {
                  // TODO: Implement device connection logic
                  print('Connect to device button pressed');
                },
                child: const Text('Connect to Device'),
              ),
              const SizedBox(height: 16),
              PlatformWidgets.button(
                context: context,
                onPressed: _isLoading ? () {} : _addDevice,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Add Device'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
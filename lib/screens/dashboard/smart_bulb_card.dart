import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/device_insights_dialog.dart';

class SmartBulbCard extends StatelessWidget {
  final String deviceId;
  final String deviceName;
  final String roomName;
  final bool isOn;
  final int brightness;
  final String color;
  final Function(bool) onToggle;
  final Function(String) onRoomChange;
  final Function() onDelete;
  final Function(int) onBrightnessChange;
  final Function(String) onColorChange;

  const SmartBulbCard({
    required this.deviceId,
    required this.deviceName,
    required this.roomName,
    required this.isOn,
    required this.brightness,
    required this.color,
    required this.onToggle,
    required this.onRoomChange,
    required this.onDelete,
    required this.onBrightnessChange,
    required this.onColorChange,
    super.key,
  });

  void _showDeviceInsights(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeviceInsightsDialog(
        deviceId: deviceId,
        deviceName: deviceName,
        roomName: roomName,
        onDelete: onDelete,
      ),
    );
  }

  void _showBrightnessDialog(BuildContext context) {
    double currentBrightness = brightness.toDouble();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Adjust Brightness'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: currentBrightness,
                min: 0,
                max: 100,
                divisions: 100,
                label: '${currentBrightness.round()}%',
                onChanged: (value) {
                  setState(() {
                    currentBrightness = value;
                    onBrightnessChange(value.round());
                  });
                },
              ),
              Text('${currentBrightness.round()}%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorDialog(BuildContext context) {
    final List<String> colors = [
      '#FFFFFF', // White
      '#FF0000', // Red
      '#00FF00', // Green
      '#0000FF', // Blue
      '#FFFF00', // Yellow
      '#FF00FF', // Magenta
      '#00FFFF', // Cyan
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((c) {
            return InkWell(
              onTap: () {
                onColorChange(c);
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(int.parse(c.replaceAll('#', '0xFF'))),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: c == color ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = Color(int.parse(color.replaceAll('#', '0xFF')));
    final alphaValue = isOn ? ((brightness / 100) * 255).round() : 77;
    final borderColor = selectedColor.withAlpha(alphaValue);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showDeviceInsights(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
            border: Border.all(
              color: isOn 
                  ? borderColor
                  : (isDark ? AppColors.darkDeviceOffBackground : AppColors.lightSwitchOffBackground),
              width: isOn ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark 
                    ? Colors.black.withValues(alpha: 102)
                    : Colors.black.withValues(alpha: 20),
                blurRadius: isDark ? 12 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device icon and controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 32,
                    color: isOn 
                        ? selectedColor
                        : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.brightness_6,
                          color: isOn 
                              ? selectedColor
                              : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
                        ),
                        onPressed: isOn ? () => _showBrightnessDialog(context) : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.palette,
                          color: isOn 
                              ? selectedColor
                              : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
                        ),
                        onPressed: isOn ? () => _showColorDialog(context) : null,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Device name and room
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deviceName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isOn 
                          ? selectedColor
                          : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground).withValues(alpha: 128),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      roomName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Toggle switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isOn ? 'On' : 'Off',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isOn 
                          ? selectedColor
                          : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
                    ),
                  ),
                  Switch(
                    value: isOn,
                    onChanged: onToggle,
                    activeColor: selectedColor,
                    inactiveTrackColor: isDark ? AppColors.darkDeviceOffBackground : AppColors.lightSwitchOffBackground,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 
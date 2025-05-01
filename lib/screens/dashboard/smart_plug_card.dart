import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/smart_plug_insights_dialog.dart';

class SmartPlugCard extends StatelessWidget {
  final String deviceId;
  final String deviceName;
  final String roomName;
  final bool isOn;
  final Function(bool) onToggle;
  final Function(String) onRoomChange;
  final Function() onDelete;

  const SmartPlugCard({
    required this.deviceId,
    required this.deviceName,
    required this.roomName,
    required this.isOn,
    required this.onToggle,
    required this.onRoomChange,
    required this.onDelete,
    super.key,
  });

  void _showDeviceInsights(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SmartPlugInsightsDialog(
        deviceId: deviceId,
        deviceName: deviceName,
        roomName: roomName,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
                  ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
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
              // Device icon
              Icon(
                Icons.power,
                size: 32,
                color: isOn 
                    ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
                    : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
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
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
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
                          ? (isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple)
                          : (isDark ? AppColors.darkTextSecondaryStart : AppColors.lightTextSecondary),
                    ),
                  ),
                  Switch(
                    value: isOn,
                    onChanged: onToggle,
                    activeColor: isDark ? AppColors.darkAccentPurple : AppColors.lightAccentPurple,
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
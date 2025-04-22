import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class DeviceScheduleScreen extends StatefulWidget {
  final String deviceName;

  const DeviceScheduleScreen({
    super.key,
    required this.deviceName,
  });

  @override
  State<DeviceScheduleScreen> createState() => _DeviceScheduleScreenState();
}

class _DeviceScheduleScreenState extends State<DeviceScheduleScreen> {
  TimeOfDay? _onTime;
  TimeOfDay? _offTime;
  bool _repeatDaily = true;
  final List<bool> _selectedDays = List.generate(7, (index) => false);

  Future<void> _selectTime(BuildContext context, bool isOnTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isOnTime) {
          _onTime = picked;
        } else {
          _offTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Schedule ${widget.deviceName}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // On time
            _TimePickerCard(
              title: 'Turn On',
              time: _onTime,
              onTap: () => _selectTime(context, true),
            ),
            const SizedBox(height: 24),
            // Off time
            _TimePickerCard(
              title: 'Turn Off',
              time: _offTime,
              onTap: () => _selectTime(context, false),
            ),
            const SizedBox(height: 32),
            // Repeat options
            Text(
              'Repeat',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 16),
            // Daily/Weekly toggle
            Row(
              children: [
                Expanded(
                  child: _RepeatOption(
                    label: 'Daily',
                    isSelected: _repeatDaily,
                    onTap: () {
                      setState(() {
                        _repeatDaily = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _RepeatOption(
                    label: 'Weekly',
                    isSelected: !_repeatDaily,
                    onTap: () {
                      setState(() {
                        _repeatDaily = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (!_repeatDaily) ...[
              const SizedBox(height: 24),
              // Day selection
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun',
                ].asMap().entries.map((entry) {
                  final index = entry.key;
                  final day = entry.value;
                  return FilterChip(
                    label: Text(day),
                    selected: _selectedDays[index],
                    onSelected: (selected) {
                      setState(() {
                        _selectedDays[index] = selected;
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 128),
                    labelStyle: TextStyle(
                      color: _selectedDays[index]
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 32),
            // Save button
            ElevatedButton(
              onPressed: () {
                // Handle schedule save
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Schedule',
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

class _TimePickerCard extends StatelessWidget {
  final String title;
  final TimeOfDay? time;
  final VoidCallback onTap;

  const _TimePickerCard({
    required this.title,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                time?.format(context) ?? 'Select Time',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: time != null
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RepeatOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RepeatOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 128)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 128),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/room_provider.dart';

class AddRoomDialog extends StatefulWidget {
  const AddRoomDialog({super.key});

  @override
  State<AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
  final _roomNameController = TextEditingController();

  @override
  void dispose() {
    _roomNameController.dispose();
    super.dispose();
  }

  void _addRoom() {
    if (_roomNameController.text.isNotEmpty) {
      final roomProvider = Provider.of<RoomProvider>(context, listen: false);
      roomProvider.addRoom(_roomNameController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Room'),
      content: TextField(
        controller: _roomNameController,
        decoration: const InputDecoration(
          labelText: 'Room Name',
          hintText: 'Enter room name',
        ),
        onSubmitted: (_) => _addRoom(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addRoom,
          child: const Text('Add'),
        ),
      ],
    );
  }
} 
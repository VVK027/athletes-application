import 'package:flutter/material.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/passport_notifier.dart';
import 'package:athletes_application/models/athlete_models.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showMediaPickerSheet(BuildContext context, PassportNotifier notifier) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => _MediaPickerSheet(notifier: notifier, parentContext: context),
  );
}

class _MediaPickerSheet extends StatefulWidget {
  const _MediaPickerSheet({required this.notifier, required this.parentContext});

  final PassportNotifier notifier;
  final BuildContext parentContext;

  @override
  State<_MediaPickerSheet> createState() => _MediaPickerSheetState();
}

class _MediaPickerSheetState extends State<_MediaPickerSheet> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'New upload');
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.paddingOf(context).bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add photo or video',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.navy,
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined, color: AppTheme.teal),
            title: const Text('Take photo'),
            onTap: () async {
              Navigator.pop(context);
              await _pickAndSave(
                widget.parentContext,
                widget.notifier,
                _titleController.text,
                ImageSource.camera,
                isVideo: false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: AppTheme.teal),
            title: const Text('Choose photo'),
            onTap: () async {
              Navigator.pop(context);
              await _pickAndSave(
                widget.parentContext,
                widget.notifier,
                _titleController.text,
                ImageSource.gallery,
                isVideo: false,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam_outlined, color: AppTheme.teal),
            title: const Text('Choose video'),
            onTap: () async {
              Navigator.pop(context);
              await _pickAndSave(
                widget.parentContext,
                widget.notifier,
                _titleController.text,
                ImageSource.gallery,
                isVideo: true,
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _pickAndSave(
  BuildContext context,
  PassportNotifier notifier,
  String title,
  ImageSource source, {
  required bool isVideo,
}) async {
  final picker = ImagePicker();
  try {
    if (isVideo) {
      final video = await picker.pickVideo(source: source);
      if (video == null || !context.mounted) return;
      await notifier.addMediaFromPicker(
        title: title.trim().isEmpty ? 'Video' : title.trim(),
        type: MediaType.video,
        sourcePath: video.path,
        duration: null,
      );
    } else {
      final photo = await picker.pickImage(source: source, imageQuality: 85);
      if (photo == null || !context.mounted) return;
      await notifier.addMediaFromPicker(
        title: title.trim().isEmpty ? 'Photo' : title.trim(),
        type: MediaType.photo,
        sourcePath: photo.path,
      );
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Media saved to passport')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not add media: $e')),
      );
    }
  }
}

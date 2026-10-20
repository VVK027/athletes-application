import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/permissions/passport_permissions.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/media/media_detail_screen.dart';
import 'package:athletes_application/features/athlete_passport/media/media_picker_sheet.dart';
import 'package:athletes_application/features/athlete_passport/passport_scope.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class MediaSection extends StatelessWidget {
  const MediaSection({super.key, required this.data, required this.viewRole});

  final AthletePassportData data;
  final AccessRole viewRole;

  @override
  Widget build(BuildContext context) {
    final photos = data.media.where((m) => m.type == MediaType.photo).length;
    final videos = data.media.where((m) => m.type == MediaType.video).length;
    final canUpload = PassportPermissions.canEdit(PassportFeature.mediaUpload, viewRole);
    final notifier = PassportScope.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: 'Photos & videos',
          subtitle: '$photos photos · $videos videos',
          trailing: canUpload
              ? IconButton(
                  onPressed: () => showMediaPickerSheet(context, notifier),
                  icon: const Icon(Icons.add_photo_alternate_outlined, color: AppTheme.teal),
                  tooltip: 'Add media',
                )
              : null,
          child: data.media.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No media yet')),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = context.gridColumns(compact: 2, medium: 3, expanded: 4);
                    return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: data.media.length,
                  itemBuilder: (context, index) => _MediaTile(
                    item: data.media[index],
                    canDelete: viewRole == AccessRole.athlete,
                    onDelete: () => notifier.removeMedia(data.media[index].id),
                  ),
                );
                  },
                ),
        ),
      ],
    );
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.item,
    required this.canDelete,
    required this.onDelete,
  });

  final MediaItem item;
  final bool canDelete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.thumbnailColor);
    final isVideo = item.type == MediaType.video;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => MediaDetailScreen(item: item),
          ),
        );
      },
      onLongPress: canDelete
          ? () {
              showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Remove media?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        onDelete();
                      },
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              );
            }
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _MediaThumbnail(item: item, fallbackColor: color),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isVideo)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow, color: Colors.white, size: 14),
                          Text(
                            item.duration ?? 'Video',
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black45)],
                    ),
                  ),
                ],
              ),
            ),
            if (isVideo)
              const Center(
                child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 40),
              ),
          ],
        ),
      ),
    );
  }
}

class _MediaThumbnail extends StatelessWidget {
  const _MediaThumbnail({required this.item, required this.fallbackColor});

  final MediaItem item;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    if (item.localPath != null && !kIsWeb && File(item.localPath!).existsSync()) {
      return item.type == MediaType.video
          ? _videoThumbFromFile(item.localPath!)
          : Image.file(File(item.localPath!), fit: BoxFit.cover);
    }
    if (item.hasRemote && item.type == MediaType.photo) {
      return Image.network(
        item.remoteUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _gradient(fallbackColor),
      );
    }
    return _gradient(fallbackColor);
  }

  Widget _videoThumbFromFile(String path) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _gradient(fallbackColor),
        const Center(child: Icon(Icons.movie, color: Colors.white54, size: 36)),
      ],
    );
  }

  Widget _gradient(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.7)],
        ),
      ),
    );
  }
}

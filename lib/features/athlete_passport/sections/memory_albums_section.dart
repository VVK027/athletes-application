import 'package:flutter/material.dart';
import 'package:athletes_application/core/layout/responsive_layout.dart';
import 'package:athletes_application/core/theme/app_theme.dart';
import 'package:athletes_application/features/athlete_passport/media/media_detail_screen.dart';
import 'package:athletes_application/features/athlete_passport/widgets/passport_widgets.dart';
import 'package:athletes_application/models/athlete_models.dart';

class MemoryAlbumsSection extends StatelessWidget {
  const MemoryAlbumsSection({super.key, required this.data});

  final AthletePassportData data;

  @override
  Widget build(BuildContext context) {
    final bySeason = <String, List<MemoryAlbum>>{};
    for (final album in data.memoryAlbums) {
      bySeason.putIfAbsent(album.season, () => []).add(album);
    }
    final seasons = bySeason.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PassportSectionCard(
          title: 'Memory albums',
          subtitle: '${data.memoryAlbums.length} albums · photos & videos by season & event',
          child: data.memoryAlbums.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No albums yet')),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final season in seasons) ...[
                      Text(
                        season,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.navy,
                            ),
                      ),
                      const SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = context.gridColumns(compact: 1, medium: 2, expanded: 3);
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columns,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.35,
                            ),
                            itemCount: bySeason[season]!.length,
                            itemBuilder: (context, index) {
                              final album = bySeason[season]![index];
                              return _AlbumCard(album: album, data: data);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({required this.album, required this.data});

  final MemoryAlbum album;
  final AthletePassportData data;

  @override
  Widget build(BuildContext context) {
    final media = album.mediaIds
        .map((id) => data.media.where((m) => m.id == id).firstOrNull)
        .whereType<MediaItem>()
        .toList();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (media.isEmpty) return;
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _AlbumDetailScreen(album: album, media: media),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _AlbumCover(album: album, media: media),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.navy),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    album.eventName,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${media.length} items · ${album.season}',
                    style: const TextStyle(fontSize: 11, color: AppTheme.teal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumCover extends StatelessWidget {
  const _AlbumCover({required this.album, required this.media});

  final MemoryAlbum album;
  final List<MediaItem> media;

  @override
  Widget build(BuildContext context) {
    final color = Color(album.coverColor);
    if (media.isEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
        ),
        child: const Center(
          child: Icon(Icons.photo_album_outlined, color: Colors.white54, size: 40),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.6)]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              for (var i = 0; i < media.length.clamp(0, 3); i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 4),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(media[i].thumbnailColor),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Icon(
                          media[i].type == MediaType.video ? Icons.play_arrow : Icons.image,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlbumDetailScreen extends StatelessWidget {
  const _AlbumDetailScreen({required this.album, required this.media});

  final MemoryAlbum album;
  final List<MediaItem> media;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(album.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(album.summary, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(
            '${album.eventName} · ${album.season}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ...media.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Icon(
                  item.type == MediaType.video ? Icons.videocam : Icons.photo,
                  color: AppTheme.teal,
                ),
                title: Text(item.title),
                subtitle: Text(item.date.toString().split(' ').first),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => MediaDetailScreen(item: item),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

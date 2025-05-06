import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  late Future<List<Map<String, dynamic>>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _videosFuture = fetchVideos();
  }

  Future<List<Map<String, dynamic>>> fetchVideos() async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('Videos')
              .doc('Videos')
              .get();

      if (!doc.exists) {
        debugPrint('Document does not exist.');
        return [];
      }

      final data = doc.data();
      if (data == null) {
        debugPrint('Document data is null.');
        return [];
      }

      final videoList = <Map<String, dynamic>>[];

      for (var entry in data.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic>) {
          videoList.add(value);
        } else {
          debugPrint('Invalid entry: ${entry.key} -> ${entry.value}');
        }
      }

      return videoList;
    } catch (e) {
      debugPrint('Error fetching videos: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text('Videos', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Link(
              uri: Uri.parse('https://www.youtube.com/@JFA-TV'),
              target: LinkTarget.self,
              builder:
                  (context, followLink) => InkWell(
                    onTap: followLink,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Jordan Football official channel >>',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _videosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No videos found.'));
                  }

                  final videos = snapshot.data!;

                  return ListView.separated(
                    itemCount: videos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      final imageUrl = video['image'] ?? '';
                      final title = video['name'] ?? '';
                      final link = video['link'] ?? '';

                      return InkWell(
                        onTap: () async {
                          final uri = Uri.tryParse(link);
                          if (uri != null && await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: 120,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => const SizedBox(
                                      width: 120,
                                      height: 80,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) =>
                                        const Icon(Icons.broken_image),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

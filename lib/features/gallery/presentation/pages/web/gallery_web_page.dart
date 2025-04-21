import 'dart:ui'; // Import for BackdropFilter
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:megatronix/common/widgets/custom_image.dart';
import 'package:megatronix/common/widgets/custom_web_scaffold.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/features/gallery/providers/gallery_provider.dart';

class GalleryWebPage extends ConsumerStatefulWidget {
  final bool isMainPage;
  const GalleryWebPage({
    super.key,
    this.isMainPage = true,
  });

  @override
  ConsumerState<GalleryWebPage> createState() => _GalleryWebPageState();
}

class _GalleryWebPageState extends ConsumerState<GalleryWebPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(galleryNotifierProvider.notifier).getGalleries();
    });
  }

  void _showCustomImageViewer(int index, List<String> imageUrls) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                // Background blur effect
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black
                        .withAlpha(125), // Semi-transparent background
                  ),
                ),
                // Full-screen image viewer
                PageView.builder(
                  itemCount: imageUrls.length,
                  controller: PageController(initialPage: index),
                  itemBuilder: (context, pageIndex) {
                    return Center(
                        child: CachedNetworkImage(
                      imageUrl: imageUrls[pageIndex],
                      fit: BoxFit.contain,
                    ));
                  },
                ),
                // Close button
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the viewer
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final galleryState = ref.watch(galleryNotifierProvider);
    if (galleryState.isLoading) {
      return CustomWebScaffold(
        title: 'Gallery',
        isMainPage: widget.isMainPage,
        child: Center(
          child: LoadingWidget(),
        ),
      );
    }

    if (galleryState.galleries != null && context.mounted) {
      final imageUrls =
          galleryState.galleries!.map((g) => g.imageLink).toList();

      return CustomWebScaffold(
        title: 'Gallery',
        isMainPage: widget.isMainPage,
        child: Column(
          children: [
            SizedBox(height: 15),
            Expanded(
              child: galleryState.galleries!.isEmpty
                  ? Center(
                      child: Text('No images to load...'),
                    )
                  : MasonryGridView.count(
                      crossAxisCount: 5,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 10,
                      itemCount: galleryState.galleries?.length ?? 0,
                      itemBuilder: (context, index) {
                        final imageUrl =
                            galleryState.galleries!.elementAt(index).imageLink;
                        return GestureDetector(
                          onTap: () {
                            _showCustomImageViewer(
                              index,
                              imageUrls,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CustomImage(
                              image: imageUrl,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 75)
          ],
        ),
      );
    }

    return CustomWebScaffold(
      title: 'Gallery',
      isMainPage: widget.isMainPage,
      child: Center(
        child: Text(
          'Failed to load gallery data\nCheck your internet connection',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

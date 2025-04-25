import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:megatronix/common/widgets/loading_widget.dart';
import 'package:megatronix/core/utils/util_functions.dart';

class CustomImage extends StatefulWidget {
  final String image;
  final double? height;
  final double? width;
  const CustomImage({
    super.key,
    required this.image,
    this.height,
    this.width,
  });

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _images = UtilFunctions.getTextFieldImagesList(5);
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.image,
      height: widget.height,
      width: widget.width,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Center(
          child: LoadingWidget(),
        );
      },
      errorWidget: (context, url, error) {
        return Center(
          child: Image.asset(
            _images[0],
            height: 75,
            width: 75,
          ),
        );
      },
    );
  }
}

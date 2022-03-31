import 'package:flutter/material.dart';

class AppRoundImage extends StatelessWidget {
  final ImageProvider provider;
  final double height;
  final double width;

  const AppRoundImage({
    Key? key,
    required this.provider,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: Image(
        image: provider,
        height: height,
        width: width,
      ),
    );
  }

  factory AppRoundImage.url(
    String url, {
    required double height,
    required double width,
  }) {
    return AppRoundImage(
      provider: NetworkImage(url),
      height: height,
      width: width,
    );
  }
}

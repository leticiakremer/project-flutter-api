import 'package:flutter/material.dart';

class CharacterImage extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final double height;
  final double width;

  const CharacterImage({
    Key? key,
    required this.imageUrl,
    required this.heroTag,
    this.height = 200,
    this.width = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Hero(
        tag: heroTag,
        createRectTween: (begin, end) {
          return RectTween(begin: begin, end: end);
        },
        child: AnimatedClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(imageUrl,
              fit: BoxFit.fill,
              height: height,
              width: width, errorBuilder: (context, error, stackTrace) {
            return const CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 2,
            );
          }),
        ),
      ),
    );
  }
}

class AnimatedClipRRect extends StatelessWidget {
  final BorderRadius borderRadius;
  final Widget child;

  const AnimatedClipRRect({
    Key? key,
    required this.borderRadius,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;
  const Skeleton({super.key, this.width, this.height, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor:
            Theme.of(context).appBarTheme.foregroundColor!.withOpacity(0.1),
        highlightColor:
            Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.1),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: Theme.of(context).scaffoldBackgroundColor),
        ),
      ),
    );
  }
}

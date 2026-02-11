import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SVGIcon extends StatelessWidget {
  final String src;
  final Color? color;
  final double? height;
  final double? width;

  const SVGIcon({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color svgColor = color ?? Theme.of(context).colorScheme.primary;

    return SvgPicture.asset(
      src,
      height: height ?? 40,
      width: width ?? 40,
      colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
    );
  }
}

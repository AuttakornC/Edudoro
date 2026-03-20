/*
 * File: svgIcon.dart
 * Description: Defines a reusable SVGIcon widget for displaying SVG images in Edudoro.
 * 
 * Dependencies:
 * - Depends on flutter_svg library for vector rendering.
 * 
 * Lifecycle:
 * - Stateless widget that rebuilds when its parent rebuilds.
 * 
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// A reusable widget for displaying SVG icons with optional color and size.
///
/// Fields:
/// - [src]: The asset path to the SVG file.
/// - [color]: Optional color to apply to the SVG vector.
/// - [height]: Optional height constraint.
/// - [width]: Optional width constraint.
///
/// Usage:
/// - Use to display vector icons throughout the app.
class SVGIcon extends StatelessWidget {
  /// The asset path to the SVG file.
  final String src;

  /// Optional color to apply to the SVG vector.
  final Color? color;

  /// Optional height constraint.
  final double? height;

  /// Optional width constraint.
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

import 'package:flutter/material.dart';
import 'package:edudoro/types/decorations.dart';

/// The `DecorationDisplay` widget renders an avatar surrounded by a frame.
///
/// Both [avatar] and [frame] are optional. If only one is provided, only that
/// asset is rendered.
///
/// The [detail] field of each [Decorations] object is used as the filename
/// inside the corresponding asset folder:
/// - Avatars → `assets/avatars/<detail>` (PNG)
/// - Frames  → `assets/frames/<detail>`  (PNG)
///
/// Usage:
/// ```dart
/// DecorationDisplay(
///   avatar: Decorations(type: DecorationType.icon, detail: "Avatar1.png"),
///   frame: Decorations(type: DecorationType.frame, detail: "Frame1.png"),
///   size: 80,
/// );
/// ```

class DecorationDisplay extends StatelessWidget {
  /// The avatar to render at the center.
  final Decorations? avatar;

  /// The frame decoration to render on top, visually surrounding the avatar.
  final Decorations? frame;

  /// The width and height of the widget in logical pixels. Defaults to 64.
  final double size;

  const DecorationDisplay({
    super.key,
    this.avatar,
    this.frame,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (avatar != null) _buildAvatar(avatar!),
          if (frame != null) _buildFrame(frame!),
        ],
      ),
    );
  }

  Widget _buildAvatar(Decorations decoration) {
    return Image.asset(
      'assets/avatars/${decoration.detail}',
      fit: BoxFit.contain,
    );
  }

  Widget _buildFrame(Decorations decoration) {
    return Image.asset(
      'assets/frames/${decoration.detail}',
      fit: BoxFit.cover,
    );
  }
}

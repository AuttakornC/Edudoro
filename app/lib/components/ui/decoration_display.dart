/*
File: decoration_display.dart
Description: Reusable UI widget for rendering a profile avatar with an optional decorative frame overlay.
Responsibilities:
- Render avatar and frame image assets using decoration metadata.
- Maintain consistent sizing and overlay alignment for profile visuals.
- Provide a single presentation component for decoration previews.
Dependencies:
- flutter/material.dart
- edudoro/types/decorations.dart
Lifecycle:
- Stateless widget lifecycle with rendering driven by input properties.
- Rebuilds when parent updates decoration or sizing inputs.
Author: Chanakarn Palipol
Course: Mobile Application Development Framework
*/

import 'package:flutter/material.dart';
import 'package:edudoro/types/decorations.dart';

/// Renders a profile decoration preview with an optional avatar and frame.
///
/// Fields:
/// - [avatar]: Optional avatar decoration rendered at the center.
/// - [frame]: Optional frame decoration rendered on top of the avatar.
/// - [size]: Base width and height of the avatar display area.
/// - [frameScale]: Scale multiplier applied to frame size relative to [size].
///
/// Usage:
/// - Used in profile and decoration-related screens to visualize selected items.
/// - Consumes [Decorations.detail] values to resolve asset file names.
class DecorationDisplay extends StatelessWidget {
  /// Optional avatar decoration rendered at the center.
  final Decorations? avatar;

  /// Optional frame decoration rendered on top of the avatar.
  final Decorations? frame;

  /// Base width and height of the avatar display area.
  final double size;

  /// Scale multiplier applied to frame size relative to [size].
  final double frameScale;

  /// Creates a [DecorationDisplay] with optional [avatar] and [frame].
  const DecorationDisplay({
    super.key,
    this.avatar,
    this.frame,
    this.size = 64,
    this.frameScale = 1.3,
  });

  @override
  Widget build(BuildContext context) {
    final frameSize = size * frameScale;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (avatar != null) _buildAvatar(avatar!),
          if (frame != null)
            OverflowBox(
              maxWidth: frameSize,
              maxHeight: frameSize,
              child: _buildFrame(frame!),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Decorations decoration) {
    return ClipOval(
      child: Image.asset(
        'assets/avatars/${decoration.detail}',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildFrame(Decorations decoration) {
    return Image.asset(
      'assets/frames/${decoration.detail}',
      fit: BoxFit.contain,
    );
  }
}

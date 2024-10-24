library animated_loading_bar;

import 'package:flutter/material.dart';

/// A customizable horizontal loading bar with animated color transitions.
class AnimatedLoadingBar extends StatefulWidget {
  final double height;
  final List<Color> colors;
  final Duration duration;

  /// Creates an [AnimatedLoadingBar].
  ///
  /// The [colors] parameter must not be null and should contain at least two colors.
  /// The [height] parameter specifies the height of the loading bar.
  /// The [duration] parameter specifies the duration of the color animation.
  
  const AnimatedLoadingBar({
    Key? key,
    this.height = 10.0,
    required this.colors,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _AnimatedLoadingBarState createState() => _AnimatedLoadingBarState();
}

class _AnimatedLoadingBarState extends State<AnimatedLoadingBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = TweenSequence<Color?>(
      widget.colors
          .asMap()
          .entries
          .map((entry) {
            int idx = entry.key;
            Color color = entry.value;
            Color nextColor = widget.colors[(idx + 1) % widget.colors.length];
            return TweenSequenceItem(
              tween: ColorTween(begin: color, end: nextColor),
              weight: 1,
            );
          })
          .toList(),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return LinearProgressIndicator(
          backgroundColor: Colors.grey[200],
          color: _animation.value,
          minHeight: widget.height,
        );
      },
    );
  }
}

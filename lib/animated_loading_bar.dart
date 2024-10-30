library animated_loading_bar;

import 'package:flutter/material.dart';

/// A customizable horizontal loading bar with animated color transitions.
class AnimatedLoadingBar extends StatefulWidget {
  final double height;
  final List<Color> colors;
  final Duration duration;
  final LoadingType loadingType;

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
    this.loadingType = LoadingType.linear,
  }) : super(key: key);

  @override
  _AnimatedLoadingBarState createState() => _AnimatedLoadingBarState();
}

class _AnimatedLoadingBarState extends State<AnimatedLoadingBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rotationController;
  late Animation<Color?> _animation;

  late Animation<double> _animationGradient;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _rotationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )
    ;
    // ..repeat(reverse: false);

    _animation = TweenSequence<Color?>(
      widget.colors.asMap().entries.map((entry) {
        int idx = entry.key;
        Color color = entry.value;
        Color nextColor = widget.colors[(idx + 1) % widget.colors.length];
        return TweenSequenceItem(
          tween: ColorTween(begin: color, end: nextColor),
          weight: 1,
        );
      }).toList(),
    ).animate(_controller)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Start rotation animation after progress is complete
        _rotationController.repeat();
      }
    });;


  //  _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_rotationController);

    _animationGradient =
        Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward().whenComplete((){
     // _rotationController.forward();
    });


  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Calculate smooth stops for a balanced distribution of colors
        final stops = [
          for (var i = 0; i < widget.colors.length; i++) i / (widget.colors.length - 1)
        ];
        return widget.loadingType == LoadingType.circular
            ? RotationTransition(turns: _rotationController,
        child: GradientCircularProgressIndicator(
            radius: 30.0,
            strokeWidth: 8.0,
            value: _animationGradient.value, // Progress value (0.0 to 1.0)
            gradient: SweepGradient(
              colors: widget.colors, // Duplicate first color for seamless transition
              stops: stops,
              //stops: [0.0, 0.33, 0.55, 0.66, 1.0],
            )),)
            : LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                color: _animation.value,
                minHeight: widget.height,
              );
      },
    );
  }
}

// GradientCircularProgressIndicator(
// radius: 100.0,
// strokeWidth: 10.0,
// value: 1.1, // Progress value (0.0 to 1.0)
// gradient: SweepGradient(
// colors: widget.colors, // Duplicate first color for seamless transition
// stops: [0.0, 0.33,
// 0.66,
// 1.0
// ],
// ));

// AnimatedBuilder(
// animation: _animation,

/*  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }*/

class GradientCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final double strokeWidth;
  final double value;
  final SweepGradient gradient;

  const GradientCircularProgressIndicator({
    required this.radius,
    required this.strokeWidth,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius * 2),
      painter: _GradientCircularProgressPainter(
        radius: radius,
        strokeWidth: strokeWidth,
        value: value,
        gradient: gradient,
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final double value;
  final SweepGradient gradient;

  _GradientCircularProgressPainter({
    required this.radius,
    required this.strokeWidth,
    required this.value,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(radius, radius), radius, backgroundPaint);

    // Draw progress circle with gradient
    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final sweepAngle = 2 * 3.1416 * value;
    canvas.drawArc(rect, -3.1416 / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

enum LoadingType { linear, circular }

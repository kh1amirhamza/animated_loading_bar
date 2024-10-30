import 'package:flutter/material.dart';
import 'package:animated_loading_bar/animated_loading_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Animated Loading Bar Example'),
        ),
        body: const Center(
          child: AnimatedLoadingBar(
            // colors: [Colors.red, Colors.blue, Colors.green, Colors.purple,],
            colors: [
              Colors.red,
              Colors.green,
              Colors.yellow,
              Colors.blue,
              Colors.red
            ],
            height: 10.0,
            duration: Duration(seconds: 2),
            loadingType: LoadingType.circular,
          ),
        ),
      ),
    );
  }
}

class GradientCircularProgressIndicator extends StatelessWidget {
  final double radius;
  final double strokeWidth;
  final double value;
  final SweepGradient gradient;

  const GradientCircularProgressIndicator({
    super.key,
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
    final sweepAngle = 2 * 3.14 * value;
    canvas.drawArc(rect, -3.14 / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

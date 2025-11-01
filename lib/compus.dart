import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;

class CompassCircleTracker extends StatefulWidget {
  const CompassCircleTracker({super.key});

  @override
  State<CompassCircleTracker> createState() => _CompassCircleTrackerState();
}

class _CompassCircleTrackerState extends State<CompassCircleTracker> {
  double? _initialHeading;
  double? _previousHeading;
  double _rotationAccumulated = 0;
  int _circleCount = 0;
  bool _isCalibrating = false;
  double _progress = 0; // 0–100%

  @override
  void initState() {
    super.initState();
    FlutterCompass.events?.listen(_onCompassUpdate);
  }

  void _onCompassUpdate(CompassEvent event) {
    final newHeading = event.heading ?? 0.0;

    // Initialize once
    _initialHeading ??= newHeading;
    _previousHeading ??= newHeading;

    double delta = newHeading - _previousHeading!;

    // Normalize wrap-around
    if (delta > 180) delta -= 360;
    if (delta < -180) delta += 360;

    // 🚨 Detect unstable jumps → show calibration dialog
    if (delta.abs() > 45 && !_isCalibrating) {
      _showCalibrationDialog();
      return;
    }

    _rotationAccumulated += delta;
    _previousHeading = newHeading;

    // 🔄 Counterclockwise progress tracking
    // CCW rotation = negative delta, so use abs value for percentage
    double absProgress = (_rotationAccumulated.abs() % 360) / 360;
    _progress = (absProgress * 100).clamp(0, 100);

    // 🎯 Completed full CCW rotation
    if (_rotationAccumulated <= -360) {
      _rotationAccumulated = 0;
      _progress = 0;
      _circleCount++;

      Fluttertoast.showToast(msg: "🧭 Counterclockwise circle $_circleCount complete!", gravity: ToastGravity.BOTTOM, toastLength: Toast.LENGTH_SHORT);
    }

    setState(() {});
  }

  void _showCalibrationDialog() {
    _isCalibrating = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Calibrate Compass"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [const Text("Move your phone in a figure-8 motion to improve accuracy.", textAlign: TextAlign.center), const SizedBox(height: 20), const SizedBox(width: 120, height: 120, child: _FigureEightAnimation())],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _isCalibrating = false;
                _rotationAccumulated = 0;
                _progress = 0;
              },
              child: const Text("Done"),
            ),
          ],
        );
      },
    );

    // Auto close after 5 sec
    Future.delayed(const Duration(seconds: 5), () {
      if (Navigator.canPop(context)) Navigator.pop(context);
      _isCalibrating = false;
      _rotationAccumulated = 0;
      _progress = 0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Compass Progress Tracker")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Initial: ${_initialHeading?.toStringAsFixed(2) ?? '-'}°"),
            Text("Current: ${_previousHeading?.toStringAsFixed(2) ?? '-'}°"),
            Text("Circles: $_circleCount"),
            const SizedBox(height: 40),

            // 🟢 Circular progress indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: 150, height: 150, child: CircularProgressIndicator(value: _progress / 100, strokeWidth: 10, backgroundColor: Colors.grey.shade300)),
                Text("${_progress.toStringAsFixed(0)}%", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),

            const SizedBox(height: 40),
            const Text("Rotate counterclockwise to complete one circle"),
          ],
        ),
      ),
    );
  }
}

class _FigureEightAnimation extends StatefulWidget {
  const _FigureEightAnimation();

  @override
  State<_FigureEightAnimation> createState() => _FigureEightAnimationState();
}

class _FigureEightAnimationState extends State<_FigureEightAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        double t = _controller.value * 2 * math.pi;
        double x = 40 * math.sin(t);
        double y = 20 * math.sin(2 * t);
        return CustomPaint(painter: _PhonePainter(x: x, y: y));
      },
    );
  }
}

class _PhonePainter extends CustomPainter {
  final double x, y;
  _PhonePainter({required this.x, required this.y});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2 + x, size.height / 2 + y);
    final paint = Paint()..color = Colors.blue;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: 25, height: 50), const Radius.circular(6)), paint);
  }

  @override
  bool shouldRepaint(covariant _PhonePainter oldDelegate) => oldDelegate.x != x || oldDelegate.y != y;
}

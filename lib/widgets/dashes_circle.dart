part of '../view/nav/home/umra/tawaf_tracker.dart';

class DashedCirclePainter extends CustomPainter {
  DashedCirclePainter({required this.primaryColor, required this.gradientRadiusFactor});

  final double gradientRadiusFactor;
  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final List<Color> colors = [primaryColor, primaryColor, CColors.tackingRadiusColor, CColors.tackingSecondaryRadiusColor];
    final List<double> stops = [0.0, gradientRadiusFactor, gradientRadiusFactor, 1.0];
    canvas.translate(center.dx, center.dy);
    canvas.scale(-1, 1);
    canvas.translate(-center.dx, -center.dy);

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..shader = SweepGradient(colors: colors, stops: stops, startAngle: 0, endAngle: 2 * pi).createShader(rect);
    const double dashAngle = pi / 120;
    const double gapAngle = pi / 100;
    double startAngle = 0;

    while (startAngle < 2 * pi) {
      final double sweep = min(dashAngle, 2 * pi - startAngle);
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

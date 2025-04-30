import 'dart:math';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/helper/constants.dart';
import '../../utils/services/translations/locale_keys.g.dart';
import '../../utils/theme/colors.dart';
import '../../utils/theme/text_style.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/card.dart';
import '../../widgets/custom_image.dart';

class StartTawafPage extends ConsumerWidget {
  const StartTawafPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Background(
      showEmblem: false,
      showBottomNav: true,
      backgroundType: BackgroundType.logo,
      logoAlign: MainAxisAlignment.center,
      child: Column(
        children: [
          CButton(
            shadows: [],
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImage(path: 'assets/svg/play.svg', imageType: ImageType.svg, height: 16),
                Padding(padding: const EdgeInsets.only(left: 8), child: Text('Start Tawaf', style: CTextStyle.w500(fontSize: 12, color: Colors.white))),
              ],
            ),
            onTap: () {},
          ),
          Expanded(child: Center(child: CustomPaint(size: Size(200, 200), painter: DashedCirclePainter(primaryColor: CColors.primary, gradientRadiusFactor: 0.9)))),
          Text(LocaleKeys.dua_during_2nd_round.tr(), style: CTextStyle.w600(fontSize: 20, color: CColors.deepTeal)),
          BasicCard(
            margin: EdgeInsets.only(top: 16, bottom: 25),
            backgroundColor: CColors.duaBackground.withValues(alpha: 0.2),
            child: Text(
              'لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكُ، لَا شَرِيكَ لَكَ',
              style: CTextStyle.w500(fontSize: 20, color: CColors.deepTeal),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  DashedCirclePainter({required this.primaryColor, required this.gradientRadiusFactor});

  final double gradientRadiusFactor;
  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final List<Color> colors = [primaryColor, primaryColor, CColors.grey.withValues(alpha: 0.8), CColors.greyShade1.withValues(alpha: 0.4)];
    final List<double> stops = [0.0, gradientRadiusFactor, gradientRadiusFactor, 1.0];
    canvas.translate(center.dx, center.dy);
    canvas.scale(-1, 1);
    canvas.translate(-center.dx, -center.dy);

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20
          ..shader = SweepGradient(colors: colors, stops: stops, startAngle: 0, endAngle: 2 * pi).createShader(rect);
    const double dashAngle = pi / 90;
    const double gapAngle = pi / 60;
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

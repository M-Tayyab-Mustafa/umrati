import '../export.dart';

class PinInput extends StatelessWidget {
  const PinInput({super.key, required this.controller, this.margin});
  final TextEditingController controller;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? ScaledEdgeInsets.zero,
      child: Pinput(
        length: 6,
        defaultPinTheme: PinTheme(
          margin: ScaledEdgeInsets.only(right: 6),
          height: 50.pr,
          width: 50.pr,
          decoration: BoxDecoration(border: Border.all(color: CColors.primary, width: 2.pr), borderRadius: BorderRadius.circular(15.pr), boxShadow: primaryShadows.map((e) => e.copyWith(color: e.color.withValues(alpha: 0.2))).toList()),
          textStyle: CTextStyle.w500(fontSize: 14),
        ),
        showCursor: true,
        keyboardType: TextInputType.number,
        controller: controller,
      ),
    );
  }
}

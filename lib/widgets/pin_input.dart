import '../export.dart';

class PinInput extends StatelessWidget {
  const PinInput({super.key, required this.controller, this.margin});
  final TextEditingController controller;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Pinput(
        crossAxisAlignment: CrossAxisAlignment.start,
        length: 6,
        defaultPinTheme: PinTheme(
          margin: context.edgeInsets(right: 6),
          height: context.r(50),
          width: context.r(50),
          decoration: BoxDecoration(
            border: Border.all(color: CColors.primary, width: context.w(2)),
            borderRadius: BorderRadius.circular(context.r(10)),
            boxShadow: primaryShadows.map((e) => e.copyWith(color: e.color.withValues(alpha: 0.2))).toList(),
          ),
          textStyle: CTextStyle.w500(fontSize: 14),
        ),
        showCursor: true,
        keyboardType: TextInputType.number,
        controller: controller,
      ),
    );
  }
}

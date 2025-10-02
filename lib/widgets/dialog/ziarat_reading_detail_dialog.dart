import '../../export.dart';

class ZiaratReadingDetailDialog extends StatefulWidget {
  const ZiaratReadingDetailDialog({super.key, required this.ziarat});
  final ZiaratModel ziarat;

  @override
  State<ZiaratReadingDetailDialog> createState() => _ZiaratReadingDetailDialogState();
}

class _ZiaratReadingDetailDialogState extends State<ZiaratReadingDetailDialog> {
  double fontSize = SizeConfig.sp(10);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.r(8))),
      title: Row(
        children: [
          if (isLTR(context)) const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(color: CColors.charcoalBlack, shape: BoxShape.circle),
              padding: SizeConfig.all(4),
              child: Icon(Icons.close_rounded, color: Colors.white, size: SizeConfig.w(18)),
            ),
          ),
          if (!isLTR(context)) const Spacer(),
        ],
      ),
      contentPadding: SizeConfig.symmetric(horizontal: 16),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: SizeConfig.w(SizeConfig.screenHeight * 0.7)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: isLTR(context) ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: SizeConfig.only(bottom: 8),
                child: Text(isLTR(context) ? widget.ziarat.title_en : widget.ziarat.title_ur, style: CTextStyle.w500(fontSize: fontSize + 6), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ),
            ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(CColors.primary), // your color
                trackColor: WidgetStateProperty.all(Colors.transparent), // optional
                trackBorderColor: WidgetStateProperty.all(Colors.transparent), // optional
              ),
              child: Scrollbar(
                interactive: true,
                trackVisibility: true,
                thumbVisibility: true,
                radius: Radius.circular(SizeConfig.r(16)),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: SizeConfig.symmetric(horizontal: 8),
                    child: Text((widget.ziarat.detail ?? LocaleKeys.ziarat_detail_not_found.tr()).trim(), style: CTextStyle.w400(fontSize: fontSize)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: SizeConfig.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.text_decrease, size: SizeConfig.w(20)),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(trackHeight: SizeConfig.w(1), thumbShape: RoundSliderThumbShape(enabledThumbRadius: SizeConfig.r(6))),
                    child: Slider(
                      value: fontSize,
                      min: SizeConfig.sp(10),
                      max: SizeConfig.sp(20),
                      onChanged: increaseSize,
                      thumbColor: CColors.primary,
                      activeColor: CColors.charcoalBlack,
                      inactiveColor: CColors.charcoalBlack,
                    ),
                  ),
                  Icon(Icons.text_increase, size: SizeConfig.w(24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  increaseSize(double size) {
    fontSize = size;
    setState(() {});
  }
}

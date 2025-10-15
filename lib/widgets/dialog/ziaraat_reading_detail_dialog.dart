import '../../export.dart';

class ZiaraatReadingDetailDialog extends StatefulWidget {
  const ZiaraatReadingDetailDialog({super.key, required this.ziaraat});
  final ZiaraatModel ziaraat;

  @override
  State<ZiaraatReadingDetailDialog> createState() => _ZiaraatReadingDetailDialogState();
}

class _ZiaraatReadingDetailDialogState extends State<ZiaraatReadingDetailDialog> {
  double fontSize = SizeConfig.sp(10);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SizeConfig.r(8))),
      title: Row(
        children: [
          if (!isLTR(context)) const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(color: CColors.charcoalBlack, shape: BoxShape.circle),
              padding: SizeConfig.all(4),
              child: Icon(Icons.close_rounded, color: Colors.white, size: SizeConfig.w(18)),
            ),
          ),
          if (isLTR(context)) const Spacer(),
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
                child: Text(isLTR(context) ? widget.ziaraat.title_en : widget.ziaraat.title_ur, style: CTextStyle.w500(fontSize: fontSize + 6), maxLines: 2, overflow: TextOverflow.ellipsis),
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
                    child: Text(
                      (isLTR(context)
                              ? widget.ziaraat.detail_en.isEmpty
                                  ? LocaleKeys.ziaraat_detail_not_found.tr()
                                  : widget.ziaraat.detail_en
                              : widget.ziaraat.detail_ur.isEmpty
                              ? LocaleKeys.ziaraat_detail_not_found.tr()
                              : widget.ziaraat.detail_ur)
                          .trim(),
                      style: CTextStyle.w400(fontSize: fontSize),
                    ),
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

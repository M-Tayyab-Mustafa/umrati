import '../../export.dart';

class ZiaraatReadingDetailDialog extends StatefulWidget {
  const ZiaraatReadingDetailDialog({super.key, required this.ziaraat});
  final ZiaraatModel ziaraat;

  @override
  State<ZiaraatReadingDetailDialog> createState() => _ZiaraatReadingDetailDialogState();
}

class _ZiaraatReadingDetailDialogState extends State<ZiaraatReadingDetailDialog> {
  double fontSize = 10.sp;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.pr)),
      title: Row(
        children: [
          if (!isLTR(context)) const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(decoration: BoxDecoration(color: CColors.charcoalBlack, shape: BoxShape.circle), padding: ScaledEdgeInsets.all(4), child: Icon(Icons.close_rounded, color: Colors.white, size: 18.pr)),
          ),
          if (isLTR(context)) const Spacer(),
        ],
      ),
      contentPadding: ScaledEdgeInsets.symmetric(horizontal: 16),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 500.pr),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: isLTR(context) ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(padding: ScaledEdgeInsets.only(bottom: 8), child: Text(isLTR(context) ? widget.ziaraat.title_en : widget.ziaraat.title_ur, style: CTextStyle.w500(fontSize: fontSize + 6), maxLines: 2, overflow: TextOverflow.ellipsis)),
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
                radius: Radius.circular(16.pr),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: ScaledEdgeInsets.symmetric(horizontal: 8),
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
              padding: ScaledEdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.text_decrease, size: 20.pr),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(trackHeight: 1.pr, thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.pr)),
                      child: Slider(value: fontSize, min: 10.sp, max: 20.sp, onChanged: increaseSize, thumbColor: CColors.primary, activeColor: CColors.charcoalBlack, inactiveColor: CColors.charcoalBlack),
                    ),
                  ),
                  Icon(Icons.text_increase, size: 24.pr),
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

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(8))),
      title: Align(
        alignment: isLTR(context) ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(decoration: BoxDecoration(color: CColors.charcoalBlack, shape: BoxShape.circle), padding: context.edgeInsets(all: 4), child: Icon(Icons.close_rounded, color: Colors.white, size: context.r(12))),
        ),
      ),
      contentPadding: context.edgeInsets(horizontal: 16),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: context.h(300)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: isLTR(context) ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(padding: context.edgeInsets(bottom: 8), child: Text(isLTR(context) ? widget.ziaraat.title_en : widget.ziaraat.title_ur, style: CTextStyle.w500(fontSize: fontSize + 6), maxLines: 2, overflow: TextOverflow.ellipsis)),
            ),
            Expanded(
              child: ScrollbarTheme(
                data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(CColors.primary), trackColor: WidgetStateProperty.all(Colors.transparent), trackBorderColor: WidgetStateProperty.all(Colors.transparent)),
                child: Scrollbar(
                  interactive: true,
                  trackVisibility: true,
                  thumbVisibility: true,
                  radius: Radius.circular(context.r(16)),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: context.edgeInsets(horizontal: 8),
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
            ),
            Padding(
              padding: context.edgeInsets(horizontal: 16, vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.text_decrease, size: context.r(20)),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(trackHeight: context.h(1), thumbShape: RoundSliderThumbShape(enabledThumbRadius: context.r(6))),
                      child: Slider(value: fontSize, min: 10.sp, max: 20.sp, onChanged: increaseSize, thumbColor: CColors.primary, activeColor: CColors.charcoalBlack, inactiveColor: CColors.charcoalBlack),
                    ),
                  ),
                  Icon(Icons.text_increase, size: context.r(24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void increaseSize(double size) {
    fontSize = size;
    setState(() {});
  }
}

import '../../export.dart';

class ZiaratReadingDetailDialog extends StatefulWidget {
  const ZiaratReadingDetailDialog({super.key, required this.ziarat});
  final ZiaratModel ziarat;

  @override
  State<ZiaratReadingDetailDialog> createState() => _ZiaratReadingDetailDialogState();
}

class _ZiaratReadingDetailDialogState extends State<ZiaratReadingDetailDialog> {
  double fontSize = 14;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        children: [
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(color: CColors.charcoalBlack, shape: BoxShape.circle),
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.close_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      content: SizedBox(
        height: screenSize.height * 0.4,
        width: screenSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                languageDirection(context) == TextDirection.ltr ? widget.ziarat.title_en : widget.ziarat.title_ur,
                style: CTextStyle.w500(fontSize: 24),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Center(
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(CColors.primary), // your color
                    trackColor: WidgetStateProperty.all(Colors.transparent), // optional
                    trackBorderColor: WidgetStateProperty.all(Colors.transparent), // optional
                  ),
                  child: Scrollbar(
                    interactive: true,
                    trackVisibility: true,
                    thumbVisibility: true,
                    radius: const Radius.circular(16),

                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SingleChildScrollView(child: Text((widget.ziarat.detail ?? LocaleKeys.ziarat_detail_not_found.tr()).trim(), style: CTextStyle.w400(fontSize: fontSize))),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.text_decrease, size: 20),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(trackHeight: 1, thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6)),
                      child: Slider(value: fontSize, min: 10, max: 22, onChanged: increaseSize, thumbColor: CColors.primary, activeColor: CColors.charcoalBlack, inactiveColor: CColors.charcoalBlack),
                    ),
                    Icon(Icons.text_increase, size: 24),
                  ],
                ),
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

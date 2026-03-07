import '../export.dart';

class HistoryMenuCard extends StatelessWidget {
  const HistoryMenuCard({super.key, required this.image, required this.title, required this.description, required this.onTap, this.margin});

  final String image;
  final String title;
  final String description;
  final VoidCallback onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      onTap: onTap,
      margin: margin,
      child: Row(
        children: [
          CustomImage(path: image, imageType: ImageType.png, size: context.r(80), margin: context.edgeInsets(right: 16), fit: BoxFit.fitWidth),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(title, style: CTextStyle.w500(fontSize: 22, color: CColors.deepTeal), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Transform.rotate(
                      angle: isLTR(context) ? 0 : -(pi / 180 * 180),
                      child: CustomImage(margin: context.edgeInsets(left: 16), path: DefaultImages.longArrowForward, imageType: ImageType.svg, width: context.w(30), color: CColors.deepTeal),
                    ),
                  ],
                ),
                Text(description, style: CTextStyle.w500(color: CColors.deepTeal, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.histories, required this.time});
  final List<HistoryModel> histories;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final dateLabel = Helper.isToday(time) ? LocaleKeys.today.tr() : DateFormat('EEEE${isLTR(context) ? ',' : '،'} dd MMMM yyyy', context.locale.languageCode).format(time);

    return Padding(
      padding: context.edgeInsets(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: context.edgeInsets(left: isLTR(context) ? 16 : 0, right: isLTR(context) ? 0 : 16), child: Text(dateLabel, style: CTextStyle.w600(color: CColors.deepTeal, fontSize: 22))),
          ListView.builder(
            padding: context.edgeInsets(vertical: 8),
            itemCount: histories.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _HistoryItem(history: histories[index], index: index),
          ),
          Divider(color: CColors.secondary),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.history, required this.index});
  final HistoryModel history;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Padding(
        padding: context.edgeInsets(right: isLTR(context) ? 64 : 0, left: isLTR(context) ? 0 : 64),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(color: CColors.softMintGreen, shape: BoxShape.circle),
              padding: context.edgeInsets(all: 10),
              margin: context.edgeInsets(right: isLTR(context) ? 12 : 32, left: isLTR(context) ? 32 : 12),
              child: Text('${index + 1}', style: CTextStyle.w600(color: CColors.secondary, fontSize: 16)),
            ),
            _TimeRange(history: history),
          ],
        ),
      ),
    );
  }
}

class _TimeRange extends StatelessWidget {
  const _TimeRange({required this.history});
  final HistoryModel history;

  @override
  Widget build(BuildContext context) {
    final createdStr = DateFormat.jms().format(history.created_at!.toDate());
    final updatedStr = DateFormat.jms().format(history.updated_at!.toDate());

    return Text.rich(
      TextSpan(
        children:
            isLTR(context)
                ? [TextSpan(text: '${LocaleKeys.from.tr()} '), TextSpan(text: createdStr), TextSpan(text: '  ${LocaleKeys.to.tr()} '), TextSpan(text: updatedStr)]
                : [
                  TextSpan(text: LocaleKeys.from.tr()),
                  WidgetSpan(child: Directionality(textDirection: TextDirection.ltr, child: Text('  $updatedStr  ', style: CTextStyle.w400(color: CColors.deepTeal, letterSpacing: -0.2)))),
                  TextSpan(text: LocaleKeys.to.tr()),
                  WidgetSpan(child: Directionality(textDirection: TextDirection.ltr, child: Text('  $createdStr', style: CTextStyle.w400(color: CColors.deepTeal, letterSpacing: -0.2)))),
                ],
      ),
      style: CTextStyle.w400(color: CColors.deepTeal, letterSpacing: -0.2, fontSize: 12),
      textDirection: TextDirection.ltr,
    );
  }
}

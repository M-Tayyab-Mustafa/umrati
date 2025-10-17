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
          CustomImage(path: image, imageType: ImageType.png, size: SizeConfig.w(80), margin: SizeConfig.only(right: 16), fit: BoxFit.fitWidth),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(title, style: CTextStyle.w500(fontSize: 22, color: CColors.deepTeal), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Transform.rotate(
                    angle: isLTR(context) ? 0 : -(pi / 180 * 180),
                    child: CustomImage(margin: SizeConfig.only(left: 16), path: DefaultImages.longArrowForward, imageType: ImageType.svg, width: SizeConfig.w(30), color: CColors.deepTeal),
                  ),
                ],
              ),
              Text(description, style: CTextStyle.w500(color: CColors.deepTeal, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
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
    return Padding(
      padding: SizeConfig.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: SizeConfig.only(left: isLTR(context) ? 16 : 0, right: isLTR(context) ? 0 : 16),
            child: Text(
              (Helper.isToday(time)) ? LocaleKeys.today.tr() : DateFormat('EEEE${isLTR(context) ? ',' : '،'} dd MMMM yyyy', context.locale.languageCode).format(time),
              style: CTextStyle.w600(color: CColors.deepTeal, fontSize: 22),
            ),
          ),
          ListView.builder(
            padding: SizeConfig.symmetric(vertical: 8),
            itemCount: histories.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var history = histories[index];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(color: CColors.softMintGreen, shape: BoxShape.circle),
                    padding: SizeConfig.all(10),
                    margin: SizeConfig.only(right: isLTR(context) ? 12 : 32, left: isLTR(context) ? 32 : 12),
                    child: Text('${index + 1}', style: CTextStyle.w600(color: CColors.secondary, fontSize: 16)),
                  ),
                  Text.rich(
                    TextSpan(
                      children:
                          isLTR(context)
                              ? [
                                TextSpan(text: '${LocaleKeys.from.tr()} '),
                                TextSpan(text: DateFormat.jms().format(history.created_at!.toDate())),
                                TextSpan(text: '  ${LocaleKeys.to.tr()} '),
                                TextSpan(text: DateFormat.jms().format(history.updated_at!.toDate())),
                              ]
                              : [
                                TextSpan(text: LocaleKeys.from.tr()),
                                WidgetSpan(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text('  ${DateFormat.jms().format(history.updated_at!.toDate())}  ', style: CTextStyle.w400(color: CColors.deepTeal, letterSpacing: -0.2)),
                                  ),
                                ),
                                TextSpan(text: LocaleKeys.to.tr()),
                                WidgetSpan(
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text('  ${DateFormat.jms().format(history.created_at!.toDate())}', style: CTextStyle.w400(color: CColors.deepTeal, letterSpacing: -0.2)),
                                  ),
                                ),
                              ],
                    ),
                    style: CTextStyle.w400(color: CColors.deepTeal, letterSpacing: -0.2),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              );
            },
          ),
          Divider(color: CColors.secondary),
        ],
      ),
    );
  }
}

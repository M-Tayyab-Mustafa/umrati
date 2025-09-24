import '../../../../export.dart';

class TawafHistoryPage extends ConsumerWidget {
  const TawafHistoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Background(
      margin: EdgeInsets.only(top: kToolbarHeight / 2, left: 16, right: 16, bottom: kToolbarHeight / 2),
      backgroundType: BackgroundType.titleWithBackButton,
      logoAlign: Alignment.center,
      title: LocaleKeys.tawaf.tr(),
      child: Container(),
    );
  }
}

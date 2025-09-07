import '../../../export.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.center,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, bottom: 60),
      child: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight * 0.5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CListTile(title: 'History', icon: 'assets/svg/settings/history.svg'),
              CListTile(title: 'Ziarat', icon: 'assets/svg/settings/ziarat.svg'),
              CListTile(title: 'Change Language', icon: 'assets/svg/settings/language.svg'),
              CListTile(
                title: 'Dark mode',
                icon: 'assets/svg/settings/theme.svg',
                trailing: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    height: 30,
                    child: FittedBox(
                      child: Switch(
                        value: false,
                        thumbColor: WidgetStatePropertyAll(CColors.deepTeal),
                        overlayColor: WidgetStatePropertyAll(CColors.deepTeal),
                        activeColor: CColors.deepTeal,
                        trackColor: WidgetStatePropertyAll(CColors.primary.withValues(alpha: 0.1)),
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ),
              ),
              CListTile(title: 'Give feedback', icon: 'assets/svg/settings/feed_back.svg'),
              CListTile(
                borderRadius: 25,
                margin: EdgeInsets.only(bottom: 30, top: screenSize.height * 0.11, left: screenSize.width * 0.06, right: screenSize.width * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Buy Premium', style: CTextStyle.w600(fontSize: 20, color: CColors.primary)),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImage(margin: EdgeInsets.only(bottom: 10), path: 'assets/svg/settings/kaba_no_ads.png', height: 50, imageType: ImageType.png, fit: BoxFit.fill),
                                Text('Ads Free Journey', style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImage(margin: EdgeInsets.only(bottom: 10), path: 'assets/svg/settings/more_ziarats.png', height: 50, imageType: ImageType.png, fit: BoxFit.fill),
                                Text('More Ziarat Destinations', style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImage(margin: EdgeInsets.only(bottom: 10), path: 'assets/svg/settings/unlimited_history.png', height: 50, imageType: ImageType.png, fit: BoxFit.fill),
                                Text('Unlimited History', style: CTextStyle.w500(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

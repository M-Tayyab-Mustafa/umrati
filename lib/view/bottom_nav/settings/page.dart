import '../../../export.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    ref.read(settingsProvider.notifier).ref = ref;
    ref.read(settingsProvider.notifier).context = context;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(settingsProvider.notifier).initialization();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(settingsProvider);
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.center,
      margin: ScaledEdgeInsets.only(top: kToolbarHeight * 0.5, bottom: 60),
      child: Padding(
        padding: ScaledEdgeInsets.only(top: kToolbarHeight * 0.5),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CListTile(onTap: provider.onHistoryTap, title: LocaleKeys.history.tr(), icon: 'assets/svg/settings/history.svg'),
                    CListTile(onTap: provider.onChangeTheLanguageTap, title: LocaleKeys.change_the_language.tr(), icon: 'assets/svg/settings/language.svg'),
                    CListTile(
                      onTap: provider.onChangeTheThemeTap,
                      title: LocaleKeys.dark_mode.tr(),
                      icon: 'assets/svg/settings/theme.svg',
                      trailing: Text('(${LocaleKeys.coming_soon.tr()})', style: CTextStyle.w700(color: CColors.secondary, fontSize: 16)),
                    ),
                    CListTile(onTap: provider.onGiveFeedbackTap, title: LocaleKeys.give_feedback.tr(), icon: 'assets/svg/settings/feed_back.svg'),
                  ],
                ),
              ),
            ),
            if (provider.user != null && (provider.user!.subscription_id == null || provider.user!.subscription_id!.isEmpty))
              CListTile(
                onTap: ref.read(settingsProvider.notifier).onBuyPremiumTap,
                borderRadius: 25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(LocaleKeys.buy_premium.tr(), style: CTextStyle.w600(fontSize: 20, color: CColors.primary)),
                    Padding(
                      padding: ScaledEdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImage(margin: ScaledEdgeInsets.only(bottom: 10), path: 'assets/svg/settings/kaba_no_ads.png', height: 50.pr, imageType: ImageType.png, fit: BoxFit.fill),
                                Text(LocaleKeys.ads_free_journey.tr(), style: CTextStyle.w500(fontSize: 14, color: CColors.deepTeal), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.pr),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImage(margin: ScaledEdgeInsets.only(bottom: 10), path: 'assets/svg/settings/more_ziaraats.png', height: 50.pr, imageType: ImageType.png, fit: BoxFit.fill),
                                Text(LocaleKeys.more_ziaraat_destinations.tr(), style: CTextStyle.w500(fontSize: 14, color: CColors.deepTeal), textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.pr),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomImage(margin: ScaledEdgeInsets.only(bottom: 10), path: 'assets/svg/settings/unlimited_history.png', height: 50.pr, imageType: ImageType.png, fit: BoxFit.fill),
                                Text(LocaleKeys.unlimited_history.tr(), style: CTextStyle.w500(fontSize: 14, color: CColors.deepTeal), textAlign: TextAlign.center),
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
    );
  }
}

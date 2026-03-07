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
      margin: context.edgeInsets(top: kToolbarHeight * 0.3),
      child: SingleChildScrollView(
        child: Padding(
          padding: context.edgeInsets(top: 16, bottom: 50),
          child: Column(
            children: [
              CListTile(onTap: provider.onHistoryTap, title: LocaleKeys.history.tr(), icon: 'assets/svg/settings/history.svg'),
              CListTile(onTap: provider.onChangeTheLanguageTap, title: LocaleKeys.change_the_language.tr(), icon: 'assets/svg/settings/language.svg'),
              CListTile(onTap: provider.onChangeTheThemeTap, title: LocaleKeys.dark_mode.tr(), icon: 'assets/svg/settings/theme.svg', trailing: Text('(${LocaleKeys.coming_soon.tr()})', style: CTextStyle.w700(color: CColors.secondary, fontSize: 16))),
              CListTile(onTap: provider.onGiveFeedbackTap, title: LocaleKeys.give_feedback.tr(), icon: 'assets/svg/settings/feed_back.svg'),
              CListTile(onTap: provider.onTermsAndConditionsTap, title: LocaleKeys.privacy_policy.tr(), icon: 'assets/svg/settings/policy.svg'),
              // if ((provider.user != null && (provider.user!.subscription_id == null || provider.user!.subscription_id!.isEmpty)) && !Platform.isIOS)
              _BuyPremiumCard(onTap: ref.read(settingsProvider.notifier).onBuyPremiumTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuyPremiumCard extends StatelessWidget {
  const _BuyPremiumCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CListTile(
      margin: context.edgeInsets(top: 24, horizontal: 16, bottom: 16),
      onTap: onTap,
      borderRadius: 25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(LocaleKeys.buy_premium.tr(), style: CTextStyle.w600(fontSize: 20, color: CColors.primary)),
          Padding(
            padding: context.edgeInsets(top: 15),
            child: Row(
              children: [
                Expanded(child: _PremiumFeatureItem(image: 'assets/svg/settings/kaba_no_ads.png', label: LocaleKeys.ads_free_journey.tr())),
                SizedBox(width: context.w(8)),
                Expanded(child: _PremiumFeatureItem(image: 'assets/svg/settings/more_ziaraats.png', label: LocaleKeys.more_ziaraat_destinations.tr())),
                SizedBox(width: context.w(8)),
                Expanded(child: _PremiumFeatureItem(image: 'assets/svg/settings/unlimited_history.png', label: LocaleKeys.unlimited_history.tr())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumFeatureItem extends StatelessWidget {
  const _PremiumFeatureItem({required this.image, required this.label});
  final String image;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomImage(margin: context.edgeInsets(bottom: 10), path: image, height: context.h(50), imageType: ImageType.png, fit: BoxFit.fill),
        Text(label, style: CTextStyle.w500(fontSize: 14, color: CColors.deepTeal), textAlign: TextAlign.center),
      ],
    );
  }
}

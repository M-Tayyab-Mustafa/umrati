import '../../../controller/bottom_nav/home/provider.dart';
import '../../../export.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(homeProvider.notifier).ref = ref;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.center,
      margin: ScaledEdgeInsets.only(top: kToolbarHeight * 0.5, bottom: 50, left: 16, right: 16),
      child: Column(
        children: [
          FutureBuilder(
            future: LocalStorageManager.getUser(),
            builder: (context, asyncSnapshot) {
              if (!asyncSnapshot.hasData) return SizedBox.shrink();
              return _Card(
                onTap: () => ref.read(homeProvider).onUmrahTap(context),
                title: LocaleKeys.umrah.tr(),
                description: LocaleKeys.start_your_umrah_from_here.tr(),
                image: asyncSnapshot.data?.gender == Gender.female.name ? 'assets/png/abaya.png' : 'assets/png/home/umrah.png',
              );
            },
          ),
          _Card(onTap: () => ref.read(homeProvider).onTawafTap(context), title: LocaleKeys.tawaf.tr(), description: LocaleKeys.start_your_tawaf_from_here.tr(), image: 'assets/png/home/tawaf.png'),
          _Card(onTap: () => ref.read(homeProvider).onZiaraatTap(context), title: LocaleKeys.ziaraat.tr(), description: LocaleKeys.start_your_ziaraat_from_here.tr(), image: 'assets/png/home/ziaraat.png'),
        ],
      ),
    );
  }
}

class _Card extends ConsumerWidget {
  const _Card({required this.onTap, required this.title, required this.description, required this.image});
  final VoidCallback onTap;
  final String title;
  final String description;
  final String image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasicCard(
      onTap: onTap,
      margin: ScaledEdgeInsets.symmetric(vertical: 18),
      padding: ScaledEdgeInsets.only(top: 16, bottom: 16, right: 16),
      height: 140.pr,
      borderColor: CColors.grey,
      boxShadow: greyShadows,
      child: Row(
        children: [
          CustomImage(height: 120.pr, width: 100.pr, path: image, fit: BoxFit.fill, imageType: ImageType.png),
          Expanded(
            child: Padding(
              padding: ScaledEdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: CTextStyle.w600(fontSize: 22, color: CColors.deepTeal), maxLines: 1),
                      Padding(
                        padding: ScaledEdgeInsets.only(left: isLTR(context) ? 8 : 0, right: isLTR(context) ? 0 : 8),
                        child: Transform.rotate(angle: isLTR(context) ? 0 : pi / 180 * 180, child: CustomImage(path: DefaultImages.longArrowForward, size: 25.pr, color: CColors.deepTeal, imageType: ImageType.svg)),
                      ),
                    ],
                  ),
                  Text(description, style: CTextStyle.w600(color: CColors.deepTeal, fontSize: 14), maxLines: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

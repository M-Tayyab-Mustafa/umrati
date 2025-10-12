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
    ref.read(homeProvider.notifier).context = context;
    ref.read(homeProvider.notifier).ref = ref;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.empty,
      margin: SizeConfig.only(top: kToolbarHeight * 0.5, bottom: 50),
      child: Column(
        children: [
          _Card(onTap: ref.read(homeProvider).onUmraTap, title: LocaleKeys.umra.tr(), description: LocaleKeys.start_your_umrah_from_here.tr(), image: 'assets/png/home/umrah.png'),
          _Card(onTap: ref.read(homeProvider).onTawafTap, title: LocaleKeys.tawaf.tr(), description: LocaleKeys.start_your_tawaf_from_here.tr(), image: 'assets/png/home/tawaf.png'),
          _Card(onTap: ref.read(homeProvider).onZiaratTap, title: LocaleKeys.ziarat.tr(), description: LocaleKeys.start_your_ziaraat_from_here.tr(), image: 'assets/png/home/ziarat.png'),
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
      margin: SizeConfig.symmetric(horizontal: 16, vertical: 18),
      padding: SizeConfig.only(top: 16, bottom: 16, right: 16),
      height: SizeConfig.h(170),
      borderColor: CColors.grey,
      boxShadow: greyShadows,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: LayoutBuilder(
              builder:
                  (context, constraints) =>
                      CustomImage(width: SizeConfig.w(constraints.maxWidth), height: SizeConfig.h(constraints.maxHeight * 0.65), path: image, fit: BoxFit.fill, imageType: ImageType.png),
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: SizeConfig.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: CTextStyle.w600(fontSize: 22, color: CColors.deepTeal), maxLines: 1),
                      Padding(
                        padding: SizeConfig.only(left: isLTR(context) ? 8 : 0, right: isLTR(context) ? 0 : 8),
                        child: Transform.rotate(
                          angle: isLTR(context) ? 0 : pi / 180 * 180,
                          child: CustomImage(path: DefaultImages.longArrowForward, size: SizeConfig.w(25), color: CColors.deepTeal, imageType: ImageType.svg),
                        ),
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

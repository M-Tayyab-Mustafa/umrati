import '../../../controller/nav/home/provider.dart';
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
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06, bottom: 85),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Card(
                maxHeight: constraints.maxHeight * 0.25,
                onTap: ref.read(homeProvider).onUmraTap,
                title: LocaleKeys.umra.tr(),
                description: LocaleKeys.start_your_umra_from_here.tr(),
                image: 'assets/png/home/umrah.png',
              ),
              _Card(
                maxHeight: constraints.maxHeight * 0.25,
                onTap: ref.read(homeProvider).onTawafTap,
                title: LocaleKeys.tawaf.tr(),
                description: LocaleKeys.start_your_tawaf_from_here.tr(),
                image: 'assets/png/home/tawaf.png',
              ),
              _Card(
                maxHeight: constraints.maxHeight * 0.25,
                onTap: ref.read(homeProvider).onZiaratTap,
                title: LocaleKeys.ziarat.tr(),
                description: LocaleKeys.start_your_ziarat_from_here.tr(),
                image: 'assets/png/home/ziarat.png',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Card extends ConsumerWidget {
  const _Card({required this.maxHeight, required this.onTap, required this.title, required this.description, required this.image});
  final double maxHeight;
  final VoidCallback onTap;
  final String title;
  final String description;
  final String image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BasicCard(
      onTap: onTap,
      padding: EdgeInsets.only(top: 16, bottom: 16, right: 16),
      height: maxHeight,
      borderColor: CColors.grey,
      boxShadow: greyShadows,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: LayoutBuilder(builder: (context, constraints) => CustomImage(width: constraints.maxWidth, height: constraints.maxHeight, path: image, fit: BoxFit.fill, imageType: ImageType.png)),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: CTextStyle.w600(fontSize: 26, color: CColors.deepTeal), maxLines: 1),
                      Padding(padding: EdgeInsets.only(left: isLTR(context) ? 16 : 0, right: isLTR(context) ? 0 : 16), child: Icon(Icons.arrow_forward_rounded, size: 26, color: CColors.deepTeal)),
                    ],
                  ),
                  Text(description, style: CTextStyle.w600(color: CColors.deepTeal), maxLines: 2, textScaler: TextScaler.linear(0.85)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

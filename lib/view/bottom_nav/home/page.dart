import '../../../controller/bottom_nav/home/provider.dart';
import '../../../export.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  UserModel? _cachedUser;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _cachedUser = await LocalStorageManager.getUser();
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.center,
      logoMargin: context.edgeInsets(bottom: 16),
      margin: context.edgeInsets(top: 16, bottom: 50, left: 16, right: 16),
      child: Column(
        children: [
          if (_cachedUser != null)
            _HomeCard(
              onTap: () => ref.read(homeProvider).onUmrahTap(context),
              title: LocaleKeys.umrah.tr(),
              description: LocaleKeys.start_your_umrah_from_here.tr(),
              image: _cachedUser!.gender == Gender.female.name ? 'assets/png/abaya.png' : 'assets/png/home/umrah.png',
            ),
          _HomeCard(onTap: () => ref.read(homeProvider).onTawafTap(context), title: LocaleKeys.tawaf.tr(), description: LocaleKeys.start_your_tawaf_from_here.tr(), image: 'assets/png/home/tawaf.png'),
          _HomeCard(onTap: () => ref.read(homeProvider).onZiaraatTap(context), title: LocaleKeys.ziaraat.tr(), description: LocaleKeys.start_your_ziaraat_from_here.tr(), image: 'assets/png/home/ziaraat.png'),
        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({required this.onTap, required this.title, required this.description, required this.image});

  final VoidCallback onTap;
  final String title;
  final String description;
  final String image;

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      onTap: onTap,
      margin: context.edgeInsets(vertical: 16),
      padding: context.edgeInsets(top: 16, bottom: 16, right: 16),
      height: context.h(120),
      borderColor: CColors.grey,
      boxShadow: greyShadows,
      child: Row(
        children: [
          CustomImage(height: context.h(120), width: context.w(100), path: image, fit: BoxFit.fill, imageType: ImageType.png),
          Expanded(
            child: Padding(
              padding: context.edgeInsets(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: CTextStyle.w600(fontSize: 22, color: CColors.deepTeal), maxLines: 1),
                      Padding(
                        padding: context.edgeInsets(left: isLTR(context) ? 8 : 0, right: isLTR(context) ? 0 : 8),
                        child: Transform.rotate(angle: isLTR(context) ? 0 : pi / 180 * 180, child: CustomImage(path: DefaultImages.longArrowForward, size: context.r(25), color: CColors.deepTeal, imageType: ImageType.svg)),
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

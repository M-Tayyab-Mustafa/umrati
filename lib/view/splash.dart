import '../export.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    ref.read(splashProvider.notifier).ref = ref;
    ref.read(splashProvider.notifier).initialization(context);
  }

  @override
  Widget build(BuildContext context) {
    return Background(showEmblem: false, child: Center(child: CustomImage(path: 'assets/svg/logo.svg', imageType: ImageType.svg, size: context.r(200), fit: BoxFit.fitWidth)));
  }
}

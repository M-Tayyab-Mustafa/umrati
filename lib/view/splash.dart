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
    ref.read(splashProvider.notifier).initialization(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [CColors.lightGrey.withValues(alpha: 0.20), CColors.primary.withValues(alpha: 0.20), CColors.primary.withValues(alpha: 0.15)])),
        child: CustomImage(path: 'assets/svg/logo.svg', imageType: ImageType.svg),
      ),
    );
  }
}

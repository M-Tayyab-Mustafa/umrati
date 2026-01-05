import 'export.dart';
import 'view/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageManager.initialization();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Payment.instance.initializePayments();
  runApp(ProviderScope(child: EasyLocalization(supportedLocales: const [Locale('en', 'US'), Locale('ur', 'PK')], path: 'assets/translations', fallbackLocale: Locale('en', 'US'), saveLocale: true, assetLoader: CodegenLoader(), child: MainApp())));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    Payment.instance.paymentSettingSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CTextStyle.context = context;
    return ScreenUtilPlusInit(
      designSize: const Size(360, 690),
      child: MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling), child: child!);
        },
        home: SplashPage(),
        color: CColors.primary,
      ),
    );
  }
}

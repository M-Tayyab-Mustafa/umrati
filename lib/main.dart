import 'dart:async' show FutureOr;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'utils/services/local_storage.dart';
import 'utils/services/translations/codegen_loader.g.dart';
import 'utils/theme/colors.dart';
import 'view/splash.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageManager.initialization();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('ur', 'PK')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        saveLocale: true,
        assetLoader: CodegenLoader(),
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      color: CColors.primary,
    );
  }
}

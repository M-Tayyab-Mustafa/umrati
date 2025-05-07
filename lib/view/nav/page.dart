import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/utils/helper/constants.dart';

import '../../controller/nav/provider.dart';
import '../../controller/nav/umera/tawaf_provider.dart';
import '../../widgets/background.dart';
import '../../widgets/bottom_nav.dart';

class BottomNavigationPage extends ConsumerWidget {
  const BottomNavigationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: MainAxisAlignment.center,
      margin:
          (ref.watch(bottomNavProvider).selectedTab == BottomNavTabs.umera && ref.watch(tawafProvider).circleCount != 7 ? null : EdgeInsets.only(top: kToolbarHeight, left: 30, right: 30)) ??
          EdgeInsets.only(top: kToolbarHeight, left: 30, right: 30),
      child: BottomNav(selectedTab: ref.watch(bottomNavProvider).selectedTab, onBottomNavTap: ref.read(bottomNavProvider).onBottomNavTap, child: ref.watch(bottomNavProvider).child),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:umrati/utils/helper/constants.dart';

import '../../controller/nav/provider.dart';
import '../../widgets/background.dart';
import '../../widgets/bottom_nav.dart';

class BottomNavigationPage extends ConsumerWidget {
  const BottomNavigationPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(bottomNavProvider);
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: provider.logoAlign,
      margin: EdgeInsets.only(top: kToolbarHeight, left: 16, right: 16),
      child: BottomNav(selectedTab: provider.selectedTab, onBottomNavTap: provider.onBottomNavTap, child: provider.child),
    );
  }
}

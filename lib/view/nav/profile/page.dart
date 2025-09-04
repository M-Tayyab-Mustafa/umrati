import '../../../controller/nav/profile/profile_provider.dart';
import '../../../export.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Background(
      showEmblem: false,
      backgroundType: BackgroundType.logo,
      logoAlign: Alignment.center,
      margin: EdgeInsets.only(top: kToolbarHeight * 0.5, left: screenSize.width * 0.06, right: screenSize.width * 0.06),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CButton(margin: EdgeInsets.only(bottom: 16), isLoading: ref.watch(profileProvider).isLoading, title: 'Set Safa Marwa Running Start Point', onTap: ref.read(profileProvider).setLocation),
            CButton(margin: EdgeInsets.only(bottom: 16), isLoading: ref.watch(profileProvider).isLoading, title: 'Clear All Points and Restart', onTap: ref.read(profileProvider).clear),
            ListView.builder(
              shrinkWrap: true,
              itemCount: ref.watch(profileProvider).locations.length,
              itemBuilder: (context, index) {
                var location = ref.watch(profileProvider).locations[index];
                return ListTile(leading: Text(location.pointType), title: Text('${location.latitude}, ${location.longitude}'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

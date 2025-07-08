import '../../../controller/nav/profile/profile_provider.dart';
import '../../../export.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CButton(
            margin: EdgeInsets.only(bottom: 16),
            isLoading: ref.watch(profileProvider).isLoading,
            title: 'Set My Location As Center Point',
            onTap: ref.read(profileProvider).setMyLocationToMecca,
          ),
          CButton(isLoading: ref.watch(profileProvider).isLoading, title: 'Set Original Location As Center Point', onTap: ref.read(profileProvider).setOriginalLocation),
        ],
      ),
    );
  }
}

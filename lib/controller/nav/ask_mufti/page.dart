import '../../../export.dart';

class AskMuftiPage extends ConsumerStatefulWidget {
  const AskMuftiPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AskMuftiPageState();
}

class _AskMuftiPageState extends ConsumerState<AskMuftiPage> {
  @override
  Widget build(BuildContext context) {
    return Background(showEmblem: false, child: Container());
  }
}

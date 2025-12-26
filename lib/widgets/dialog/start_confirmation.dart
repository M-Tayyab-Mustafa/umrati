import '../../export.dart';

class StartConfirmationDialog extends StatelessWidget {
  const StartConfirmationDialog({super.key, this.fromUmrah = true});
  final bool fromUmrah;

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: (fromUmrah ? 450 : 400).pr,
              margin: ScaledEdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: fromUmrah ? CColors.secondaryBackground : Colors.white,
                borderRadius: BorderRadius.circular(20.pr),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: ScaledEdgeInsets.only(top: 28, left: 16, right: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(fromUmrah ? LocaleKeys.umrah_start_detail.tr() : LocaleKeys.please_reach_safa_start_point.tr(), style: CTextStyle.w900(fontSize: 20, color: CColors.deepTeal), textAlign: TextAlign.center),
                          Expanded(child: CustomImage(margin: ScaledEdgeInsets.symmetric(vertical: 16), path: fromUmrah ? 'assets/png/home/green_light.png' : 'assets/png/home/safa_marwa.png', imageType: ImageType.png, fit: BoxFit.fitWidth)),
                        ],
                      ),
                    ),
                  ),
                  CButton(
                    margin: ScaledEdgeInsets.only(left: 16, right: 16, bottom: 20),
                    height: 45,
                    title: LocaleKeys.yes_i_have_reached.tr(),
                    onTap: () => Navigator.pop(dialogContext, true),
                    style: CTextStyle.w400(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

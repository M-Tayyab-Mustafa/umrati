import '../../export.dart';

class AlreadyDialog extends StatelessWidget {
  const AlreadyDialog({super.key, required this.isDoingUmrah});
  final bool isDoingUmrah;

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: dialogContext.h(300),
              padding: EdgeInsets.zero,
              margin: dialogContext.edgeInsets(horizontal: 32),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(dialogContext.r(20)),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: dialogContext.r(80), padding: dialogContext.edgeInsets(top: 10)),
                  Expanded(
                    child: Padding(
                      padding: dialogContext.edgeInsets(horizontal: 28),
                      child: Center(child: Text(isDoingUmrah ? LocaleKeys.already_in_umrah.tr() : LocaleKeys.already_in_ziaraats.tr(), style: CTextStyle.w900(fontSize: 16, color: CColors.deepTeal), textAlign: TextAlign.center)),
                    ),
                  ),
                  Padding(
                    padding: dialogContext.edgeInsets(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: dialogContext.edgeInsets(left: isLTR(dialogContext) ? 20 : 16, right: isLTR(dialogContext) ? 16 : 20),
                            child: CButton(
                              backgroundColor: CColors.secondaryBackground,
                              borderColor: CColors.primary,
                              titleColor: CColors.primary,
                              title: LocaleKeys.start_new.tr(),
                              onTap: () => Navigator.pop(dialogContext, false),
                              style: CTextStyle.w400(fontSize: 12, color: CColors.primary),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: dialogContext.edgeInsets(left: isLTR(dialogContext) ? 16 : 20, right: isLTR(dialogContext) ? 20 : 16),
                            child: CButton(title: LocaleKeys.continued.tr(), onTap: () => Navigator.pop(dialogContext, true), style: CTextStyle.w400(fontSize: 12, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
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

import '../../export.dart';

class UmraStartConfirmationDialog extends StatelessWidget {
  const UmraStartConfirmationDialog({super.key});

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: screenSize.width * 0.67,
              padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.0),
              margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
              decoration: BoxDecoration(
                color: CColors.secondaryBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CColors.primary, width: 2),
                boxShadow: primaryShadows.map((e) => e.copyWith(blurRadius: 30)).toList(),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: screenSize.height * 0.05, left: screenSize.width * 0.1, right: screenSize.width * 0.1),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(children: [Text(LocaleKeys.umra_start_detail.tr(), style: CTextStyle.w900(fontSize: 18, color: CColors.deepTeal), textAlign: TextAlign.center)]),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: CButton(
                            margin: const EdgeInsets.only(left: 16, right: 8),
                            height: 45,
                            shadows: [],
                            fontSize: 14,
                            title: LocaleKeys.continued.tr(),
                            onTap: () => Navigator.pop(dialogContext),
                            style: CTextStyle.w400(fontSize: 12, color: Colors.white),
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

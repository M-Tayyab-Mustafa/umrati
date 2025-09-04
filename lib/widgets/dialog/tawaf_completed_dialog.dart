import '../../export.dart';

class TawafCompletionDialog extends StatelessWidget {
  const TawafCompletionDialog({super.key});

  @override
  Widget build(BuildContext dialogContext) {
    return Scaffold(
      backgroundColor: CColors.shadow.withValues(alpha: 0.1),
      body: Stack(
        children: [
          Center(child: Container(decoration: BoxDecoration(color: Colors.black26))),
          Center(
            child: Container(
              height: screenSize.height * 0.35,
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
                          child: Column(
                            children: [Text(LocaleKeys.now_please_pray_while_facing_kibla.tr(), style: CTextStyle.w900(fontSize: 18, color: CColors.deepTeal), textAlign: TextAlign.center)],
                          ),
                        ),
                      ),
                    ),
                  ),

                  CButton(title: LocaleKeys.continued.tr(), titleWithIcon: true, onTap: () => Navigator.pop(dialogContext), margin: EdgeInsets.only(bottom: 30)),
                ],
              ),
            ),
          ),
          Positioned(top: screenSize.height * 0.275, left: (screenSize.width * 0.5) - 40, child: CustomImage(path: 'assets/svg/kabaa.svg', imageType: ImageType.svg, height: 80)),
        ],
      ),
    );
  }
}

import '../export.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message, this.onLikeTap, this.onSpeakTap, this.onCopyTap});
  final MessageModel message;
  final VoidCallback? onLikeTap;
  final VoidCallback? onSpeakTap;
  final VoidCallback? onCopyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.6),
            child: Container(
              padding: EdgeInsets.all(MediaQuery.textScalerOf(context).scale(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MediaQuery.textScalerOf(context).scale(12)),
                  topRight: Radius.circular(MediaQuery.textScalerOf(context).scale(12)),
                  bottomLeft: Radius.circular(MediaQuery.textScalerOf(context).scale(12)),
                ),
                color: CColors.primary,
              ),
              child: Text(message.question, style: CTextStyle.w400(color: Colors.white)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.sizeOf(context).width * 0.7,
            margin: EdgeInsets.symmetric(vertical: MediaQuery.textScalerOf(context).scale(16)),
            padding: EdgeInsets.all(MediaQuery.textScalerOf(context).scale(16)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(MediaQuery.textScalerOf(context).scale(12)),
                bottomRight: Radius.circular(MediaQuery.textScalerOf(context).scale(12)),
                topLeft: Radius.circular(MediaQuery.textScalerOf(context).scale(12)),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Align(alignment: isLTR(context) ? Alignment.centerLeft : Alignment.centerRight, child: Text(message.answer, style: CTextStyle.w400())),
                if (!message.isGeneratingAnswer)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.textScalerOf(context).scale(16)),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomImage(onTap: onCopyTap, path: 'assets/svg/copy.svg', imageType: ImageType.svg, size: MediaQuery.textScalerOf(context).scale(25), color: CColors.charcoalBlack),
                            // CustomImage(
                            //   margin: EdgeInsets.symmetric(horizontal: MediaQuery.textScalerOf(context).scale(16)),
                            //   path: 'assets/svg/speaker.svg',
                            //   onTap: onSpeakTap,
                            //   imageType: ImageType.svg,
                            //   size: MediaQuery.textScalerOf(context).scale(25),
                            //   color: CColors.charcoalBlack,
                            // ),
                            CustomImage(
                              margin: EdgeInsets.symmetric(horizontal: MediaQuery.textScalerOf(context).scale(16)),
                              onTap: onLikeTap,
                              path: message.isLiked ? 'assets/svg/liked.svg' : 'assets/svg/un_liked.svg',
                              imageType: ImageType.svg,
                              size: MediaQuery.textScalerOf(context).scale(25),
                              color: message.isLiked ? CColors.primary : CColors.charcoalBlack,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

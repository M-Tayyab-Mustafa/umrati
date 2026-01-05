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
            constraints: BoxConstraints(maxWidth: context.w(400)),
            child: Container(
              padding: context.edgeInsets(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(context.r(12)), topRight: Radius.circular(context.r(12)), bottomLeft: Radius.circular(context.r(12))), color: CColors.primary),
              child: Text(message.question, style: CTextStyle.w400(color: Colors.white, fontSize: 14)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: context.w(400),
            margin: context.edgeInsets(vertical: 16),
            padding: context.edgeInsets(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(context.r(12)), bottomRight: Radius.circular(context.r(12)), topLeft: Radius.circular(context.r(12))), color: Colors.white),
            child: Column(
              children: [
                Align(alignment: isLTR(context) ? Alignment.centerLeft : Alignment.centerRight, child: Text(message.answer, style: CTextStyle.w400(fontSize: 14))),
                if (!message.isGeneratingAnswer)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: context.edgeInsets(top: 16),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomImage(onTap: onCopyTap, path: 'assets/svg/copy.svg', imageType: ImageType.svg, size: context.r(18), color: CColors.charcoalBlack),
                            // CustomImage(
                            //   margin: EdgeInsets.symmetric(horizontal: 16),
                            //   path: 'assets/svg/speaker.svg',
                            //   onTap: onSpeakTap,
                            //   imageType: ImageType.svg,
                            //   size: 25,
                            //   color: CColors.charcoalBlack,
                            // ),
                            CustomImage(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              onTap: onLikeTap,
                              path: message.isLiked ? 'assets/svg/liked.svg' : 'assets/svg/un_liked.svg',
                              imageType: ImageType.svg,
                              size: context.r(18),
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

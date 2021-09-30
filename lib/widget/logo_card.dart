import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/res/build_data.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class LogoCard extends StatefulWidget {
  const LogoCard({Key? key}) : super(key: key);

  @override
  _LogoCardState createState() => _LogoCardState();
}

class _LogoCardState extends State<LogoCard> {
  late MediaQueryData _media;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = _media.size.width;
    final pad = width * 0.02;
    return NeuBtn(
      padding: EdgeInsets.all(width * 0.06),
      margin: EdgeInsets.fromLTRB(2.7 * pad, pad, 3 * pad, pad),
      onTap: () {},
      boxShape: NeumorphicBoxShape.roundRect(
          const BorderRadius.all(Radius.circular(17))),
      child: SizedBox(
          height: _media.size.height * 0.1,
          child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return Row(
      children: [
        Hero(
            tag: 'logo_card_img',
            transitionOnUserGestures: true,
            child: SizedBox(
              height: _media.size.height * 0.06,
              child: const FlutterLogo(
                size: 70,
              ),
            )),
        SizedBox(width: _media.size.width * 0.05),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NeuText(
              text: BuildData.name,
              align: TextAlign.start,
              textStyle: NeumorphicTextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10.0),
            NeuText(
              text: 'Toast Studio made with 💗',
              align: TextAlign.start,
              textStyle: NeumorphicTextStyle(fontSize: 12),
            )
          ],
        ),
      ],
    );
  }
}

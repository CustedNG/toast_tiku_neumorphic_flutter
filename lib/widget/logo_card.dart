import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/res/build_data.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_text.dart';
import 'package:toast_tiku/widget/online_img.dart';

class LogoCard extends StatefulWidget {
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
      margin: EdgeInsets.fromLTRB(3*pad, pad, 3*pad, pad),
      onTap: () {},
      boxShape:
          NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(27))),
      child: SizedBox(
          height: _media.size.height * 0.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_buildContent(), _buildRightIcon()],
          )),
    );
  }

  Widget _buildRightIcon() {
    return Icon(Icons.keyboard_arrow_right, color: mainColor);
  }

  Widget _buildContent() {
    return Row(
      children: [
        Hero(
            tag: 'logo_card_img',
            transitionOnUserGestures: true,
            child: SizedBox(
              height: _media.size.height * 0.07,
              child: NeuCard(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child:
                    OnlineImage(url: 'https://blog.lolli.tech/img/favicon.ico'),
                style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
              ),
            )),
        SizedBox(width: _media.size.width * 0.06),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NeuText(
              text: 'Toast Tiku',
              textStyle: NeumorphicTextStyle(fontSize: 20),
            ),
            SizedBox(height: 10.0),
            NeuText(
              text: 'Ver: 1.0.${BuildData.build}',
              textStyle: NeumorphicTextStyle(fontSize: 15),
            )
          ],
        ),
      ],
    );
  }
}

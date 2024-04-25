import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../core/utils.dart';
import '../res/build_data.dart';
import '../res/url.dart';
import 'neu_btn.dart';
import 'neu_text.dart';

/// Logo卡片，位于设置页
class LogoCard extends StatefulWidget {
  const LogoCard({super.key});

  @override
  State<LogoCard> createState() => _LogoCardState();
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
      onTap: () => showSnackBarWithAction(
        context,
        '是否查看本项目开源代码？',
        '查看',
        () => openUrl(openSourceUrl),
      ),
      boxShape: NeumorphicBoxShape.roundRect(
        const BorderRadius.all(Radius.circular(17)),
      ),
      child:
          SizedBox(height: _media.size.height * 0.11, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return Row(
      children: [
        SizedBox(
          height: _media.size.height * 0.06,
          child: const FlutterLogo(
            size: 70,
          ),
        ),
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
              text: 'Made with 💗 by Toast Studio',
              align: TextAlign.start,
              textStyle: NeumorphicTextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

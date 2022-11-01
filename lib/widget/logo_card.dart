import 'package:flutter/material.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/res/build_data.dart';
import 'package:toast_tiku/res/url.dart';
import 'package:toast_tiku/widget/neu_btn.dart';

/// Logo卡片，位于设置页
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
    return NeuBtn(
      borderRadius: const BorderRadius.all(Radius.circular(17)),
      onTap: () => showSnackBarWithAction(
          context, '是否查看本项目开源代码？', '查看', () => openUrl(openSourceUrl)),
            child: SizedBox(height: _media.size.height * 0.11, child: _buildContent()),
          
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
          children: const <Widget>[
            Text(
              BuildData.name,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10.0),
            Text(
              'Made with 💗 by Toast Studio',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/store/setting.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/res/url.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';
import 'package:toast_tiku/widget/tiku_update_progress.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late MediaQueryData _media;
  late final SettingStore _store;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _store = locator<SettingStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: AnimationLimiter(
        child: Column(
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 377),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              _buildHead(),
              TikuUpdateProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHead() {
    return NeuAppBar(
        media: _media,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NeuIconBtn(
              icon: Icons.arrow_back,
              onTap: () => Navigator.of(context).pop(),
            ),
            const NeuText(
              text: '用户',
            ),
            NeuIconBtn(
              icon: Icons.question_answer,
              onTap: () => openUrl(joinQQGroupUrl),
            ),
          ],
        ));
  }
}

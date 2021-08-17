import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/core/persistant_store.dart';
import 'package:toast_tiku/core/update.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/app.dart';
import 'package:toast_tiku/data/store/setting.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/res/build_data.dart';
import 'package:toast_tiku/res/url.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/logo_card.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_text.dart';
import 'package:toast_tiku/widget/online_img.dart';
import 'package:toast_tiku/widget/setting_item.dart';
import 'package:toast_tiku/widget/tiku_update_progress.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late MediaQueryData _media;
  late SettingStore _store;

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
      body:
          Column(children: [_buildHead(), TikuUpdateProgress(), _buildMain()]),
      bottomSheet: Container(
        color: NeumorphicTheme.baseColor(context),
        padding: EdgeInsets.only(bottom: _media.padding.bottom),
        child: LogoCard(),
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
            NeuText(
              text: '设置',
            ),
            NeuIconBtn(
              icon: Icons.question_answer,
              onTap: () => openUrl(joinQQGroupUrl),
            ),
          ],
        ));
  }

  Widget _buildMain() {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: _media.size.height * 0.8, maxWidth: _media.size.width),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: _media.size.height * 0.02),
          _buildUser(),
          _buildSetting()
        ],
      ),
    );
  }

  Widget _buildUser() {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: _media.size.height * 0.17, maxWidth: _media.size.width),
      child: Center(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: _media.size.height * 0.13),
              child: NeuBtn(
                margin: EdgeInsets.zero,
                child:
                    OnlineImage(url: 'https://blog.lolli.tech/img/favicon.ico'),
                boxShape: NeumorphicBoxShape.circle(),
                onTap: () {},
              ),
            ),
            NeuText(text: 'LollipopKit'),
          ],
        ),
      ),
    );
  }

  Widget _buildSetting() {
    return NeuCard(
        padding: EdgeInsets.all(_media.size.width * 0.06),
        margin: EdgeInsets.zero,
        style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(17)))),
        child: Column(
          children: [
            /// TODO: 以下设置暂时无效，未实现
            SettingItem(
              title: '自动添加错题到收藏夹',
              showArrow: false,
              rightBtn: buildSwitch(context, _store.autoAddWrongTi2Favrorite),
            ),
            SettingItem(
              title: '自动更新题库',
              showArrow: false,
              rightBtn: buildSwitch(context, _store.autoUpdateTiku),
            ),
            Consumer<AppProvider>(builder: (_, app, __) {
              String display;
              if (app.newestBuild != null) {
                if (app.newestBuild! > BuildData.build) {
                  display = '发现新版本：${app.newestBuild}';
                } else {
                  display = '当前版本：${BuildData.build}，已是最新';
                }
              } else {
                display = '当前版本：${BuildData.build}';
              }
              return SettingItem(
                  title: display, onTap: () => doUpdate(context, force: true));
            })
          ],
        ));
  }

  Widget buildSwitch(BuildContext context, StoreProperty<bool> prop,
      {Function(bool)? func}) {
    return ValueListenableBuilder(
      valueListenable: prop.listenable(),
      builder: (context, bool value, widget) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 27),
          child: NeumorphicSwitch(
              height: 27,
              value: value,
              onChanged: (val) {
                if (func != null) func(val);
                prop.put(val);
              }),
        );
      },
    );
  }
}

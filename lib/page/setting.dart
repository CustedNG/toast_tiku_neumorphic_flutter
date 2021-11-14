import 'package:flutter/widgets.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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
import 'package:toast_tiku/widget/setting_item.dart';
import 'package:toast_tiku/widget/tiku_update_progress.dart';

/// 设置页面
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late MediaQueryData _media;
  late SettingStore _store;
  late int _selectedColorValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
  }

  @override
  void initState() {
    super.initState();
    _store = locator<SettingStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
          children: [_buildHead(), const TikuUpdateProgress(), _buildMain()]),
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
              text: '设置',
            ),
            NeuIconBtn(
              icon: Icons.question_answer,
              onTap: () => showSnackBarWithAction(
                  context, '可在用户群反馈问题、吹水', '加入', () => openUrl(joinQQGroupUrl)),
            ),
          ],
        ));
  }

  Widget _buildMain() {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: _media.size.height * 0.84, maxWidth: _media.size.width),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: _media.size.height * 0.02),
          const LogoCard(),
          _buildSetting()
        ],
      ),
    );
  }

  Widget _buildSetting() {
    return NeuCard(
        padding: EdgeInsets.all(_media.size.width * 0.06),
        margin: EdgeInsets.zero,
        style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(
                const BorderRadius.all(Radius.circular(17)))),
        child: Column(
          children: [
            SettingItem(
              title: '自动展示答案',
              showArrow: false,
              rightBtn: _buildSwitch(context, _store.autoDisplayAnswer),
            ),
            SettingItem(
              title: '显示历史选择的选项',
              showArrow: false,
              rightBtn: _buildSwitch(context, _store.saveAnswer),
            ),
            SettingItem(
              title: '自动更新题库',
              showArrow: false,
              rightBtn: _buildSwitch(context, _store.autoUpdateTiku),
            ),
            _buildAppColorPreview(),
            Consumer<AppProvider>(builder: (_, app, __) {
              String display;
              if (app.newestBuild != null) {
                if (app.newestBuild! > BuildData.build) {
                  display = '发现App新版本：${app.newestBuild}';
                } else {
                  display = 'App当前版本：${BuildData.build}，已是最新';
                }
              } else {
                display = 'App当前版本：${BuildData.build}，点击检查更新';
              }
              return SettingItem(
                  title: display, onTap: () => doUpdate(context, force: true));
            })
          ],
        ));
  }

  Widget _buildAppColorPreview() {
    final nowAppColor = _store.appPrimaryColor.fetch()!;
    return SizedBox(
      width: _media.size.width * 0.8,
      child: ExpansionTile(
          tilePadding: const EdgeInsets.only(left: 7.7, right: 7.7),
          childrenPadding: EdgeInsets.zero,
          children: [
            _buildAppColorPicker(Color(nowAppColor)),
            _buildColorPickerConfirmBtn()
          ],
          trailing: ClipOval(
            child: Container(
              color: Color(nowAppColor),
              height: 27,
              width: 27,
            ),
          ),
          title: const NeuText(
            text: 'App主题色',
            align: TextAlign.start,
          )),
    );
  }

  Widget _buildAppColorPicker(Color selected) {
    return MaterialColorPicker(
        shrinkWrap: true,
        onColorChange: (Color color) {
          _selectedColorValue = color.value;
        },
        selectedColor: selected);
  }

  Widget _buildColorPickerConfirmBtn() {
    return NeuIconBtn(
      icon: Icons.save,
      onTap: (() {
        _store.appPrimaryColor.put(_selectedColorValue);
        setState(() {});
      }),
    );
  }

  Widget _buildSwitch(BuildContext context, StoreProperty<bool> prop,
      {Function(bool)? func}) {
    return ValueListenableBuilder(
      valueListenable: prop.listenable(),
      builder: (context, bool value, widget) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 27),
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

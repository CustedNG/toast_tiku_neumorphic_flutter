import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/core/update.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/app.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/data/store/setting.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/res/build_data.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/res/url.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/logo_card.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_switch.dart';
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
    return SizedBox(
      height: getRemainHeight(_media),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: _media.size.height * 0.02),
          const LogoCard(),
          _buildTikuSetting(),
          _buildAppSetting()
        ],
      ),
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return NeuCard(
        padding: EdgeInsets.all(_media.size.width * 0.06),
        margin: EdgeInsets.zero,
        borderRadius: NeumorphicStyle(
            borderRadius: NeumorphicBoxShape.roundRect(
                const BorderRadius.all(Radius.circular(17)))),
        child: Column(
          children: children,
        ));
  }

  Widget _buildAppSetting() {
    final pColor = primaryColor;
    return _buildSettingCard([
      SettingItem(
        title: 'App主题色',
        rightBtn: ClipOval(
          child: Container(
            color: pColor,
            height: 27,
            width: 27,
          ),
        ),
        onTap: () => showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: NeumorphicTheme.baseColor(context),
                title: const NeuText(
                  text: 'App主题色',
                  align: TextAlign.start,
                ),
                content: SizedBox(
                  width: _media.size.width * 0.8,
                  child: _buildAppColorPicker(pColor),
                ),
                actions: [
                  NeuIconBtn(
                    icon: Icons.done,
                    onTap: () {
                      _store.appPrimaryColor.put(_selectedColorValue);
                      Navigator.of(context).pop();
                    },
                  ),
                  NeuIconBtn(
                    icon: Icons.close,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }),
      ),
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
        return SettingItem(title: display, onTap: () => doUpdate(context));
      })
    ]);
  }

  Widget _buildTikuSetting() {
    return _buildSettingCard([
      SettingItem(
        title: '自动展示答案',
        rightBtn: buildSwitch(context, _store.autoDisplayAnswer),
      ),
      SettingItem(
        title: '答对自动跳转下一题',
        rightBtn: buildSwitch(context, _store.autoSlide2NextWhenCorrect),
      ),
      SettingItem(
        title: '显示做题历史记录',
        rightBtn: buildSwitch(context, _store.saveAnswer),
      ),
      Consumer<TikuProvider>(builder: (_, tiku, __) {
        if (tiku.isBusy) {
          return SettingItem(
            title: '题库数据正在更新',
            rightBtn: SizedBox(
              width: _media.size.width * 0.37,
              child: NeuText(
                  text: (tiku.downloadProgress * 100).toStringAsFixed(2) + '%',
                  align: TextAlign.end),
            ),
          );
        }

        /// 不忙，下载完成，则显示空视图
        return SettingItem(
          title: '题库数据已是最新',
          rightBtn: NeuText(text: tiku.indexVersion ?? ''),
        );
      }),
    ]);
  }

  Widget _buildAppColorPicker(Color selected) {
    return MaterialColorPicker(
        shrinkWrap: true,
        onColorChange: (Color color) {
          _selectedColorValue = color.value;
        },
        selectedColor: selected);
  }
}

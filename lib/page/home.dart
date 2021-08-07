import 'dart:async';
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/extension/ti.dart';
import 'package:toast_tiku/data/provider/app.dart';
import 'package:toast_tiku/data/provider/history.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/page/course.dart';
import 'package:toast_tiku/page/setting.dart';
import 'package:toast_tiku/page/unit_quiz.dart';
import 'package:toast_tiku/res/build_data.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/res/hikotoko.dart';
import 'package:toast_tiku/res/url.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/center_loading.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';
import 'package:toast_tiku/widget/online_img.dart';
import 'package:toast_tiku/widget/search.dart';
import 'package:toast_tiku/widget/tiku_update_progress.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
  late MediaQueryData _media;
  late FixedExtentScrollController _fixedExtentScrollController;

  final titleStyle =
      NeumorphicTextStyle(fontWeight: FontWeight.bold, fontSize: 17);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _fixedExtentScrollController = FixedExtentScrollController();
    Timer.periodic(Duration(seconds: 7), (timer) {
      _fixedExtentScrollController.animateToItem(timer.tick % 2,
          duration: Duration(milliseconds: 577), curve: Curves.easeInOutExpo);
    });
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
              SizedBox(height: _media.size.height * 0.03),
              _buildNotifyCard(),
              SizedBox(height: _media.size.height * 0.01),
              _buildResumeCard(),
              SizedBox(height: _media.size.height * 0.01),
              _buildAllCourseCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: _media.size.width,
        child: NeuText(
          text: 'Version: 1.0.${BuildData.build} BuiltAt: ${BuildData.buildAt}',
          textStyle: NeumorphicTextStyle(fontSize: 11),
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
            Row(
              children: [
                NeuIconBtn(
                  icon: Icons.account_circle,
                  onTap: () => AppRoute(SettingPage()).go(context),
                ),
                const NeuText(
                  text: 'Hi 👋🏻\nLollipopKit',
                  align: TextAlign.start,
                ),
              ],
            ),
            _buildTopBtn(),
          ],
        ));
  }

  Widget _buildNotifyCard() {
    final content = _buildScrollCard();
    return SizedBox(
      height: _media.size.height * 0.21,
      child: ListWheelScrollView.useDelegate(
        itemExtent: _media.size.height * 0.2,
        diameterRatio: 10,
        controller: _fixedExtentScrollController,
        physics: FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) => content[index],
            childCount: content.length),
      ),
    );
  }

  List<Widget> _buildScrollCard() {
    return [
      _buildBannerView('一言', hitokotos[Random().nextInt(hitokotos.length)]),
      Consumer<AppProvider>(builder: (_, app, __) {
        if (app.isBusy) {
          return NeumorphicProgressIndeterminate();
        }
        if (app.notify == null) {
          return SizedBox();
        }
        return _buildBannerView(app.notify!['title'], app.notify!['content']);
      })
    ];
  }

  Widget _buildBannerView(String title, String content) {
    final pad = _media.size.width * 0.06;
    return NeuCard(
      padding: EdgeInsets.fromLTRB(pad, 17, pad, 17),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeuText(text: title, textStyle: titleStyle),
          SizedBox(
            width: _media.size.width,
            child: NeuText(
              text: '·',
              textStyle: titleStyle,
            ),
          ),
          NeuText(text: content)
        ],
      ),
    );
  }

  Widget _buildResumeCard() {
    return Consumer<HistoryProvider>(
      builder: (_, history, ___) {
        return Consumer<TikuProvider>(
          builder: (_, tiku, __) {
            Widget child = SizedBox();
            if (tiku.tikuIndex == null) {
              if (tiku.isBusy) {
                child = NeuText(text: '题库正在初始化，请稍等');
              } else {
                child = NeuText(text: '未能获取到题库索引数据');
              }
            } else {
              for (var index in tiku.tikuIndex!) {
                // 根据用户年级推荐科目，不固定为毛概
                var historyData = history.lastViewed ?? 'maogai-1.json';
                var historySplit = historyData.split('-');
                if (index.id == historySplit[0]) {
                  for (var unit in index.content!) {
                    if (unit!.data == historySplit[1]) {
                      child = Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NeuText(
                                  text: '继续 · ' + index.chinese!,
                                  textStyle: NeumorphicTextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              Hero(
                                  tag: 'home_resume_title',
                                  child: NeuText(
                                      text: unit.title!,
                                      style: NeumorphicStyle(
                                          color: mainColor.withOpacity(0.8)),
                                      textStyle:
                                          NeumorphicTextStyle(fontSize: 11))),
                            ],
                          ),
                          NeuIconBtn(
                            icon: Icons.arrow_forward,
                            margin: EdgeInsets.all(7),
                            padding: EdgeInsets.all(5),
                            onTap: () => AppRoute(UnitQuizPage(
                                    courseId: historySplit[0],
                                    unitFile: historySplit[1],
                                    unitName: unit.title!))
                                .go(context),
                          )
                        ],
                      );
                      break;
                    }
                  }
                }
              }
            }
            return SizedBox(
              width: _media.size.width * 0.9,
              height: _media.size.height * 0.1,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(17, 7, 17, 7), child: child),
            );
          },
        );
      },
    );
  }

  Widget _buildAllCourseCard() {
    return SizedBox(
      height: _media.size.height * 0.26,
      width: _media.size.width * 0.9,
      child: Consumer<TikuProvider>(builder: (_, tiku, __) {
        if (tiku.tikuIndex == null) {
          if (tiku.isBusy) {
            return centerLoading;
          }
          return Center(child: NeuText(text: '出现期望外的错误'));
        }

        return GridView.builder(
            padding: EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.0),
            itemCount: tiku.tikuIndex!.length,
            itemBuilder: (context, idx) {
              final item = tiku.tikuIndex![idx];
              return NeuBtn(
                margin: EdgeInsets.all(0),
                onTap: () => AppRoute(CoursePage(data: item)).go(context),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: (_media.size.width * 0.9 - 40) / 8.7,
                          child:
                              OnlineImage(url: '$courseImgUrl/${item.id}.png')),
                      SizedBox(
                        height: 1,
                      ),
                      Hero(
                          tag: 'home_all_course_${item.id}',
                          child: NeuText(
                            text: item.chinese!,
                            textStyle: NeumorphicTextStyle(fontSize: 11),
                          ))
                    ]),
              );
            });
      }),
    );
  }

  Widget _buildTopBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NeuIconBtn(
          icon: Icons.settings,
          onTap: () => AppRoute(SettingPage()).go(context),
        ),
        NeuIconBtn(
          icon: Icons.search,
          onTap: () => showSearch(
            context: context,
            delegate: SearchPage<Ti>(
                items: getAllTi(),
                searchLabel: '搜索题目',
                suggestion: Center(
                  child: NeuText(text: '通过题目来搜索'),
                ),
                failure: Center(
                  child: NeuText(text: '未找到相关题目 :('),
                ),
                filter: (ti) => [
                      ti.question,
                    ],
                builder: (ti) => NeuCard(child: _buildSearchResult(ti)),
                searchStyle: TextStyle(color: mainColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResult(Ti ti) {
    switch (ti.type) {
      case 0:
      case 1:
      case 3:
        return ListTile(
          title: NeuText(text: ti.question!, align: TextAlign.start),
          subtitle: NeuText(
              text: _buildOption(ti.options ?? []) + _buildAnswer(ti),
              align: TextAlign.start),
          trailing: NeuText(text: ti.typeChinese, align: TextAlign.start),
        );
      case 2:
        return ListTile(
          title: NeuText(text: ti.question!, align: TextAlign.start),
          subtitle: NeuText(
              text: _buildOption(ti.answer!) + _buildAnswer(ti),
              align: TextAlign.start),
          trailing: NeuText(text: ti.typeChinese, align: TextAlign.start),
        );
      default:
        return SizedBox();
    }
  }

  String _buildOption(List option) {
    switch (option.length) {
      case 2:
        return option.join('\n') + '\n';
      case 3:
      case 4:
      case 5:
      case 6:
        int idx = 0;
        String result = '';
        for (var item in option) {
          result += String.fromCharCode(65 + idx++) + '.$item\n';
        }
        return result;
      default:
        return '';
    }
  }

  String _buildAnswer(Ti ti) {
    final answer = '\n答案：';
    switch (ti.type) {
      case 3:
        if (ti.options == null) {
          return '$answer${ti.answer![0] == 0 ? "对" : "错"}';
        }
        return '$answer${ti.options![ti.answer![0]]}';
      case 2:
        return '$answer${ti.answer!.join(",")}';
      case 0:
      case 1:
        final answers = <String>[];
        for (var item in ti.answer!) {
          if (item is int) {
            answers.add(String.fromCharCode(65 + item));
          }
        }
        return '$answer' + answers.join(',');
      default:
        return '无法解析答案';
    }
  }

  List<Ti> getAllTi() {
    final tiku = context.read<TikuProvider>();
    final store = locator<TikuStore>();
    if (tiku.tikuIndex == null) {
      return <Ti>[];
    }
    final tis = <Ti>[];
    for (var item in tiku.tikuIndex!) {
      for (var unit in item.content!) {
        tis.addAll(store.fetch(item.id!, unit!.data!)!);
      }
    }
    return tis;
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await locator<TikuProvider>().refreshUnit();
  }
}

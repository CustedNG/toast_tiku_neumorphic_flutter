import 'dart:async';
import 'dart:math' show Random;

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/core/analysis.dart';
import 'package:toast_tiku/core/build_mode.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/extension/ti.dart';
import 'package:toast_tiku/core/update.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/app.dart';
import 'package:toast_tiku/data/provider/history.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/page/course.dart';
import 'package:toast_tiku/page/debug.dart';
import 'package:toast_tiku/page/exam/select.dart';
import 'package:toast_tiku/page/setting.dart';
import 'package:toast_tiku/page/unit_quiz.dart';
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

/// App启动后的主页面
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
  late MediaQueryData _media;

  /// 一言及通知上下滚动banner的控制器
  late FixedExtentScrollController _fixedExtentScrollController;

  /// banner滚动定时器
  Timer? _timer;

  /// 标题文字风格
  final titleStyle =
      NeumorphicTextStyle(fontWeight: FontWeight.bold, fontSize: 17);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _fixedExtentScrollController = FixedExtentScrollController();

    /// 如果定时器已被初始化，则跳过
    if (_timer != null) return;

    /// 每隔七秒钟，banner滚动一次
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      _fixedExtentScrollController.animateToItem(timer.tick % 2,
          duration: const Duration(milliseconds: 577),
          curve: Curves.easeInOutExpo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Column(
          children: [
            _buildHead(),
            const TikuUpdateProgress(),
            SizedBox(
              height: getRemainHeight(_media),
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildNotifyCard(),
                  _buildResumeCard(),
                  SizedBox(height: _media.size.height * 0.01),
                  _buildAllCourseCard(),
                ],
              ),
            )
          ],
        ));
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
                  icon: Icons.settings,
                  onTap: () => AppRoute(const SettingPage()).go(context),
                ),
                GestureDetector(
                  onLongPress: () => AppRoute(const DebugPage()).go(context),
                  child: NeuText(
                    text:
                        '今天已过去\n${(DateTime.now().hour / 24 * 100).toStringAsFixed(1)}%',
                    align: TextAlign.start,
                  ),
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
      height: _media.size.height * 0.27,
      child: ListWheelScrollView.useDelegate(
        itemExtent: _media.size.height * 0.25,
        diameterRatio: 10,
        controller: _fixedExtentScrollController,
        physics:
            const FixedExtentScrollPhysics(parent: BouncingScrollPhysics()),
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
          return centerLoading;
        }
        if (app.notify == null) {
          return _buildBannerView('🐎⬆️', '加载中');
        }
        return _buildBannerView(app.notify!['title'], app.notify!['content']);
      })
    ];
  }

  Widget _buildBannerView(String title, String content) {
    final horizon = _media.size.width * 0.07;
    final vertical = _media.size.height * 0.03;
    return NeuCard(
      padding: EdgeInsets.symmetric(horizontal: horizon, vertical: vertical),
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
            Widget child = const SizedBox();
            if (tiku.tikuIndex == null) {
              if (tiku.isBusy) {
                child = const NeuText(text: '题库正在初始化，请稍等');
              } else {
                child = const NeuText(text: '未能获取到题库索引数据');
              }
            } else {
              for (var index in tiku.tikuIndex!) {
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
                                  text: '上次学到了 · ' + index.chinese!,
                                  textStyle: NeumorphicTextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              Hero(
                                  transitionOnUserGestures: true,
                                  tag: 'home_resume_title',
                                  child: NeuText(
                                      text: unit.title!,
                                      style: NeumorphicStyle(
                                          color: mainTextColor
                                              .resolve(context)
                                              .withOpacity(0.8)),
                                      textStyle:
                                          NeumorphicTextStyle(fontSize: 11))),
                            ],
                          ),
                          NeuIconBtn(
                            icon: Icons.arrow_forward,
                            margin: const EdgeInsets.all(7),
                            padding: const EdgeInsets.all(5),
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
            return Padding(
                padding: EdgeInsets.fromLTRB(
                    _media.size.width * 0.07, 7, _media.size.width * 0.05, 7),
                child: child);
          },
        );
      },
    );
  }

  Widget _buildAllCourseCard() {
    return SizedBox(
      height: _media.size.height * 0.5,
      width: _media.size.width * 0.9,
      child: Consumer<TikuProvider>(builder: (_, tiku, __) {
        if (tiku.tikuIndex == null) {
          if (tiku.isBusy) {
            return centerLoading;
          }
          return const Center(child: NeuText(text: '出现期望外的错误'));
        }

        return GridView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: _media.size.width * 0.05, vertical: 7),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.0),
            itemCount: tiku.tikuIndex!.length,
            itemBuilder: (context, idx) {
              final item = tiku.tikuIndex![idx];
              return NeuBtn(
                margin: const EdgeInsets.all(0),
                onTap: () => AppRoute(CoursePage(data: item)).go(context),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: (_media.size.width * 0.9 - 40) / 8.7,
                          child:
                              OnlineImage(url: '$courseImgUrl/${item.id}.png')),
                      const SizedBox(
                        height: 1,
                      ),
                      NeuText(
                        text: item.chinese!,
                        textStyle: NeumorphicTextStyle(fontSize: 11),
                      )
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
          icon: Icons.checklist,
          onTap: () => AppRoute(const ExamSelectPage()).go(context),
        ),
        NeuIconBtn(
          icon: Icons.search,
          onTap: () => showSearch(
            context: context,
            delegate: SearchPage<Ti>(
                items: getAllTi(),
                searchLabel: '搜索题目',
                suggestion: const Center(
                  child: NeuText(text: '通过题目来搜索'),
                ),
                failure: const Center(
                  child: NeuText(text: '未找到相关题目 :('),
                ),
                filter: (ti) => [
                      ti.question,
                    ],
                builder: (ti) => NeuCard(child: _buildSearchResult(ti)),
                searchStyle: TextStyle(color: mainTextColor.resolve(context))),
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
              text: _buildOption(ti.options ?? []) + ti.answerStr,
              align: TextAlign.start),
          trailing: NeuText(text: ti.typeChinese, align: TextAlign.start),
        );
      case 2:
        return ListTile(
          title: NeuText(text: ti.question!, align: TextAlign.start),
          subtitle: NeuText(
              text: _buildOption(ti.answer!) + ti.answerStr,
              align: TextAlign.start),
          trailing: NeuText(text: ti.typeChinese, align: TextAlign.start),
        );
      default:
        return const SizedBox();
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

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await locator<AppProvider>().loadData();
    if (BuildMode.isRelease) {
      await Analysis.init(false);
    }
    await doUpdate(context);
    await locator<TikuProvider>().refreshData();
  }
}

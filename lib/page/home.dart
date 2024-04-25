import 'dart:async';
import 'dart:math' show Random;

import 'package:after_layout/after_layout.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/model/tiku_index.dart';

import '../core/extension/ti.dart';
import '../core/analysis.dart';
import '../core/build_mode.dart';
import '../core/route.dart';
import '../core/update.dart';
import '../core/utils.dart';
import '../data/provider/app.dart';
import '../data/provider/tiku.dart';
import '../data/provider/unit_history.dart';
import '../data/store/setting.dart';
import '../locator.dart';
import '../model/ti.dart';
import '../res/color.dart';
import '../res/hikotoko.dart';
import '../res/url.dart';
import '../widget/app_bar.dart';
import '../widget/center_loading.dart';
import '../widget/neu_btn.dart';
import '../widget/neu_card.dart';
import '../widget/neu_switch.dart';
import '../widget/neu_text.dart';
import '../widget/online_img.dart';
import '../widget/search.dart';
import '../widget/tiku_update_progress.dart';
import 'course.dart';
import 'debug.dart';
import 'exam/select.dart';
import 'setting.dart';
import 'unit_quiz.dart';

/// App启动后的主页面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
  /// 一言及通知上下滚动banner的控制器
  final _fixedExtentScrollController = FixedExtentScrollController();

  /// 标题文字风格
  final titleStyle = NeumorphicTextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
  );

  final _setting = locator<SettingStore>();

  @override
  void initState() {
    super.initState();

    /// 每隔七秒钟，banner滚动一次
    Timer.periodic(const Duration(seconds: 7), (timer) {
      _fixedExtentScrollController.animateToItem(
        timer.tick % 2,
        duration: const Duration(milliseconds: 577),
        curve: Curves.easeInOutExpo,
      );
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
          _buildNotifyCard(),
          _buildResumeCard(),
          Expanded(child: _buildAllCourseCard()),
          _buildDirectlyShowAnswerSwitch(),
        ],
      ),
      bottomSheet: _buildContributor(),
    );
  }

  Widget _buildContributor() {
    return Container(
      color: NeumorphicTheme.baseColor(context),
      height: 23,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 5,
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
              child: Consumer<AppProvider>(
                builder: (_, provider, __) {
                  final rand = Random().nextInt(provider.contributors.length);
                  return Text(
                    provider.contributors[rand],
                    style: const TextStyle(fontSize: 13),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDirectlyShowAnswerSwitch() {
    return SizedBox(
      width: 47,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ignore: prefer_const_constructors
          NeuText(
            text: '背题模式',
            align: TextAlign.center,
          ),
          const SizedBox(width: 11),
          buildSwitch(context, _setting.directlyShowAnswer),
        ],
      ),
    );
  }

  Widget _buildHead() {
    return NeuAppBar(
      media: MediaQuery.of(context),
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
                // ignore: prefer_const_constructors
                child: NeuText(
                  text: 'Toast题库',
                  align: TextAlign.start,
                ),
              ),
            ],
          ),
          _buildTopBtn(),
        ],
      ),
    );
  }

  Widget _buildNotifyCard() {
    final content = _buildScrollCard();
    return SizedBox(
      height: 197,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 189,
        diameterRatio: 10,
        controller: _fixedExtentScrollController,
        physics:
            const FixedExtentScrollPhysics(parent: BouncingScrollPhysics()),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) => content[index],
          childCount: content.length,
        ),
      ),
    );
  }

  List<Widget> _buildScrollCard() {
    return [
      _buildBannerView('一言', hitokotos[Random().nextInt(hitokotos.length)]),
      Consumer<AppProvider>(
        builder: (_, app, __) {
          if (app.isBusy) {
            return centerLoading;
          }
          if (app.notify == null) {
            return _buildBannerView('🐎⬆️', '加载中');
          }
          return _buildBannerView(app.notify!['title'], app.notify!['content']);
        },
      ),
    ];
  }

  Widget _buildBannerView(String title, String content) {
    return NeuCard(
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeuText(text: title, textStyle: titleStyle),
          SizedBox(
            width: double.infinity,
            child: NeuText(
              text: '·',
              textStyle: titleStyle,
            ),
          ),
          NeuText(text: content),
        ],
      ),
    );
  }

  Widget _buildResumeCard() {
    return Consumer<HistoryProvider>(
      builder: (_, history, ___) {
        return Consumer<TikuProvider>(
          builder: (_, tiku, __) {
            if (tiku.tikuIndex == null) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 27,
                  vertical: 17,
                ),
                child: switch (tiku.isBusy) {
                  true => const NeuText(text: '题库正在初始化，请稍等'),
                  false => const NeuText(text: '未能获取到题库索引数据'),
                },
              );
            }
            return _buildResumeCardContent(tiku, history);
          },
        );
      },
    );
  }

  Widget _buildResumeCardContent(TikuProvider tiku, HistoryProvider history) {
    Widget child = const SizedBox();
    for (var index in tiku.tikuIndex ?? <TikuIndex>[]) {
      var historyData = history.lastViewed ?? 'maogai-1.json';
      var historySplit = historyData.split('-');
      if (historySplit.length != 2) continue;
      if (index.id == historySplit[0]) {
        for (var unit in index.content ?? <TikuIndexContent>[]) {
          if (unit == null) continue;
          if (unit.data == historySplit[1]) {
            final title = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NeuText(
                  text: '上次学到了 · ${index.chinese ?? '未知课程'}',
                  textStyle: NeumorphicTextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Hero(
                  transitionOnUserGestures: true,
                  tag: 'home_resume_title',
                  child: NeuText(
                    text: unit.title ?? '未知标题',
                    style: NeumorphicStyle(
                      color: mainTextColor.resolve(context).withOpacity(0.8),
                    ),
                    textStyle: NeumorphicTextStyle(fontSize: 11),
                  ),
                ),
              ],
            );
            final btn = NeuIconBtn(
              icon: Icons.arrow_forward,
              margin: const EdgeInsets.all(7),
              padding: const EdgeInsets.all(5),
              onTap: () => AppRoute(
                UnitQuizPage(
                  courseId: historySplit[0],
                  unitFile: historySplit[1],
                  unitName: unit.title!,
                ),
              ).go(context),
            );
            child = Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [title, btn],
            );
            break;
          }
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 17),
      child: child,
    );
  }

  Widget _buildAllCourseCard() {
    return Consumer<TikuProvider>(
      builder: (_, tiku, __) {
        if (tiku.tikuIndex == null) {
          if (tiku.isBusy) {
            return centerLoading;
          }
          return const Center(child: NeuText(text: '出现期望外的错误'));
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 7,
          ),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
          ),
          itemCount: tiku.tikuIndex?.length ?? 0,
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
                    width: 40,
                    child: OnlineImage(url: '$courseImgUrl/${item.id}.png'),
                  ),
                  const SizedBox(height: 5),
                  NeuText(
                    text: item.chinese ?? '未知',
                    textStyle: NeumorphicTextStyle(fontSize: 11),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NeuBtn(
          child: NeuText(
            text: '模考',
            textStyle: NeumorphicTextStyle(fontWeight: FontWeight.bold),
          ),
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
              filter: (ti) => [ti.question],
              builder: (ti) => NeuCard(child: _buildSearchResult(ti)),
              searchStyle: TextStyle(color: mainTextColor.resolve(context)),
            ),
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
          title: NeuText(text: ti.question ?? '未知题目问题', align: TextAlign.start),
          subtitle: NeuText(
            text: _buildOption(ti.options ?? []) + ti.answerStr,
            align: TextAlign.start,
          ),
          trailing: NeuText(text: ti.typeChinese, align: TextAlign.start),
        );
      case 2:
        return ListTile(
          title: NeuText(text: ti.question ?? '未知题目问题', align: TextAlign.start),
          subtitle: NeuText(
            text: _buildOption(ti.answer ?? []) + ti.answerStr,
            align: TextAlign.start,
          ),
          trailing: NeuText(text: ti.typeChinese, align: TextAlign.start),
        );
      default:
        return const SizedBox();
    }
  }

  String _buildOption(List option) {
    switch (option.length) {
      case 2:
        return '${option.join('\n')}\n';
      case 3:
      case 4:
      case 5:
      case 6:
        int idx = 0;
        String result = '';
        for (var item in option) {
          result += '${String.fromCharCode(65 + idx++)}.$item\n';
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

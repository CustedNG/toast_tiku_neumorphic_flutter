import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/history.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/page/course.dart';
import 'package:toast_tiku/page/unit_quiz.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
  late MediaQueryData _media;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHead(),
          _buildUpdateProgress(),
          SizedBox(height: _media.size.height * 0.03),
          _buildResumeCard(),
          SizedBox(height: _media.size.height * 0.01),
          _buildAllCourseCard(),
        ],
      ),
    );
  }

  Widget _buildUpdateProgress() {
    return Consumer<TikuProvider>(builder: (_, tiku, __) {
      if (tiku.isBusy) {
        return NeumorphicProgress(
          percent: tiku.downloadProgress,
          height: 3,
        );
      }
      if (tiku.tikuIndex == null) {
        return NeuText(text: '未能获取到题库索引数据');
      }
      return SizedBox();
    });
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
                  icon: Icons.people,
                  onTap: () => showSnackBar(context, Text('1231')),
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

  Widget _buildResumeCard() {
    return Consumer<HistoryProvider>(
      builder: (_, history, ___) {
        return Center(
          child: Consumer<TikuProvider>(
            builder: (_, tiku, __) {
              Widget child = SizedBox();
              if (tiku.tikuIndex == null) {
                if (tiku.isBusy) {
                  child = NeuText(text: '题库正在初始化，请稍等');
                } else {
                  child = NeuText(text: '未能获取到题库索引数据');
                }
              }
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
                                text: index.chinese!, 
                                textStyle: NeumorphicTextStyle(
                                  fontSize: 17
                                )),
                              NeuText(
                                text: unit.title!,
                                style: NeumorphicStyle(
                                  color: mainColor.withOpacity(0.8)
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontSize: 11
                                ))
                            ],
                          ),
                          NeuIconBtn(
                            icon: Icons.play_arrow,
                            onTap: () => AppRoute(UnitQuizPage(
                              courseId: historySplit[0], 
                              unitFile: historySplit[1], 
                              unitName: unit.title!)).go(context),
                          )
                        ],
                      );
                      break;
                    }
                  }
                }
              }
              return NeuCard(
                child: SizedBox(
                  width: _media.size.width * 0.9 - 40,
                  height: _media.size.height * 0.07,
                  child: child,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAllCourseCard() {
    return NeuCard(
      child: SizedBox(
        width: _media.size.width * 0.9 - 40,
        height: _media.size.height * 0.17,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeuIconBtn(
              icon: Icons.add,
              boxShape: const NeumorphicBoxShape.circle(),
              onTap: () => showSnackBar(context,
                  Text(locator<TikuProvider>().tikuIndex!.length.toString())),
            ),
            const NeuText(text: '还没有收藏的科目，点击添加')
          ],
        ),
      ),
    );
  }

  Widget _buildTopBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NeuIconBtn(
          icon: Icons.add,
          onTap: () => AppRoute(
                  CoursePage(data: locator<TikuProvider>().tikuIndex!.last))
              .go(context),
        ),
        NeuIconBtn(
          icon: Icons.search,
          onTap: () => NeumorphicTheme.of(context)!.themeMode = ThemeMode.dark,
        ),
      ],
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await locator<TikuProvider>().refreshUnit();
  }
}

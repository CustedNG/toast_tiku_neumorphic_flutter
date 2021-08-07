import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/res/url.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';
import 'package:toast_tiku/widget/tiku_update_progress.dart';

class ExamSelectPage extends StatefulWidget {
  const ExamSelectPage({Key? key}) : super(key: key);

  @override
  _ExamSelectPageState createState() => _ExamSelectPageState();
}

class _ExamSelectPageState extends State<ExamSelectPage> {
  late MediaQueryData _media;
  late TikuProvider _tikuProvider;
  String? _selectedCourse;
  late List<double> _tiCount;

  final titleStyle =
      NeumorphicTextStyle(fontSize: 17, fontWeight: FontWeight.bold);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _tikuProvider = locator<TikuProvider>();
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
            children: [_buildHead(), TikuUpdateProgress(), _buildMain()],
          ),
        ),
      ),
      bottomSheet: _buildStart(),
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
              text: '模拟考试',
            ),
            NeuIconBtn(
              icon: Icons.question_answer,
              onTap: () => openUrl(joinQQGroupUrl),
            ),
          ],
        ));
  }

  Widget _buildMain() {
    return SizedBox(
      height: _media.size.height * 0.84,
      width: _media.size.width,
      child: Column(
        children: [_buildCourseSelect(), _buildTiTypeSelect()],
      ),
    );
  }

  Widget _buildCourseSelect() {
    return Consumer<TikuProvider>(
      builder: (_, tiku, __) {
        if (tiku.isBusy) {
          return SizedBox();
        }
        if (tiku.tikuIndex == null) {
          return Center(
            child: NeuText(text: '题库索引数据缺失'),
          );
        } else {
          final radios = <Widget>[];
          for (var item in tiku.tikuIndex!) {
            radios.add(NeumorphicRadio<String>(
              child: Center(child: NeuText(text: item.chinese!)),
              style: NeumorphicRadioStyle(
                  boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.all(Radius.circular(7)))),
              value: item.id,
              groupValue: _selectedCourse,
              onChanged: (val) => setState(() {
                _selectedCourse = val;
                _tiCount = [20, 0, 0, 0];
              }),
            ));
          }
          final gridPad = _media.size.width * 0.05;
          return Column(
            children: [
              SizedBox(height: _media.size.height * 0.03),
              NeuText(text: '科目', textStyle: titleStyle),
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxHeight: _media.size.height * 0.2),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(gridPad),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, childAspectRatio: 2),
                    itemCount: radios.length,
                    itemBuilder: (context, idx) {
                      return Padding(
                        padding: EdgeInsets.all(7),
                        child: radios[idx],
                      );
                    }),
              )
            ],
          );
        }
      },
    );
  }

  Widget _buildTiTypeSelect() {
    final selected = _selectedCourse != null;
    if (!selected) {
      return SizedBox();
    }
    final index = _tikuProvider.tikuIndex;
    if (index == null) {
      return SizedBox();
    }
    final course = index.firstWhere((element) => element.id == _selectedCourse);
    int singleCount = 0, mutiCount = 0, judgeCount = 0, fillCount = 0;
    for (var item in course.content!) {
      singleCount += item!.radio!;
      mutiCount += item.multiple!;
      judgeCount += item.decide!;
      fillCount += item.fill!;
    }
    return Padding(
      padding: EdgeInsets.all(_media.size.width * 0.05),
      child: Column(
        children: [
          NeuText(
            text: '题型',
            textStyle: titleStyle,
          ),
          SizedBox(
            height: 7,
          ),
          _buildSlider(selected, singleCount.toDouble(), 0, '单选'),
          _buildSlider(selected, mutiCount.toDouble(), 1, '多选'),
          _buildSlider(selected, judgeCount.toDouble(), 2, '判断'),
          _buildSlider(selected, fillCount.toDouble(), 3, '填空'),
        ],
      ),
    );
  }

  Widget _buildSlider(bool selected, double max, int idx, String typeChinese) {
    if (max == 0) {
      return SizedBox();
    }
    return Column(
      children: [
        SizedBox(
          width: _media.size.width,
          child: NeuText(
            text: '$typeChinese x ${_tiCount[idx].toInt()}',
            align: TextAlign.start,
          ),
        ),
        NeumorphicSlider(
          max: selected ? max : 0,
          value: _tiCount[idx],
          min: 0,
          thumb: NeuBtn(
            child: SizedBox(
              width: 13,
            ),
            boxShape: NeumorphicBoxShape.circle(),
            onTap: () {},
          ),
          onChanged: (val) => setState(() => _tiCount[idx] = val),
        )
      ],
    );
  }

  Widget _buildStart() {
    return NeuBtn(
        padding: EdgeInsets.zero,
        onTap: () {
          if (_selectedCourse == null) {
            showSnackBar(context, Text('请选择科目'));
          } else {
            if (_tiCount.every((element) => element == 0)) {
              showSnackBar(context, Text('题目总数不得等于0'));
            } else {}
          }
        },
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: _media.padding.bottom,
            ),
            child: Center(
              child: NeuText(
                text: '开始！',
                textStyle: titleStyle,
              ),
            ),
          ),
          width: _media.size.width,
          height: _media.size.height * 0.06 + _media.padding.bottom,
        ));
  }
}

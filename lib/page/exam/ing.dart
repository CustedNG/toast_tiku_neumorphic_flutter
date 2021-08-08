import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/core/extension/ti.dart';
import 'package:toast_tiku/data/provider/exam.dart';
import 'package:toast_tiku/data/provider/timer.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/page/exam/result.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/center_loading.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class ExamingPage extends StatefulWidget {
  const ExamingPage({
    Key? key,
  }) : super(key: key);

  @override
  _ExamingPageState createState() => _ExamingPageState();
}

class _ExamingPageState extends State<ExamingPage>
    with SingleTickerProviderStateMixin {
  late final MediaQueryData _media;
  late List<Ti> _tis = [];
  late int _index;
  late List<List<int>> _checkState = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  late final SnappingSheetController _sheetController;
  late double _bottomHeight;
  bool isBusy = true;
  bool _submittedAnswer = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _sheetController = SnappingSheetController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 377),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _bottomHeight = _media.size.height * 0.08 + _media.padding.bottom;
    _index = 0;
  }

  @override
  void dispose() {
    super.dispose();
    locator<TimerProvider>().stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Consumer<ExamProvider>(
        builder: (_, exam, __) {
          if (exam.isBusy) {
            return centerLoading;
          }
          if (_tis.isEmpty) _tis = exam.result;
          if (_checkState.isEmpty)
            _checkState = List.generate(_tis.length, (_) => []);
          if (_tis.isEmpty) {
            return Center(
              child: NeuText(
                text: '题库为空，发生未知错误',
              ),
            );
          }
          return SnappingSheet(
            controller: _sheetController,
            child: _buildMain(),
            grabbing: _buildGrab(),
            grabbingHeight: _bottomHeight,
            sheetBelow: _buildSheet(),
          );
        },
      ),
    );
  }

  Widget _buildMain() {
    return GestureDetector(
      onHorizontalDragEnd: (detail) =>
          onSlide(detail.velocity.pixelsPerSecond.dx > 100),
      child: Column(
        children: [
          _buildHead(),
          _buildProgress(),
          SizedBox(
            height: _media.size.height * 0.84 - _bottomHeight,
            child: ListView(
              children: [_buildTiList(), _buildAnswer()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrab() {
    return Neumorphic(
        style: NeumorphicStyle(
            lightSource: LightSource.bottom,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                topLeft: Radius.circular(17), topRight: Radius.circular(17)))),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: _media.padding.bottom),
            child: Neumorphic(
              curve: Curves.easeInQuad,
              child: SizedBox(height: 10, width: 57),
              style: NeumorphicStyle(color: mainColor, depth: 37),
            ),
          ),
        ));
  }

  SnappingSheetContent _buildSheet() {
    return SnappingSheetContent(
      child: Container(
        child: Text('1'),
        color: NeumorphicTheme.baseColor(context),
      ),
    );
  }

  Widget _buildProgress() {
    return NeumorphicProgress(
      percent: (_index + 1) / _tis.length,
      height: 2,
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
            SizedBox(
              width: _media.size.width * 0.5,
              child: Consumer<TimerProvider>(
                builder: (_, timer, __) {
                  if (timer.finish) {
                    _submittedAnswer = true;
                  }
                  return NeuText(text: timer.leftTime);
                },
              ),
            ),
            NeuBtn(
              child: _submittedAnswer
                  ? NeumorphicIcon(
                      Icons.celebration,
                      style: NeumorphicStyle(color: mainColor),
                    )
                  : NeuText(text: '交卷'),
              onTap: () {
                if (!_submittedAnswer) {
                  showSnackBar(context, Text('交卷'));
                  setState(() {
                    _submittedAnswer = true;
                  });
                } else {
                  int correctCount = 0;
                  for (int idx = 0; idx < _tis.length; idx++) {
                    if (_tis[idx].answer!.every((element) => _checkState[idx].contains(element))) correctCount++;
                  }
                  AppRoute(ExamResultPage(
                    percent: correctCount / _tis.length * 100,
                  )).go(context);
                }
              },
            )
          ],
        ));
  }

  Widget _buildTiList() {
    _controller.forward();
    return FadeTransition(
        opacity: _animation, child: _buildTiView(_tis[_index]));
  }

  void onSlide(bool left) {
    if (left) {
      if (_index > 0) {
        _index--;
      } else {
        showSnackBar(context, Text('这是第一道'));
        return;
      }
    } else {
      if (_index < _tis.length - 1) {
        _index++;
      } else {
        showSnackBar(context, Text('这是最后一道'));
        return;
      }
    }
    setState(() {});
    _controller.reset();
    _controller.forward();
  }

  Widget _buildTiView(Ti ti) {
    switch (ti.type) {
      case 0:
      case 1:
      case 3:
        return _buildSelect(ti);
      case 2:
        return _buildFill(ti);
      default:
        return const NeuText(text: '题目解析失败');
    }
  }

  Widget _buildFill(Ti ti) {
    return Padding(
      padding: EdgeInsets.all(_media.size.width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeuText(text: ti.question!, align: TextAlign.start),
          NeuText(text: '\n答案：', align: TextAlign.start),
          ...ti.answer!
              .map((e) => NeuText(text: e, align: TextAlign.start))
              .toList()
        ],
      ),
    );
  }

  Widget _buildSelect(Ti ti) {
    return Padding(
      padding: EdgeInsets.all(_media.size.width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeuText(text: ti.question!, align: TextAlign.start),
          SizedBox(height: _media.size.height * 0.05),
          ..._buildRadios(ti.options!),
        ],
      ),
    );
  }

  List<Widget> _buildRadios(List<String?> options) {
    final List<Widget> widgets = [];
    var idx = 0;
    for (var option in options) {
      widgets.add(_buildRadio(idx, option!));
      widgets.add(const SizedBox(
        height: 13,
      ));
      idx++;
    }
    return widgets;
  }

  Widget _buildRadio(int value, String content) {
    return NeumorphicButton(
      child: SizedBox(
        width: _media.size.width * 0.98,
        child: NeuText(text: content, align: TextAlign.start),
      ),
      onPressed: () => onPressed(value),
      style: NeumorphicStyle(
          depth: _checkState[_index].contains(value) ? -20 : null),
    );
  }

  void onPressed(int value) {
    if (_submittedAnswer) return;
    if (_checkState[_index].contains(value)) {
      _checkState[_index].remove(value);
    } else {
      final type = _tis[_index].type;
      if (type == 0 || type == 3) _checkState[_index].clear();
      _checkState[_index].add(value);
    }
    setState(() {});
  }

  Widget _buildAnswer() {
    if (!_submittedAnswer) return SizedBox();
    return NeuText(text: _tis[_index].answerStr);
  }
}

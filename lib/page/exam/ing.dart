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
import 'package:toast_tiku/widget/grab_sheet.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';
import 'package:toast_tiku/widget/text_field.dart';

class ExamingPage extends StatefulWidget {
  const ExamingPage({
    Key? key,
  }) : super(key: key);

  @override
  _ExamingPageState createState() => _ExamingPageState();
}

class _ExamingPageState extends State<ExamingPage>
    with SingleTickerProviderStateMixin {
  late MediaQueryData _media;
  late List<Ti> _tis = [];
  late List<List<Object>> _checkState = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  late SnappingSheetController _sheetController;
  late double _bottomHeight;
  int _index = 0;
  bool isBusy = true;
  bool _submittedAnswer = false;
  late TimerProvider _timerProvider;

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
  }

  @override
  void initState() {
    super.initState();
    _timerProvider = locator<TimerProvider>();
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
          if (_checkState.isEmpty) {
            _checkState = List.generate(_tis.length, (_) => []);
          }
          if (_tis.isEmpty) {
            return const Center(
              child: NeuText(
                text: '题库为空，发生未知错误',
              ),
            );
          }
          return GrabSheet(
            sheetController: _sheetController,
            main: _buildMain(),
            tis: _tis,
            checkState: _checkState,
            showColor: _submittedAnswer,
            onTap: (idx) {
              setState(() {
                _index = idx;
              });
              _controller.reset();
              _controller.forward();
            },
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
                  return NeuText(
                    text: _submittedAnswer
                        ? '${timer.leftTime}\n正确率：${(_getCorrectCount() * 100 / _tis.length).toStringAsFixed(1)}%'
                        : timer.leftTime,
                    textStyle: _submittedAnswer
                        ? NeumorphicTextStyle(fontSize: 12)
                        : null,
                  );
                },
              ),
            ),
            NeuBtn(
              child: NeumorphicIcon(
                  _submittedAnswer ? Icons.celebration : Icons.send,
                  style: NeumorphicStyle(color: mainColor.resolve(context))),
              onTap: () {
                if (_submittedAnswer) {
                  AppRoute(ExamResultPage(
                    percent: _getCorrectCount() / _tis.length,
                  )).go(context);
                } else {
                  showSnackBarWithAction(context, '是否确认交卷？交卷后无法撤销', '交卷', () {
                    _submittedAnswer = true;
                    _timerProvider.stop();
                    setState(() {});
                  });
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
        showSnackBar(context, const Text('这是第一道'));
        return;
      }
    } else {
      if (_index < _tis.length - 1) {
        _index++;
      } else {
        showSnackBar(context, const Text('这是最后一道'));
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
    if (_checkState[_index].isEmpty) {
      _checkState[_index] = List.generate(ti.answer!.length, (_) => '');
    }
    final textFields = [];
    for (int answerIdx = 0; answerIdx < ti.answer!.length; answerIdx++) {
      final initValue = _checkState[_index][answerIdx] as String;
      textFields.add(NeuTextField(
        key: UniqueKey(),
        label: '$_index - ${answerIdx + 1}',
        initValue: initValue,
        onChanged: (value) {
          _checkState[_index][answerIdx] = value;
        },
        padding: EdgeInsets.zero,
      ));
    }
    return Padding(
      padding: EdgeInsets.all(_media.size.width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeuText(text: ti.question!, align: TextAlign.start),
          const SizedBox(
            height: 17,
          ),
          ...textFields
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
          color: _submittedAnswer ? judgeColor(value) : null,
          depth: _checkState[_index].contains(value) ? -20 : null),
    );
  }

  Color? judgeColor(int value) {
    if (_checkState[_index].contains(value)) {
      if (!_tis[_index].answer!.contains(value)) return Colors.redAccent;
      return Colors.greenAccent;
    }
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

  int _getCorrectCount() {
    int correctCount = 0;
    for (int idx = 0; idx < _tis.length; idx++) {
      if (_tis[idx]
          .answer!
          .every((element) => _checkState[idx].contains(element))) {
        correctCount++;
      }
    }
    return correctCount;
  }

  Widget _buildAnswer() {
    if (!_submittedAnswer) return const SizedBox();
    return NeuText(text: _tis[_index].answerStr);
  }
}

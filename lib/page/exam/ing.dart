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
import 'package:toast_tiku/widget/neu_text_field.dart';

/// 正在进行考试时的页面
class ExamingPage extends StatefulWidget {
  const ExamingPage({
    Key? key,
  }) : super(key: key);

  @override
  _ExamingPageState createState() => _ExamingPageState();
}

/// with [SingleTickerProviderStateMixin]，融合了一个ticker provider
/// with的语法参考：https://dart.cn/samples#mixins
class _ExamingPageState extends State<ExamingPage>
    with SingleTickerProviderStateMixin {
  /// 设备Media数据
  late MediaQueryData _media;

  /// 当前所加载的所有题目
  late List<Ti> _tis = [];

  /// 用户对每道题的选项做出的选择的数据
  late List<List<Object>> _checkState = [];

  /// 题目渐显渐隐动画控制器
  late AnimationController _controller;

  /// 题目渐显渐隐动画
  late Animation<double> _animation;

  /// 底部SnapSheet视图控制器
  late SnappingSheetController _sheetController;

  /// 底部高度
  late double _bottomHeight;

  /// 题目的index
  int _index = 0;

  /// 是否已经交卷，结束考试
  bool _submittedAnswer = false;

  /// 考试计时器Provider
  late TimerProvider _timerProvider;

  /// 此覆写，详解请看Flutter生命周期
  /// 例如：https://juejin.cn/post/6844903874617147399
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _bottomHeight = _media.size.height * 0.08 + _media.padding.bottom;
  }

  /// 同上[didChangeDependencies]的注释
  @override
  void initState() {
    super.initState();
    _timerProvider = locator<TimerProvider>();
    _sheetController = SnappingSheetController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 377),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  /// 同上[didChangeDependencies]的注释
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),

      /// 可以通过[Consumer<T>()]获取到需要的Provider
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
      /// 传入参数[左右滑动的速度超过每秒钟277像素]
      onHorizontalDragEnd: (detail) => onSlide(
          detail.velocity.pixelsPerSecond.dx > 277,
          detail.velocity.pixelsPerSecond.dx < -277),
      child: Column(
        children: [
          _buildHead(),
          _buildProgress(),
          SizedBox(
            height: _media.size.height * 0.844 - _bottomHeight,
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
                  style:
                      NeumorphicStyle(color: mainTextColor.resolve(context))),
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
    /// 动画执行，渐显效果
    _controller.forward();
    return FadeTransition(
        opacity: _animation, child: _buildTiView(_tis[_index]));
  }

  /// 滑动切换题目的逻辑判断
  void onSlide(bool left, bool right) {
    if (!left && !right) return;
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

    /// 动画重新执行，题目切换不会突兀
    _controller.reset();
    _controller.forward();
  }

  /// 根据不同题目类型返回不同view
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

  /// 构建填空题view
  Widget _buildFill(Ti ti) {
    if (_checkState[_index].isEmpty) {
      _checkState[_index] = List.generate(ti.answer!.length, (_) => '');
    }
    final textFields = [];
    for (int answerIdx = 0; answerIdx < ti.answer!.length; answerIdx++) {
      final initValue = _checkState[_index][answerIdx] as String;
      final id = '$_index - ${answerIdx + 1}';
      textFields.add(NeuTextField(
        key: Key(id),
        label: id,
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
          NeuText(
            text: ti.typeChinese + '\n',
            align: TextAlign.start,
            textStyle: NeumorphicTextStyle(fontWeight: FontWeight.bold),
          ),
          NeuText(text: ti.question!, align: TextAlign.start),
          const SizedBox(
            height: 17,
          ),
          ...textFields
        ],
      ),
    );
  }

  /// 构建选择题view
  Widget _buildSelect(Ti ti) {
    return Padding(
      padding: EdgeInsets.all(_media.size.width * 0.07),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NeuText(
            text: ti.typeChinese + '\n',
            align: TextAlign.start,
            textStyle: NeumorphicTextStyle(fontWeight: FontWeight.bold),
          ),
          NeuText(text: ti.question!, align: TextAlign.start),
          SizedBox(height: _media.size.height * 0.05),
          ..._buildRadios(ti.options!),
        ],
      ),
    );
  }

  /// 构建选择题具体的所有选项
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

  /// 构建选择题具体的单个选项
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

  /// 判断是否显示颜色，（根据对错）显示什么颜色
  Color? judgeColor(int value) {
    if (_checkState[_index].contains(value)) {
      if (!_tis[_index].answer!.contains(value)) return Colors.redAccent;
      return Colors.greenAccent;
    }
  }

  /// 按下单个选项时，进行的操作
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

  /// 获取答对的题目的数量
  int _getCorrectCount() {
    int correctCount = 0;
    for (int idx = 0; idx < _tis.length; idx++) {
      /// 要求包含每个选项
      if (_tis[idx]
          .answer!
          .every((element) => _checkState[idx].contains(element))) {
        correctCount++;
      }
    }
    return correctCount;
  }

  /// 构建答案视图
  Widget _buildAnswer() {
    if (!_submittedAnswer) return const SizedBox();
    return NeuText(text: _tis[_index].answerStr);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/core/extension/ti.dart';
import 'package:toast_tiku/data/provider/exam.dart';
import 'package:toast_tiku/data/provider/timer.dart';
import 'package:toast_tiku/data/store/exam_history.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/check_state.dart';
import 'package:toast_tiku/model/exam_history.dart';
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
  final String subject;
  final String subjectId;
  const ExamingPage({
    Key? key,
    required this.subject,
    required this.subjectId,
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
  late CheckState _checkState;

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

  /// [单选数量，多选数量，填空数量，判断数量]
  late List<int> _eachTypeTiCount;

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
    _checkState = CheckState.empty();
  }

  /// 同上[didChangeDependencies]的注释
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: NeumorphicTheme.baseColor(context),

          /// 可以通过[Consumer<T>()]获取到需要的Provider
          body: Consumer<ExamProvider>(
            builder: (_, exam, __) {
              if (exam.isBusy) {
                return centerLoading;
              }
              if (_tis.isEmpty) _tis = exam.result;
              if (_checkState.isEmpty) {
                _checkState = CheckState.empty();
              }
              _eachTypeTiCount = [
                _tis.where((element) => element.type == 0).length,
                _tis.where((element) => element.type == 1).length,
                _tis.where((element) => element.type == 2).length,
                _tis.where((element) => element.type == 3).length
              ];
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
        ),
        onWillPop: () async => await _onWillPop() ?? false);
  }

  int typeIdx(Ti ti, int index) {
    switch (ti.type) {
      case 0:
        return index;
      case 1:
        return index - _eachTypeTiCount[0];
      case 2:
        return index - _eachTypeTiCount[0] - _eachTypeTiCount[1];
      case 3:
        return index -
            _eachTypeTiCount[0] -
            _eachTypeTiCount[1] -
            _eachTypeTiCount[2];
      default:
        return 0;
    }
  }

  double get correctRate => _getCorrectCount() * 100 / _tis.length;

  Future<bool?> _onWillPop() async {
    if (_submittedAnswer) {
      return true;
    }
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: NeumorphicTheme.baseColor(context),
        title: NeuText(
          text: '确定要退出考试吗？',
          textStyle: NeumorphicTextStyle(
            fontWeight: FontWeight.w500,
          ),
          align: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
            color: primaryColor,
            icon: const Icon(Icons.done),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          IconButton(
            color: primaryColor,
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
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
              onTap: () async {
                final back = await _onWillPop();
                if (back == true) {
                  Navigator.of(context).pop();
                }
              },
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
                        ? '${timer.leftTime}\n正确率：${correctRate.toStringAsFixed(1)}%'
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
                    locator<ExamHistoryStore>().add(ExamHistory(
                        _tis,
                        _checkState,
                        DateTime.now().toString(),
                        correctRate,
                        widget.subject,
                        widget.subjectId));
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

    final ti = _tis[_index];
    final children = _buildTiView(ti);
    children.insert(
        0,
        NeuText(
          text: '${typeIdx(ti, _index) + 1}.${ti.typeChinese}\n',
          align: TextAlign.start,
          textStyle: NeumorphicTextStyle(fontWeight: FontWeight.bold),
        ));

    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: EdgeInsets.all(_media.size.width * 0.07),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children),
      ),
    );
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
  List<Widget> _buildTiView(Ti ti) {
    switch (ti.type) {
      case 0:
      case 1:
      case 3:
        return _buildSelect(ti);
      case 2:
        return _buildFill(ti);
      default:
        return const [NeuText(text: '题目解析失败')];
    }
  }

  /// 构建填空题view
  List<Widget> _buildFill(Ti ti) {
    if (_nowState.isEmpty) {
      _checkState.update(_nowHash, List.generate(ti.answer!.length, (_) => ''));
    }
    final textFields = [];
    for (int answerIdx = 0; answerIdx < ti.answer!.length; answerIdx++) {
      final initValue = _nowState[answerIdx] as String;
      final id = '$_index - ${answerIdx + 1}';
      textFields.add(NeuTextField(
        key: Key(id),
        label: id,
        initValue: initValue,
        onChanged: (value) {
          _nowState[answerIdx] = value;
        },
        padding: EdgeInsets.zero,
      ));
    }
    return [
      NeuText(text: ti.question!, align: TextAlign.start),
      const SizedBox(
        height: 17,
      ),
      ...textFields
    ];
  }

  /// 构建选择题view
  List<Widget> _buildSelect(Ti ti) {
    return [
      NeuText(text: ti.question!, align: TextAlign.start),
      SizedBox(height: _media.size.height * 0.05),
      ..._buildRadios(ti.options),
    ];
  }

  /// 构建选择题具体的所有选项
  List<Widget> _buildRadios(List<String?>? options) {
    final List<Widget> widgets = [];
    var idx = 0;
    if (options == null) {
      widgets.add(_buildRadio(0, '是'));
      widgets.add(const SizedBox(
        height: 13,
      ));
      widgets.add(_buildRadio(1, '否'));
      return widgets;
    }
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
          depth: _nowState.contains(value) ? -20 : null),
    );
  }

  /// 判断是否显示颜色，（根据对错）显示什么颜色
  Color? judgeColor(int value) {
    if (_nowState.contains(value)) {
      if (!_tis[_index].answer!.contains(value)) return Colors.redAccent;
      return Colors.greenAccent;
    }
  }

  /// 按下单个选项时，进行的操作
  void onPressed(int value) {
    if (_submittedAnswer) return;
    if (_nowState.contains(value)) {
      _checkState.delete(_nowHash, value);
    } else {
      final type = _tis[_index].type;
      if (type == 0 || type == 3) _nowState.clear();
      _checkState.add(_nowHash, value);
    }
    setState(() {});
  }

  /// 获取答对的题目的数量
  int _getCorrectCount() {
    int correctCount = 0;
    for (int idx = 0; idx < _tis.length; idx++) {
      final ti = _tis[idx];
      /// 要求包含每个选项
      if (ti
          .answer!
          .every((element) => _checkState.get(ti.id).contains(element))) {
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

  String get _nowHash => _tis[_index].id;
  List<Object> get _nowState => _checkState.get(_nowHash);
}

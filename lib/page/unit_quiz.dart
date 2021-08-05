import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class UnitQuizPage extends StatefulWidget {
  final String courseId;
  final String unitFile;
  final String unitName;
  const UnitQuizPage({
    Key? key,
    required this.courseId,
    required this.unitFile,
    required this.unitName,
  }) : super(key: key);

  @override
  _UnitQuizPageState createState() => _UnitQuizPageState();
}

class _UnitQuizPageState extends State<UnitQuizPage>
    with SingleTickerProviderStateMixin {
  late final MediaQueryData _media;
  late final TikuStore _store;
  late final List<Ti>? _tis;
  late int _index;
  late final List<List<int>> _checkState;
  late AnimationController _controller;
  late Animation<double> _animation;
  final _titleNeuTextStyle = NeumorphicTextStyle(fontSize: 12);
  late final SnappingSheetController _sheetController;
  late double _bottomHeight;

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
    _bottomHeight = _media.size.height * 0.05 + _media.padding.bottom;
    _store = locator<TikuStore>();
    _tis = _store.fetch(widget.courseId, widget.unitFile);
    _index = 0;
    _checkState = List.generate(_tis!.length, (_) => []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SnappingSheet(
        controller: _sheetController,
        child: _buildMain(),
        grabbing: _buildGrab(),
        grabbingHeight: _bottomHeight,
        sheetBelow: _buildSheet(),
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
          _buildTiList(),
          SizedBox(
            height: _bottomHeight,
          )
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
              child: SizedBox(height: 11, width: 57),
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
            Container(
              width: _media.size.width * 0.5,
              child: Column(
                children: [
                  NeuText(text: widget.unitName, textStyle: _titleNeuTextStyle),
                  NeuText(
                      text:
                          '${(100 * (_index / _tis!.length)).toStringAsFixed(0)}%',
                      textStyle: _titleNeuTextStyle)
                ],
              ),
            ),
            NeuIconBtn(
              icon: Icons.favorite,
              onTap: () => showSnackBar(context, const Text('star')),
            )
          ],
        ));
  }

  Widget _buildTiList() {
    _controller.forward();
    return Flexible(
      child: FadeTransition(
          opacity: _animation, child: _buildTiView(_tis![_index])),
    );
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
      if (_index < _tis!.length) {
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
    return Column(
      children: [
        NeuText(text: ti.question!),
        ...ti.answer!.map((e) => NeuText(text: e)).toList()
      ],
    );
  }

  Widget _buildSelect(Ti ti) {
    return Padding(
      padding: EdgeInsets.all(_media.size.width * 0.07),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: NeuText(text: ti.question!, align: TextAlign.start),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildRadios(ti.options!),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRadios(List<String?> options) {
    final List<Widget> widgets = [];
    var idx = 0;
    for (var option in options) {
      widgets.add(_buildRadio(idx, option!));
      widgets.add(SizedBox(
        height: 13,
      ));
      idx++;
    }
    return widgets;
  }

  Widget _buildRadio(int value, String content) {
    return NeumorphicButton(
      child: Container(
        width: _media.size.width * 0.98,
        child: NeuText(text: content, align: TextAlign.start),
      ),
      onPressed: () => onPressed(value),
      style: NeumorphicStyle(
          color: judgeColor(value),
          depth: _checkState[_index].contains(value) ? -20 : null),
    );
  }

  Color? judgeColor(int value) {
    if (_checkState[_index].contains(value)) {
      if (!_tis![_index].answer!.contains(value)) return Colors.redAccent;
      return Colors.greenAccent;
    }
  }

  void onPressed(int value) {
    if (_checkState[_index].contains(value)) {
      _checkState[_index].remove(value);
    } else {
      _checkState[_index].add(value);
    }
    setState(() {});
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class UnitQuizPage extends StatefulWidget {
  final String courseId;
  final String unitFile;
  const UnitQuizPage({
    Key? key,
    required this.courseId,
    required this.unitFile,
  }) : super(key: key);

  @override
  _UnitQuizPageState createState() => _UnitQuizPageState();
}

class _UnitQuizPageState extends State<UnitQuizPage> {
  late final MediaQueryData _media;
  late final TikuStore _store;
  late final List<Ti>? _tis;
  late int _index;
  late final List<List<String>> _checkState;
  late List<String> _checkStateCurrent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _store = locator<TikuStore>();
    _tis = _store.fetch(widget.courseId, widget.unitFile);
    _index = 0;
    _checkState = List.filled(_tis!.length, []);
    _checkStateCurrent = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildHead(),
          _buildTiList(),
        ],
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
            NeuText(text: '${(_index / _tis!.length).toStringAsPrecision(1)}%'),
            NeuIconBtn(
              icon: Icons.favorite,
              onTap: () => showSnackBar(context, const Text('star')),
            )
          ],
        ));
  }

  Widget _buildTiList() {
    return GestureDetector(
      onHorizontalDragEnd: (updateDetail) {
        onSlide(updateDetail.velocity.pixelsPerSecond.dx > 100);
      },
      child: _buildTiView(_tis![_index]),
    );
  }

  void onSlide(bool left) {
    _checkState[_index] = _checkStateCurrent;
    left ? (_index > 0 ?_index-- : null) : (_index < _tis!.length ? _index++ : null);
    _checkStateCurrent = _checkState[_index];
    setState(() {});
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        NeuCard(child: NeuText(text: ti.question!, align: TextAlign.start)),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buildRadios(ti.options!),
        ),
      ],
    );
  }

  List<Widget> _buildRadios(List<String?> options) {
    final List<Widget> widgets = [];
    var idx = 0;
    for (var option in options) {
      widgets.add(_buildRadio(String.fromCharCode(65 + idx), option!));
      idx++;
    }
    return widgets;
  }

  Widget _buildRadio(String value, String content) {
    return NeumorphicButton(
      child: NeuText(text: content, align: TextAlign.start),
      onPressed: () => onPressed(value),
      style: NeumorphicStyle(
          depth: _checkStateCurrent.contains(value) ? -10 : null),
    );
  }

  void onPressed(String value) {
    if (_checkStateCurrent.contains(value)) {
      _checkStateCurrent.remove(value);
    } else {
      _checkStateCurrent.add(value);
    }
    setState(() {});
  }
}

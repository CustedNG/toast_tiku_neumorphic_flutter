import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/history.dart';
import 'package:toast_tiku/data/store/favorite.dart';
import 'package:toast_tiku/data/store/history.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/center_loading.dart';
import 'package:toast_tiku/widget/grab_sheet.dart';
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
  late MediaQueryData _media;
  late TikuStore _tikuStore;
  late FavoriteStore _favoriteStore;
  late HistoryStore _historyStore;
  late HistoryProvider _historyProvider;
  late List<Ti>? _tis;
  late int _index;
  late List<List<int>> _checkState;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late SnappingSheetController _sheetController;

  late double _bottomHeight;
  late List<int> _historyIdx;

  @override
  void initState() {
    super.initState();
    _sheetController = SnappingSheetController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 377),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
    _tikuStore = locator<TikuStore>();
    _favoriteStore = locator<FavoriteStore>();
    _historyStore = locator<HistoryStore>();
    _historyProvider = context.read<HistoryProvider>();
    _tis = _tikuStore.fetch(widget.courseId, widget.unitFile);
    _index = 0;
    _checkState = List.generate(_tis!.length, (_) => []);
    _historyIdx = _historyStore.fetch(widget.courseId, widget.unitFile);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _bottomHeight = _media.size.height * 0.08 + _media.padding.bottom;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_tis == null || _tis!.isEmpty) {
      child = centerLoading;
    } else {
      child = GrabSheet(
        showColor: true,
        sheetController: _sheetController,
        main: _buildMain(),
        tis: _tis!,
        checkState: _checkState,
        onTap: (idx) {
          setState(() {
            _index = idx;
          });
          _animationController.reset();
          _animationController.forward();
        },
      );
    }
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: child,
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
              children: [
                _buildTiList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return NeumorphicProgress(
      percent: (_index + 1) / _tis!.length,
      height: 2,
    );
  }

  Widget _buildHead() {
    final ti = _tis![_index];
    bool have = _favoriteStore.have(widget.courseId, ti);
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
              child: NeuText(text: widget.unitName),
            ),
            NeuIconBtn(
              icon: have ? Icons.favorite : Icons.favorite_border,
              onTap: () {
                if (have) {
                  _favoriteStore.delete(widget.courseId, ti);
                  showSnackBar(context, const Text('已取消收藏'));
                } else {
                  _favoriteStore.put(widget.courseId, ti);
                  showSnackBar(context, const Text('已收藏'));
                }
                setState(() {});
              },
            )
          ],
        ));
  }

  Widget _buildTiList() {
    _animationController.forward();
    return FadeTransition(
        opacity: _animation, child: _buildTiView(_tis![_index]));
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
      if (_index < _tis!.length - 1) {
        _index++;
      } else {
        showSnackBar(context, const Text('这是最后一道'));
        return;
      }
    }
    setState(() {});
    _animationController.reset();
    _animationController.forward();
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
          const NeuText(text: '\n答案：', align: TextAlign.start),
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
    _historyProvider.setLastViewed(widget.courseId, widget.unitFile);
    if (!_historyIdx.contains(_index)) {
      _historyIdx.add(_index);
    }
    if (_checkState[_index].contains(value)) {
      _checkState[_index].remove(value);
    } else {
      final type = _tis![_index].type;
      if (type == 0 || type == 3) _checkState[_index].clear();
      _checkState[_index].add(value);
    }
    _historyStore.put(widget.courseId, widget.unitFile, _historyIdx);
    setState(() {});
  }
}

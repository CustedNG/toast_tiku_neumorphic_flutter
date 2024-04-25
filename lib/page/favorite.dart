import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../core/extension/ti.dart';
import '../core/utils.dart';
import '../data/store/favorite.dart';
import '../data/store/setting.dart';
import '../locator.dart';
import '../model/check_state.dart';
import '../model/ti.dart';
import '../widget/app_bar.dart';
import '../widget/grab_sheet.dart';
import '../widget/neu_btn.dart';
import '../widget/neu_text.dart';

/// 单元收藏题目页
class UnitFavoritePage extends StatefulWidget {
  final String courseId;
  final String courseName;
  const UnitFavoritePage({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  State<UnitFavoritePage> createState() => _UnitFavoritePageState();
}

class _UnitFavoritePageState extends State<UnitFavoritePage>
    with SingleTickerProviderStateMixin {
  /// 注释内容大致与[ing.dart]文件相似，请跳转查看
  late MediaQueryData _media;
  late FavoriteStore _favoriteStore;
  late SettingStore _settingStore;
  late List<Ti>? _tis;
  late int _index;
  late CheckState _checkState;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late SnappingSheetController _sheetController;
  late double _bottomHeight;
  late bool _autoSlide2NextWhenCorrect;

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
    _favoriteStore = locator<FavoriteStore>();
    _settingStore = locator<SettingStore>();
    _tis = _favoriteStore.fetch(widget.courseId);
    _autoSlide2NextWhenCorrect =
        _settingStore.autoSlide2NextWhenCorrect.fetch()!;
    _index = 0;
    _checkState = CheckState.empty();
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
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: _media.size.width),
          NeuText(text: '${widget.courseName}没有收藏的题目'),
          SizedBox(height: _media.size.height * 0.3),
          NeuIconBtn(
            icon: Icons.arrow_back,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      );
    } else {
      child = GrabSheet(
          showColor: true,
          sheetController: _sheetController,
          main: _buildMain(),
          checkState: _checkState,
          tis: _tis!,
          onTap: (idx) {
            setState(() {
              _index = idx;
            });
            _animationController.reset();
            _animationController.forward();
          },);
    }
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: child,
    );
  }

  Widget _buildMain() {
    return GestureDetector(
      onHorizontalDragEnd: (detail) => onSlide(
          detail.velocity.pixelsPerSecond.dx > 277,
          detail.velocity.pixelsPerSecond.dx < -277,),
      child: Column(
        children: [
          _buildHead(),
          SizedBox(
            height: _media.size.height * 0.84 - _bottomHeight,
            child: SingleChildScrollView(
              child: _buildTiList(),
            ),
          ),
        ],
      ),
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
              child: NeuText(text: '${widget.courseName}&收藏'),
            ),
            NeuIconBtn(
              icon: have ? Icons.favorite : Icons.favorite_border,
              onTap: () {
                if (have) {
                  _favoriteStore.delete(widget.courseId, ti);
                } else {
                  _favoriteStore.put(widget.courseId, ti);
                }
                setState(() {});
              },
            ),
          ],
        ),);
  }

  Widget _buildTiList() {
    _animationController.forward();
    return FadeTransition(
        opacity: _animation, child: _buildTiView(_tis![_index]),);
  }

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
          ...ti.answer!.map((e) => NeuText(text: e, align: TextAlign.start)),
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
          NeuText(
            text: '${_index + 1}.${ti.typeChinese}\n',
            align: TextAlign.start,
            textStyle: NeumorphicTextStyle(fontWeight: FontWeight.bold),
          ),
          NeuText(text: ti.question!, align: TextAlign.start),
          SizedBox(height: _media.size.height * 0.05),
          ..._buildRadios(ti.options),
        ],
      ),
    );
  }

  List<Widget> _buildRadios(List<String?>? options) {
    final List<Widget> widgets = [];
    var idx = 0;
    if (options == null) {
      widgets.add(_buildRadio(0, '是'));
      widgets.add(const SizedBox(
        height: 13,
      ),);
      widgets.add(_buildRadio(1, '否'));
      return widgets;
    }
    for (var option in options) {
      widgets.add(_buildRadio(idx, option!));
      widgets.add(const SizedBox(
        height: 13,
      ),);
      idx++;
    }
    return widgets;
  }

  Widget _buildRadio(int value, String content) {
    return NeumorphicButton(
      onPressed: () => onPressed(value),
      style: NeumorphicStyle(
          color: judgeColor(value),
          depth: _nowState.contains(value) ? -20 : null,),
      child: SizedBox(
        width: _media.size.width * 0.98,
        child: NeuText(text: content, align: TextAlign.start),
      ),
    );
  }

  Color? judgeColor(int value) {
    if (_settingStore.directlyShowAnswer.fetch()!) {
      return _tis![_index].answer!.contains(value) ? Colors.greenAccent : null;
    }

    if (_nowState.contains(value)) {
      if (!_tis![_index].answer!.contains(value)) return Colors.redAccent;
      return Colors.greenAccent;
    }
    if (_tis![_index].answer!.contains(value) &&
        _nowState.length >= _tis![_index].answer!.length &&
        _settingStore.autoDisplayAnswer.fetch()!) {
      return Colors.greenAccent;
    }
    return null;
  }

  void onPressed(int value) {
    if (_settingStore.directlyShowAnswer.fetch()!) {
      return;
    }

    if (_nowState.contains(value)) {
      _checkState.delete(_nowHash, value);
    } else {
      final type = _tis![_index].type;
      if (type == 0 || type == 3) _checkState.clear(_nowHash);
      _checkState.add(_nowHash, value);
    }
    setState(() {});

    /// 答对自动跳转下一题
    Future.delayed(const Duration(milliseconds: 377), () {
      if (_nowState
              .every((element) => _tis![_index].answer!.contains(element)) &&
          _autoSlide2NextWhenCorrect &&
          _nowState.length == _tis![_index].answer!.length) {
        onSlide(false, true);
      }
    });
  }

  String get _nowHash => _tis![_index].id;
  List<Object> get _nowState => _checkState.get(_nowHash);
}

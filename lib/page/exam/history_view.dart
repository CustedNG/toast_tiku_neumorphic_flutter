import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:toast_tiku/core/extension/ti.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/store/favorite.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/exam_history.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/grab_sheet.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class ExamHistoryViewPage extends StatefulWidget {
  final ExamHistory examHistory;
  const ExamHistoryViewPage({Key? key, required this.examHistory})
      : super(key: key);

  @override
  _ExamHistoryViewPageState createState() => _ExamHistoryViewPageState();
}

class _ExamHistoryViewPageState extends State<ExamHistoryViewPage>
    with SingleTickerProviderStateMixin {
  late MediaQueryData _media;
  int _index = 0;
  late FavoriteStore _favoriteStore;

  /// [单选数量，多选数量，填空数量，判断数量]
  late List<int> _eachTypeTiCount;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late SnappingSheetController _sheetController;

  late double _bottomHeight;

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
    _eachTypeTiCount = [
      widget.examHistory.tis.where((element) => element.type == 0).length,
      widget.examHistory.tis.where((element) => element.type == 1).length,
      widget.examHistory.tis.where((element) => element.type == 2).length,
      widget.examHistory.tis.where((element) => element.type == 3).length
    ];
    _favoriteStore = locator<FavoriteStore>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _bottomHeight = _media.size.height * 0.08 + _media.padding.bottom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: GrabSheet(
        showColor: true,
        sheetController: _sheetController,
        main: _buildMain(),
        tis: widget.examHistory.tis,
        checkState: widget.examHistory.checkState,
        onTap: (idx) {
          setState(() {
            _index = idx;
          });
          _animationController.reset();
          _animationController.forward();
        },
      ),
    );
  }

  Widget _buildMain() {
    return GestureDetector(
      onHorizontalDragEnd: (detail) => onSlide(
          detail.velocity.pixelsPerSecond.dx > 277,
          detail.velocity.pixelsPerSecond.dx < -277),
      child: Column(
        children: [
          _buildHead(),
          _buildProgress(),
          SizedBox(
            height: _media.size.height * 0.84 - _bottomHeight,
            child: SingleChildScrollView(
              child: SizedBox(
                width: _media.size.width,
                child: _buildTiList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return NeumorphicProgress(
      percent: (_index + 1) / widget.examHistory.tis.length,
      height: 2,
    );
  }

  Widget _buildHead() {
    final ti = widget.examHistory.tis[_index];
    final id = widget.examHistory.subjectId;
    bool have = _favoriteStore.have(
      id, ti
    );
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
              child: NeuText(text: widget.examHistory.subject),
            ),
            NeuIconBtn(
              icon: have ? Icons.favorite : Icons.favorite_border,
              onTap: () {
                if (have) {
                  _favoriteStore.delete(id, ti);
                } else {
                  _favoriteStore.put(id, ti);
                }
                setState(() {});
              },
            )
          ],
        ));
  }

  Widget _buildTiList() {
    _animationController.forward();

    final ti = widget.examHistory.tis[_index];
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
      if (_index < widget.examHistory.tis.length - 1) {
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

  List<Widget> _buildFill(Ti ti) {
    return [
      NeuText(text: ti.question!, align: TextAlign.start),
      const NeuText(text: '\n答案：', align: TextAlign.start),
      ...ti.answer!
          .map((e) => NeuText(text: e, align: TextAlign.start))
          .toList()
    ];
  }

  List<Widget> _buildSelect(Ti ti) {
    return [
      NeuText(text: ti.question!, align: TextAlign.start),
      SizedBox(height: _media.size.height * 0.05),
      ..._buildRadios(ti.options),
    ];
  }

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

  Widget _buildRadio(int value, String content) {
    return NeumorphicButton(
      child: SizedBox(
        width: _media.size.width * 0.98,
        child: NeuText(text: content, align: TextAlign.start),
      ),
      onPressed: () {},
      style: NeumorphicStyle(
          color: judgeColor(value),
          depth: widget.examHistory.checkState[_index].contains(value)
              ? -20
              : null),
    );
  }

  Color? judgeColor(int value) {
    if (widget.examHistory.checkState[_index].contains(value)) {
      if (!widget.examHistory.tis[_index].answer!.contains(value)) {
        return Colors.redAccent;
      }
      return Colors.greenAccent;
    }
  }
}

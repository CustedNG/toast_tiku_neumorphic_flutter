import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:toast_tiku/model/check_state.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';

/// 底部上拉菜单实现
class GrabSheet extends StatefulWidget {
  /// Sheet控制器
  final SnappingSheetController sheetController;

  /// 主视图
  final Widget main;

  /// 上拉视图
  final Widget? grab;

  /// 题目
  final List<Ti> tis;

  /// 题目选项状态
  final CheckState checkState;

  /// 点击后的操作
  final void Function(int index) onTap;

  /// 是否显示选择的对错
  final bool showColor;

  const GrabSheet(
      {Key? key,
      required this.sheetController,
      required this.main,
      this.grab,
      required this.tis,
      required this.checkState,
      required this.onTap,
      required this.showColor})
      : super(key: key);

  @override
  _GrabSheetState createState() => _GrabSheetState();
}

class _GrabSheetState extends State<GrabSheet> {
  late MediaQueryData _media;

  late final List<Ti> single;
  late final List<Ti> multiple;
  late final List<Ti> fill;
  late final List<Ti> judge;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
  }

  @override
  void initState() {
    super.initState();
    single = widget.tis.where((element) => element.type == 0).toList();
    multiple = widget.tis.where((element) => element.type == 1).toList();
    fill = widget.tis.where((element) => element.type == 2).toList();
    judge = widget.tis.where((element) => element.type == 3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: widget.sheetController,
      child: widget.main,
      grabbing: widget.grab ?? _buildGrab(),
      grabbingHeight: _media.size.height * 0.08 + _media.padding.bottom,
      sheetBelow: _buildSheet(),
    );
  }

  Widget _buildGrab() {
    return Neumorphic(
        style: NeumorphicStyle(
            lightSource: LightSource.bottom,
            boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.only(
                topLeft: Radius.circular(17), topRight: Radius.circular(17)))),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: _media.padding.bottom),
            child: Neumorphic(
              curve: Curves.easeInQuad,
              child: const SizedBox(height: 10, width: 57),
              style: NeumorphicStyle(
                  color: mainTextColor.resolve(context), depth: 37),
            ),
          ),
        ));
  }

  SnappingSheetContent _buildSheet() {
    return SnappingSheetContent(
        child: Container(
      color: NeumorphicTheme.baseColor(context),
      child: ListView(
        children: [
          _buildEachTypeGrid(0, '单选', single, 0),
          _buildEachTypeGrid(1, '多选', multiple, single.length),
          _buildEachTypeGrid(2, '填空', fill, single.length + multiple.length),
          _buildEachTypeGrid(
              3, '判断', judge, single.length + multiple.length + fill.length),
          const SizedBox(height: 37),
        ],
      ),
    ));
  }

  Widget _buildEachTypeGrid(
      int typeInt, String type, List<Ti> tis, int prefixIdx) {
    if (tis.isEmpty) {
      return const SizedBox();
    }
    return Column(children: [
      const SizedBox(
        height: 7,
      ),
      NeuText(text: type),
      const SizedBox(
        height: 13,
      ),
      GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: _media.size.width * 0.05),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 2),
          itemCount: tis.length,
          itemBuilder: (context, idx) {
            int currentIdx = prefixIdx + idx;
            Ti _ti = widget.tis[currentIdx];
            List<Object> _singleState = widget.checkState.get(_ti.id);
            return Padding(
              padding: const EdgeInsets.all(7),
              child: NeuBtn(
                style:
                    NeumorphicStyle(depth: _singleState.isEmpty ? null : -10),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Container(
                  color: judgeColor(_singleState, _ti),
                  child: Center(child: NeuText(text: (idx + 1).toString())),
                ),
                onTap: () => widget.onTap(currentIdx),
              ),
            );
          })
    ]);
  }

  /// 是否显示颜色
  Color? judgeColor(List<Object> state, Ti ti) {
    if (widget.showColor && state.isNotEmpty) {
      if (ti.answer!.every((element) => state.contains(element)) &&
          ti.answer!.length == state.length) {
        return Colors.greenAccent;
      }
      return Colors.redAccent;
    }
  }
}

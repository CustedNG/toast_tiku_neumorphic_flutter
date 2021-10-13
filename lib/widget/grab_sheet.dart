import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
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
  final List<List<Object>> checkState;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
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
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: _media.size.height * 0.18),
        child: Container(
          color: NeumorphicTheme.baseColor(context),
          child: GridView.builder(
              padding:
                  EdgeInsets.symmetric(horizontal: _media.size.width * 0.05),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 2),
              itemCount: widget.tis.length,
              itemBuilder: (context, idx) {
                return Padding(
                  padding: const EdgeInsets.all(7),
                  child: NeuBtn(
                    style: NeumorphicStyle(
                        depth: widget.checkState[idx].isEmpty ? null : -10),
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Container(
                      color: judgeColor(idx),
                      child: Center(child: NeuText(text: (idx + 1).toString())),
                    ),
                    onTap: () => widget.onTap(idx),
                  ),
                );
              }),
        ),
      ),
    );
  }

  /// 是否显示颜色
  Color? judgeColor(int idx) {
    if (widget.showColor && widget.checkState[idx].isNotEmpty) {
      if (widget.tis[idx].answer!
          .every((element) => widget.checkState[idx].contains(element))) {
        return Colors.greenAccent;
      }
      return Colors.redAccent;
    }
  }
}

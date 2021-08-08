import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class GrabSheet extends StatefulWidget {
  final SnappingSheetController sheetController;
  final Widget main;
  final Widget? grab;
  final List<Ti> tis;
  final List<List<int>> checkState;
  final void Function(int index) onTap;
  const GrabSheet(
      {Key? key,
      required this.sheetController,
      required this.main,
      this.grab,
      required this.tis,
      required this.checkState,
      required this.onTap})
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
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                topLeft: Radius.circular(17), topRight: Radius.circular(17)))),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: _media.padding.bottom),
            child: Neumorphic(
              curve: Curves.easeInQuad,
              child: SizedBox(height: 10, width: 57),
              style: NeumorphicStyle(color: mainColor, depth: 37),
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 2),
              itemCount: widget.tis.length,
              itemBuilder: (context, idx) {
                return Padding(
                  padding: EdgeInsets.all(7),
                  child: NeuBtn(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: NeuText(text: (idx + 1).toString()),
                    ),
                    onTap: () => widget.onTap(idx),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
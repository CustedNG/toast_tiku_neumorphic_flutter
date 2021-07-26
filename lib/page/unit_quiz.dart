import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/data/store/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/ti.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/center_loading.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _store = locator<TikuStore>();
    _tis = getTiList(_store.fetch(widget.courseId, widget.unitFile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHead(),
          _buildSelectCard(),
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
            NeuText(text: ''),
            NeuIconBtn(
              icon: Icons.favorite,
              onTap: () => showSnackBar(context, const Text('star')),
            )
          ],
        ));
  }

  Widget _buildSelectCard() {
    if (_tis == null) {
      return centerLoading;
    }
    return Text(_tis!.length.toString());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/store/history.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/page/course.dart';
import 'package:toast_tiku/page/unit_quiz.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_text.dart';
import 'package:toast_tiku/widget/tiku_update_progress.dart';

class CourseSelectPage extends StatefulWidget {
  final List<TikuIndex> data;
  const CourseSelectPage({Key? key, required this.data}) : super(key: key);

  @override
  _CourseSelectPageState createState() => _CourseSelectPageState();
}

class _CourseSelectPageState extends State<CourseSelectPage> {
  late final MediaQueryData _media;
  late final HistoryStore _historyStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    _historyStore = locator<HistoryStore>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHead(),
          TikuUpdateProgress(),
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
            NeuText(text: '选择科目'),
            SizedBox()
          ],
        ));
  }

  Widget _buildSelectCard() {
    return SizedBox(
        height: _media.size.height * 0.84,
        width: _media.size.width,
        child: ListView.builder(
            itemCount: widget.data.length,
            itemExtent: _media.size.height * 0.2,
            itemBuilder: (ctx, idx) {
              return _buildCardItem(idx);
            }));
  }

  Widget _buildCardItem(int index) {
    final pad = _media.size.height * 0.037;
    final data = widget.data[index];
    return GestureDetector(
      child: NeuCard(
        margin: EdgeInsets.fromLTRB(pad, 0, pad, pad),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NeuText(text: data.chinese!),
            NeuText(text: '共${data.content!.length}章节')
          ],
        ),
      ),
      onTap: () => AppRoute(CoursePage(
        data: data,
      )).go(context),
    );
  }
}

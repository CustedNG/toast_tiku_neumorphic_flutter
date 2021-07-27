import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/page/unit_quiz.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class CoursePage extends StatefulWidget {
  final TikuIndex data;
  const CoursePage({Key? key, required this.data}) : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late final MediaQueryData _media;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
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
            NeuText(text: widget.data.chinese!),
            NeuIconBtn(
              icon: Icons.favorite,
              onTap: () => showSnackBar(context, const Text('star')),
            )
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
    final data = widget.data.content![index];
    final total = data!.radio! + data.radio! + data.radio!;
    return GestureDetector(
      child: NeuCard(
        margin: EdgeInsets.fromLTRB(pad, 0, pad, pad),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NeuText(text: data.title!),
            NeumorphicProgress(
              height: _media.size.height * 0.017,
              percent: 1 / total,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NeuText(text: '选择：${data.radio!}'),
                NeuText(text: '填空：${data.fill!}'),
                NeuText(text: '多选：${data.multiple!}')
              ],
            )
          ],
        ),
      ),
      onTap: () => AppRoute(UnitQuizPage(
        courseId: widget.data.id!, 
        unitFile: data.data!
      )).go(context),
    );
  }
}

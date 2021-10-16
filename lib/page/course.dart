import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/data/store/history.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/page/favorite.dart';
import 'package:toast_tiku/page/unit_quiz.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_text.dart';
import 'package:toast_tiku/widget/tiku_update_progress.dart';

class CoursePage extends StatefulWidget {
  final TikuIndex data;
  const CoursePage({Key? key, required this.data}) : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late MediaQueryData _media;
  late HistoryStore _historyStore;

  @override
  void initState() {
    super.initState();
    _historyStore = locator<HistoryStore>();
  }

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
          const TikuUpdateProgress(),
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
            SizedBox(
                width: _media.size.width * 0.5,
                child: Hero(
                    transitionOnUserGestures: true,
                    tag: 'home_all_course_${widget.data.id}',
                    child: NeuText(text: widget.data.chinese!))),
            NeuIconBtn(
              icon: Icons.favorite,
              onTap: () => AppRoute(UnitFavoritePage(
                courseId: widget.data.id!,
                courseName: widget.data.chinese!,
              )).go(context),
            )
          ],
        ));
  }

  Widget _buildSelectCard() {
    return SizedBox(
        height: _media.size.height * 0.844,
        width: _media.size.width,
        child: ListView.builder(
          itemCount: widget.data.length,
          itemExtent: _media.size.height * 0.2,
          itemBuilder: (BuildContext context, int idx) {
            return _buildCardItem(idx);
          },
        ));
  }

  Widget _buildCardItem(int index) {
    final pad = _media.size.height * 0.037;
    final data = widget.data.content![index];
    final total = data!.radio! + data.radio! + data.radio!;
    final doneTiCount = _historyStore.fetch(widget.data.id!, data.data!).length;
    return GestureDetector(
      child: NeuCard(
        padding: EdgeInsets.fromLTRB(pad, 0, pad, pad),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NeuText(text: data.title!),
            NeumorphicProgress(
              height: _media.size.height * 0.017,
              percent: doneTiCount / total,
              style: ProgressStyle(
                  border: NeumorphicBorder(
                      color: neuProgressColor.resolve(context))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NeuText(text: '选择：${data.radio!}'),
                NeuText(text: '填空：${data.fill!}'),
                NeuText(text: '多选：${data.multiple!}'),
                NeuText(text: '判断：${data.decide!}')
              ],
            )
          ],
        ),
      ),
      onTap: () => AppRoute(UnitQuizPage(
        courseId: widget.data.id!,
        unitFile: data.data!,
        unitName: data.title!,
      )).go(context),
    );
  }
}

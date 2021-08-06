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
            Hero(
                tag: 'home_add_btn',
                child: NeuIconBtn(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.of(context).pop(),
                )),
            NeuText(text: '选择科目'),
            NeuIconBtn(
              icon: Icons.feedback,
              onTap: () => showSnackBar(context, Text('暂未开放反馈')),
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
            itemExtent: _media.size.height * 0.13,
            itemBuilder: (ctx, idx) {
              return _buildCardItem(idx);
            }));
  }

  Widget _buildCardItem(int index) {
    final data = widget.data[index];
    final pad = _media.size.width * 0.06;
    return NeuCard(
      padding: EdgeInsets.only(left: pad, right: pad, bottom: pad),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NeuText(text: data.chinese!, textStyle: NeumorphicTextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),),
              NeuText(text: '共${data.content!.length}章节', textStyle: NeumorphicTextStyle(
                fontSize: 11
              ),)
            ],
          ),
          Row(
            children: [
              NeuIconBtn(
                margin: EdgeInsets.all(3),
                icon: Icons.favorite,
              ),
              NeuIconBtn(
                margin: EdgeInsets.all(3),
                icon: Icons.send,
              )
            ],
          )
        ],
      ),
    );
  }
}

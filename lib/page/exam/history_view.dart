import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/model/exam_history.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class ExamHistoryViewPage extends StatefulWidget {
  final ExamHistory examHistory;
  const ExamHistoryViewPage({Key? key, required this.examHistory})
      : super(key: key);

  @override
  _ExamHistoryViewPageState createState() => _ExamHistoryViewPageState();
}

class _ExamHistoryViewPageState extends State<ExamHistoryViewPage> {
  /// 设备媒体数据
  late MediaQueryData _media;
  late double padding;

  /// 标题文字风格
  final titleStyle =
      NeumorphicTextStyle(fontSize: 17, fontWeight: FontWeight.bold);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    padding = _media.size.height * 0.037;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        children: [_buildHead()],
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
            const NeuText(
              text: '模拟考试',
            ),
            NeuIconBtn(
              icon: Icons.question_answer,
              onTap: () {},
            ),
          ],
        ));
  }
}

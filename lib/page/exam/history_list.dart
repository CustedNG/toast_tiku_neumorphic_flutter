import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/exam_history.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/exam_history.dart';
import 'package:toast_tiku/page/exam/history_view.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/center_loading.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class ExamHistoryListPage extends StatefulWidget {
  const ExamHistoryListPage({Key? key}) : super(key: key);

  @override
  _ExamHistoryListPageState createState() => _ExamHistoryListPageState();
}

class _ExamHistoryListPageState extends State<ExamHistoryListPage> {
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
        children: [_buildHead(), _buildMain()],
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
              text: '考试记录',
            ),
            NeuIconBtn(
              icon: Icons.question_answer,
              onTap: () => showSnackBarWithAction(context, '删除历史考试记录', '确认',
                  () => locator<ExamHistoryProvider>().delAllHistory()),
            ),
          ],
        ));
  }

  Widget _buildMain() {
    return Consumer<ExamHistoryProvider>(builder: (_, his, __) {
      if (his.isBusy) {
        return const Flexible(child: centerLoading);
      }
      return SizedBox(
        height: _media.size.height * 0.84,
        width: _media.size.width,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: his.histories.length,
          itemExtent: _media.size.height * 0.2,
          itemBuilder: (_, int index) {
            return _buildItem(his.histories[index]);
          },
        ),
      );
    });
  }

  Widget _buildItem(ExamHistory histoy) {
    return GestureDetector(
      child: NeuCard(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NeuText(text: histoy.date, textStyle: titleStyle),
            NeuText(text: '${histoy.correctRate}%')
          ],
        ),
      ),
      onTap: () => AppRoute(ExamHistoryViewPage(
        examHistory: histoy,
      )).go(context),
    );
  }
}

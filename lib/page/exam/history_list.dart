import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../../core/route.dart';
import '../../core/utils.dart';
import '../../data/store/exam_history.dart';
import '../../locator.dart';
import '../../model/exam_history.dart';
import '../../widget/app_bar.dart';
import '../../widget/neu_btn.dart';
import '../../widget/neu_card.dart';
import '../../widget/neu_text.dart';
import 'history_view.dart';

class ExamHistoryListPage extends StatefulWidget {
  const ExamHistoryListPage({super.key});

  @override
  State<ExamHistoryListPage> createState() => _ExamHistoryListPageState();
}

class _ExamHistoryListPageState extends State<ExamHistoryListPage> {
  /// 设备媒体数据
  late MediaQueryData _media;
  late double padding;
  late List<ExamHistory> _historyList;

  /// 标题文字风格
  final titleStyle =
      NeumorphicTextStyle(fontSize: 17, fontWeight: FontWeight.bold);
  final dateStyle = NeumorphicTextStyle(fontSize: 14);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
    padding = _media.size.height * 0.027;
  }

  @override
  void initState() {
    super.initState();
    _historyList = locator<ExamHistoryStore>().fetchAll().reversed.toList();
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
            icon: Icons.delete,
            onTap: () =>
                showSnackBarWithAction(context, '删除所有历史考试记录', '确认', () {
              locator<ExamHistoryStore>().clear();
              _historyList.clear();
              setState(() {});
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMain() {
    if (_historyList.isEmpty) {
      return const Expanded(
        child: Center(
          child: NeuText(
            text: '暂无考试记录',
          ),
        ),
      );
    }
    return SizedBox(
      height: _media.size.height * 0.84,
      width: _media.size.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _historyList.length,
        itemExtent: _media.size.height * 0.13,
        itemBuilder: (_, int index) {
          return _buildItem(_historyList[index]);
        },
      ),
    );
  }

  Widget _buildItem(ExamHistory history) {
    final rateColor = history.correctRate >= 60 ? Colors.green : Colors.red;
    return GestureDetector(
      child: NeuCard(
        margin: EdgeInsets.symmetric(horizontal: padding),
        padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NeuText(
                  text: history.subject,
                  textStyle: titleStyle,
                  align: TextAlign.start,
                ),
                const SizedBox(height: 7),
                NeuText(
                  text: history.date.split('.').first,
                  align: TextAlign.start,
                  textStyle: dateStyle,
                  style: const NeumorphicStyle(color: Colors.grey),
                ),
              ],
            ),
            NeuText(
              text: '${history.correctRate.toStringAsFixed(1)}%',
              textStyle: titleStyle,
              align: TextAlign.end,
              style: NeumorphicStyle(color: rateColor),
            ),
          ],
        ),
      ),
      onTap: () => AppRoute(
        ExamHistoryViewPage(
          examHistory: history,
        ),
      ).go(context),
      onLongPress: () => showSnackBarWithAction(context, '删除该考试记录', '确认', () {
        locator<ExamHistoryStore>().del(history);
        _historyList.remove(history);
        setState(() {});
      }),
    );
  }
}

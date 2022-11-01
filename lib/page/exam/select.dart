import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../core/route.dart';
import '../../core/utils.dart';
import '../../data/provider/exam.dart';
import '../../data/provider/tiku.dart';
import '../../data/provider/timer.dart';
import '../../locator.dart';
import '../../res/color.dart';
import '../../widget/app_bar.dart';
import '../../widget/center_loading.dart';
import '../../widget/neu_btn.dart';
import '../../widget/neu_card.dart';
import '../../widget/neu_text.dart';
import '../../widget/tiku_update_progress.dart';
import 'history_list.dart';
import 'ing.dart';

/// 考试科目、题目类型数量、时间选择页
class ExamSelectPage extends StatefulWidget {
  const ExamSelectPage({Key? key}) : super(key: key);

  @override
  _ExamSelectPageState createState() => _ExamSelectPageState();
}

class _ExamSelectPageState extends State<ExamSelectPage> {
  /// 设备媒体数据
  late MediaQueryData _media;

  /// 题库数据Provider
  late TikuProvider _tikuProvider;
  String? _selectedCourse;
  String? _selectedCourseName;

  /// [_counts] : 长度为5，分别为[单选]、[多选]、[填空]、[判断]题目的个数，以及[考试时长]
  List<double> _counts = [];

  /// 选择的单元
  final List<String> _units = [];

  /// 标题文字风格
  final titleStyle =
      NeumorphicTextStyle(fontSize: 17, fontWeight: FontWeight.bold);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _media = MediaQuery.of(context);
  }

  @override
  void initState() {
    super.initState();
    _tikuProvider = locator<TikuProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        children: [_buildHead(), const TikuUpdateProgress(), _buildMain()],
      ),
      bottomSheet: _buildStart(),
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
              icon: Icons.history,
              onTap: () => AppRoute(const ExamHistoryListPage()).go(context),
            ),
          ],
        ));
  }

  Widget _buildMain() {
    if (_tikuProvider.isBusy) {
      return const Flexible(child: centerLoading);
    }
    return SizedBox(
      height: _media.size.height * 0.84,
      width: _media.size.width,
      child: ListView(
        children: [
          _buildCourseSelect(),
          _buildTiTypeSelect(),
          SizedBox(height: _media.size.height * 0.13)
        ],
      ),
    );
  }

  Widget _buildCourseSelect() {
    return Consumer<TikuProvider>(
      builder: (_, tiku, __) {
        if (tiku.isBusy) {
          return const Flexible(child: centerLoading);
        }
        if (tiku.tikuIndex == null) {
          return const Center(
            child: NeuText(text: '题库索引数据缺失'),
          );
        } else {
          final radios = <Widget>[];
          for (var item in tiku.tikuIndex!) {
            radios.add(NeumorphicRadio<String>(
              child: Center(child: NeuText(text: item.chinese!)),
              style: NeumorphicRadioStyle(
                  boxShape: NeumorphicBoxShape.roundRect(
                      const BorderRadius.all(Radius.circular(7)))),
              value: item.id,
              groupValue: _selectedCourse,
              onChanged: (val) => setState(() {
                _selectedCourse = val;
                _selectedCourseName = item.chinese;
                _counts = [0, 0, 0, 0, 60];
              }),
            ));
          }
          final gridPad = _media.size.width * 0.05;
          return Column(
            children: [
              NeuText(text: '科目', textStyle: titleStyle),
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxHeight: _media.size.height * 0.18),
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(gridPad),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, childAspectRatio: 2),
                    itemCount: radios.length,
                    itemBuilder: (context, idx) {
                      return Padding(
                        padding: const EdgeInsets.all(6),
                        child: radios[idx],
                      );
                    }),
              )
            ],
          );
        }
      },
    );
  }

  Widget _buildTiTypeSelect() {
    final selected = _selectedCourse != null;
    if (!selected) {
      return const SizedBox();
    }
    final index = _tikuProvider.tikuIndex;
    if (index == null) {
      return const SizedBox();
    }
    final course = index.firstWhere((element) => element.id == _selectedCourse);
    int singleCount = 0, mutiCount = 0, judgeCount = 0, fillCount = 0;
    _units.clear();
    for (var item in course.content!) {
      singleCount += item!.radio!;
      mutiCount += item.multiple!;
      judgeCount += item.decide!;
      fillCount += item.fill!;
      _units.add(item.data!);
    }
    return NeuCard(
      padding: EdgeInsets.all(_media.size.width * 0.05),
      child: Column(
        children: [
          SizedBox(height: _media.size.height * 0.01),
          NeuText(
            text: '题型',
            textStyle: titleStyle,
          ),
          SizedBox(height: _media.size.height * 0.01),
          _buildSlider(singleCount.toDouble(), 0, 0, '单选', '题'),
          _buildSlider(mutiCount.toDouble(), 0, 1, '多选', '题'),
          _buildSlider(fillCount.toDouble(), 0, 2, '填空', '题'),
          _buildSlider(judgeCount.toDouble(), 0, 3, '判断', '题'),
          SizedBox(height: _media.size.height * 0.01),
          NeuText(
            text: '考试时长',
            textStyle: titleStyle,
          ),
          SizedBox(height: _media.size.height * 0.01),
          _buildSlider(60, 1, 4, '分钟', '分钟'),
        ],
      ),
    );
  }

  Widget _buildSlider(
      double max, double min, int idx, String typeChinese, String suffix) {
    if (max == 0) {
      return const SizedBox();
    }
    final priColor = primaryColor;
    final realMax = max > 60 ? 60 : max;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NeuText(
              text: typeChinese,
            ),
            SizedBox(
              width: _media.size.width * 0.2,
              child: NeuText(
                text: '${_counts[idx].toInt()} $suffix',
                align: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
      Slider(
        thumbColor: priColor,
        activeColor: priColor.withOpacity(0.7),
        min: min,
        max: realMax.toDouble(),
        value: _counts[idx],
        onChanged: (newValue) {
          setState(() {
            _counts[idx] = newValue;
          });
        },
        divisions: realMax ~/ 5 < 2 ? realMax.toInt() : realMax ~/ 5,
      ),
      const SizedBox(
        height: 3,
      ),
    ]);
  }

  Widget _buildStart() {
    return NeuBtn(
        padding: EdgeInsets.zero,
        onTap: () {
          if (_selectedCourse == null) {
            showSnackBar(context, const Text('请选择科目'));
          } else {
            final total = _counts[0] + _counts[1] + _counts[2] + _counts[3];
            if (total == 0) {
              showSnackBar(context, const Text('题目总数不得等于0'));
            } else {
              locator<ExamProvider>().loadTi(_selectedCourse!, _units, _counts);
              locator<TimerProvider>().start(DateTime.now().add(Duration(
                  minutes: (_counts[4]).toInt(),
                  // 由于页面动画的存在，所以多给一秒
                  seconds: 1)));
              AppRoute(ExamingPage(
                subject: _selectedCourseName ?? '',
                subjectId: _selectedCourse ?? '',
              )).go(context);
            }
          }
        },
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: _media.padding.bottom,
            ),
            child: Center(
              child: NeuText(
                text: '开始！',
                textStyle: titleStyle,
              ),
            ),
          ),
          width: _media.size.width,
          height: _media.size.height * 0.06 + _media.padding.bottom,
        ));
  }
}

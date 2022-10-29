import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/store/unit_history.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/model/tiku_index.dart';
import 'package:toast_tiku/page/favorite.dart';
import 'package:toast_tiku/page/unit_quiz.dart';
import 'package:toast_tiku/res/color.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_dialog.dart';
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
            Row(
              children: [
                NeuIconBtn(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 13),
                SizedBox(
                    width: _media.size.width * 0.3,
                    child: Hero(
                        transitionOnUserGestures: true,
                        tag: 'home_all_course_${widget.data.id}',
                        child: NeuText(
                          text: widget.data.chinese!,
                          align: TextAlign.left,
                        ))),
              ],
            ),
            Row(
              children: [
                NeuIconBtn(
                  icon: Icons.favorite_outline,
                  onTap: () => AppRoute(UnitFavoritePage(
                    courseId: widget.data.id!,
                    courseName: widget.data.chinese!,
                  )).go(context),
                ),
                NeuIconBtn(
                  icon: Icons.delete_outlined,
                  onTap: () async {
                    final idxes = widget.data.content!;
                    final selected = <String>[];
                    await showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, StateSetter setState) {
                            return NeuDialog(
                                title: NeuText(
                                  text: '删除记录',
                                  textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.bold),
                                  align: TextAlign.start,
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 17),
                                content: SizedBox(
                                  width: _media.size.width * 0.9,
                                  height: _media.size.height * 0.3,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(3),
                                    itemBuilder: (context, i) {
                                      final item = idxes[i]!;
                                      final id = item.data!;
                                      final isSelect = selected.contains(id);
                                      return NeuBtn(
                                        onTap: () {
                                          if (isSelect) {
                                            selected.remove(id);
                                          } else {
                                            selected.add(id);
                                          }
                                          setState(() {});
                                        },
                                        margin: const EdgeInsets.all(9),
                                        style: NeumorphicStyle(
                                          depth: selected.contains(id)
                                              ? -20
                                              : null),
                                        child: NeuText(
                                          text: item.title ?? '未知章节名',
                                          align: TextAlign.left,
                                        ),
                                      );
                                    },
                                    itemCount: idxes.length),
                                ),
                                actions: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: NeuBtn(
                                        child: const Text(
                                          '删除',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    const Spacer(),
                                    NeuBtn(
                                      child: const Text('取消'),
                                      onTap: () {
                                        selected.clear();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    NeuBtn(
                                      child: Text(idxes.length == selected.length ? '全不选' : '全选'),
                                      onTap: () {
                                        if (idxes.length == selected.length) {
                                          selected.clear();
                                        } else {
                                          selected.clear();
                                          selected.addAll(idxes.map((e) => e!.data!));
                                        }
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ));
                          });
                        });
                    final courseId = widget.data.id ?? '';
                    for (var unit in selected) {
                      _historyStore.put(courseId, unit, []);
                      _historyStore.putCheckState(courseId, unit, null);
                    }
                  },
                )
              ],
            ),
          ],
        ));
  }

  Widget _buildSelectCard() {
    return SizedBox(
        height: getRemainHeight(_media),
        width: _media.size.width,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: widget.data.length,
          itemExtent: _media.size.height * 0.2,
          itemBuilder: (BuildContext context, int index) {
            return _buildCardItem(index);
          },
        ));
  }

  Widget _buildCardItem(int index) {
    final pad = _media.size.height * 0.037;
    final data = widget.data.content![index];
    final total = data!.radio! + data.decide! + data.fill! + data.multiple!;
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
                color: primaryColor,
              )),
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

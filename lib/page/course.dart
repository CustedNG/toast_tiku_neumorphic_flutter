import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../core/route.dart';
import '../data/store/unit_history.dart';
import '../locator.dart';
import '../model/tiku_index.dart';
import '../res/color.dart';
import '../widget/app_bar.dart';
import '../widget/neu_btn.dart';
import '../widget/neu_dialog.dart';
import '../widget/neu_text.dart';
import '../widget/tiku_update_progress.dart';
import 'favorite.dart';
import 'unit_quiz.dart';

class CoursePage extends StatefulWidget {
  final TikuIndex data;
  const CoursePage({super.key, required this.data});

  @override
  State<CoursePage> createState() => _CoursePageState();
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
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              NeuIconBtn(
                icon: Icons.favorite_outline,
                onTap: () => AppRoute(
                  UnitFavoritePage(
                    courseId: widget.data.id!,
                    courseName: widget.data.chinese!,
                  ),
                ).go(context),
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
                                fontWeight: FontWeight.bold,
                              ),
                              align: TextAlign.start,
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 23,
                              vertical: 17,
                            ),
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
                                      depth: selected.contains(id) ? -20 : null,
                                    ),
                                    child: NeuText(
                                      text: item.title ?? '未知章节名',
                                      align: TextAlign.left,
                                    ),
                                  );
                                },
                                itemCount: idxes.length,
                              ),
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
                                        color: Colors.redAccent,
                                      ),
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
                                  child: Text(
                                    idxes.length == selected.length
                                        ? '全不选'
                                        : '全选',
                                  ),
                                  onTap: () {
                                    if (idxes.length == selected.length) {
                                      selected.clear();
                                    } else {
                                      selected.clear();
                                      selected.addAll(
                                        idxes.map((e) => e!.data!),
                                      );
                                    }
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                  final courseId = widget.data.id ?? '';
                  for (var unit in selected) {
                    _historyStore.put(courseId, unit, []);
                    _historyStore.putCheckState(courseId, unit, null);
                  }
                },
              ),
              // onTap: () => showSnackBarWithAction(
              //         context,
              //         '是否删除${widget.data.chinese}所有的做题记录？\n请注意，操作无法撤回！',
              //         '确认', () {
              //       final courseId = widget.data.id ?? '';
              //       for (var unit in widget.data.content!) {
              //         final unitId = unit!.data ?? '';
              //         _historyStore.put(courseId, unitId, []);
              //         _historyStore.putCheckState(courseId, unitId, null);
              //       }
              //     }))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectCard() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCardItem(index);
        },
      ),
    );
  }

  Widget _buildCardItem(int index) {
    final data = widget.data.content![index]!;
    final total = data.radio! + data.decide! + data.fill! + data.multiple!;
    final doneTiCount = _historyStore.fetch(widget.data.id!, data.data!).length;
    return NeuBtn(
      onTap: () => AppRoute(
        UnitQuizPage(
          courseId: widget.data.id!,
          unitFile: data.data!,
          unitName: data.title!,
        ),
      ).go(context),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            color: primaryColor,
            width: (_media.size.width - 37) * (doneTiCount / total),
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              children: [
                NeuText(text: data.title ?? ''),
                const SizedBox(
                  height: 3,
                ),
                NeuText(
                  text: '共$total题',
                  style: NeumorphicStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

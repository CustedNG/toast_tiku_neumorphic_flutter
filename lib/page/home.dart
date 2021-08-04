import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/core/route.dart';
import 'package:toast_tiku/core/utils.dart';
import 'package:toast_tiku/data/provider/tiku.dart';
import 'package:toast_tiku/locator.dart';
import 'package:toast_tiku/page/course.dart';
import 'package:toast_tiku/widget/app_bar.dart';
import 'package:toast_tiku/widget/neu_card.dart';
import 'package:toast_tiku/widget/neu_btn.dart';
import 'package:toast_tiku/widget/neu_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHead(media),
          SizedBox(height: media.size.height * 0.03),
          _buildResumeCard(media),
          SizedBox(height: media.size.height * 0.01),
          _buildAllCourseCard(media),
        ],
      ),
    );
  }

  Widget _buildHead(MediaQueryData media) {
    return NeuAppBar(
        media: media,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                NeuIconBtn(
                  icon: Icons.people,
                  onTap: () => showSnackBar(context, Text('1231')),
                ),
                const NeuText(
                  text: 'Hi 👋🏻\nLollipopKit',
                  align: TextAlign.start,
                ),
              ],
            ),
            _buildTopBtn(media),
          ],
        ));
  }

  Widget _buildResumeCard(MediaQueryData media) {
    return NeuCard(
      child: SizedBox(
        width: media.size.width * 0.9 - 40,
        height: media.size.height * 0.17,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeuIconBtn(
              icon: Icons.add,
              boxShape: const NeumorphicBoxShape.circle(),
              onTap: () => showSnackBar(context,
                  Text(locator<TikuProvider>().tikuIndex!.length.toString())),
            ),
            const NeuText(text: '还没有收藏的科目，点击添加')
          ],
        ),
      ),
    );
  }

  Widget _buildAllCourseCard(MediaQueryData media) {
    return NeuCard(
      child: Container(
        width: media.size.width * 0.9 - 40,
        height: media.size.height * 0.17,
        child: Center(
          child: NeumorphicText('212312412312'),
        ),
      ),
    );
  }

  Widget _buildTopBtn(MediaQueryData media) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NeuIconBtn(
          icon: Icons.add,
          onTap: () => AppRoute(
                  CoursePage(data: locator<TikuProvider>().tikuIndex!.first))
              .go(context),
        ),
        NeuIconBtn(
          icon: Icons.search,
          onTap: () => NeumorphicTheme.of(context)!.themeMode = ThemeMode.dark,
        ),
      ],
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await locator<TikuProvider>().refreshUnit();
  }
}

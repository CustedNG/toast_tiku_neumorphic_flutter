import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:toast_tiku/widget/neu_btn.dart';

/// 考试结果展示页
class ExamResultPage extends StatelessWidget {
  /// 正确率
  final double percent;

  const ExamResultPage({Key? key, required this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: const NeumorphicThemeData(
        baseColor: Color(0xFFE5E5E5),
        depth: 20,
        intensity: 1,
        lightSource: LightSource.top,
      ),
      themeMode: ThemeMode.light,
      child: Material(
        child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xFFF1F1F1),
                Color(0xFFCFCFCF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: _Page(
              percent: percent,
            )),
      ),
    );
  }
}

class _Page extends StatefulWidget {
  final double percent;

  const _Page({Key? key, required this.percent}) : super(key: key);

  @override
  createState() => _PageState();
}

class _PageState extends State<_Page> {
  Widget _letter(String letter) {
    return Text(letter,
        style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: 'Samsung',
            fontSize: 80));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _letter("恭喜🎉"),
                  ],
                ),
                const SizedBox(
                  height: 77,
                ),
                Text(
                  '正确率 ${widget.percent * 100}%',
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 77,
                ),
                NeuBtn(
                  child: NeumorphicIcon(
                    Icons.arrow_back,
                    style: const NeumorphicStyle(color: Colors.black),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

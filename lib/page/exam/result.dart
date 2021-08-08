import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ExamResultPage extends StatelessWidget {
  final double percent;

  const ExamResultPage({Key? key, required this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFE5E5E5),
        depth: 20,
        intensity: 1,
        lightSource: LightSource.top,
      ),
      themeMode: ThemeMode.light,
      child: Material(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xFFF1F1F1),
                Color(0xFFCFCFCF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: _Page(percent: percent,)),
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
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontFamily: 'Samsung',
            fontSize: 80));
  }

  Widget _firstBox() {
    return Neumorphic(
      margin: EdgeInsets.symmetric(horizontal: 10),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
      ),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -1,
          oppositeShadowLightSource: true,
        ),
        padding: EdgeInsets.all(2),
        child: SizedBox(
          width: 40,
          height: 60,
        ),
      ),
    );
  }

  Widget _secondBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Transform.rotate(
        angle: 0.79,
        child: Neumorphic(
          style: NeumorphicStyle(
            lightSource: LightSource.topLeft,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
          ),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: -1,
              oppositeShadowLightSource: true,
              lightSource: LightSource.topLeft,
            ),
            child: SizedBox(
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
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
                    _letter("G"),
                    _firstBox(),
                    _secondBox(),
                    _letter("d"),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _letter("Job"),
                  ],
                ),
                SizedBox(
                  height: 77,
                ),
                Text('正确率${widget.percent}%', style: TextStyle(color: Colors.black),),
                SizedBox(
                  height: 77,
                ),
                NeumorphicButton(
                  child: NeumorphicIcon(
                    Icons.arrow_back,
                    style: NeumorphicStyle(color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

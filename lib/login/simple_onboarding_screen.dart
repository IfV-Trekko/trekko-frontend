import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:flutter/cupertino.dart';

class SimpleOnboardingScreen extends StatefulWidget {

  final Widget child;
  final String title;
  final String? buttonTitle;
  final Future<void> Function()? onButtonPress;

  const SimpleOnboardingScreen(
      {super.key,
      required this.child,
      required this.title,
      required this.buttonTitle,
      required this.onButtonPress});

  @override
  State<SimpleOnboardingScreen> createState() => _SimpleOnboardingScreenState();
}

class _SimpleOnboardingScreenState extends State<SimpleOnboardingScreen> {
  bool _isLoading = false;

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
      child: SafeArea(
          child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.9,
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(widget.title,
                textAlign: TextAlign.center,
                style: AppThemeTextStyles.headline),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                widget.child,
              ],
            )),
            LayoutBuilder(builder: (context, constraint) {
              if (widget.buttonTitle == null) return Container();
              return Button(
                  title: widget.buttonTitle!,
                  stretch: true,
                  loading: _isLoading,
                  onPressed: () async {
                    setLoading(true);
                    await widget.onButtonPress! .call();
                    setLoading(false);
                  });
            }),
          ],
        ),
      )),
    ));
  }
}

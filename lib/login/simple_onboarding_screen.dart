import 'package:app_frontend/app_theme.dart';
import 'package:app_frontend/components/button.dart';
import 'package:flutter/cupertino.dart';

class SimpleOnboardingScreen extends StatefulWidget {
  final Widget child;
  final String title;
  final String? buttonTitle;
  final Future<void> Function()? onButtonPress;
  final EdgeInsetsGeometry? padding;

  const SimpleOnboardingScreen(
      {super.key,
      required this.child,
      required this.title,
      required this.buttonTitle,
      required this.onButtonPress,
      this.padding});

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
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: widget.padding ?? EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.title,
                      textAlign: TextAlign.center,
                      style: AppThemeTextStyles.onboardingHeadline),
                  const SizedBox(height: 100),
                  widget.child,
                ],
              ),
            ),
          ),
          if (widget.buttonTitle != null)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Button(
                title: widget.buttonTitle!,
                stretch: true,
                loading: _isLoading,
                onPressed: () async {
                  setLoading(true);
                  if (widget.onButtonPress != null) {
                    await widget.onButtonPress!();
                  }
                  setLoading(false);
                },
              ),
            ),
        ],
      )),
    )));
  }
}

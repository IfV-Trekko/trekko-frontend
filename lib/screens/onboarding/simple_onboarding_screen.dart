import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/button.dart';

class SimpleOnboardingScreen extends StatefulWidget {
  final Widget child;
  final String title;
  final String? buttonTitle;
  final Future<void> Function()? onButtonPress;
  final EdgeInsetsGeometry? padding;
  final List<Widget> additionalButtons;

  const SimpleOnboardingScreen(
      {super.key,
      required this.child,
      required this.title,
      required this.buttonTitle,
      required this.onButtonPress,
      this.additionalButtons = const [],
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
                  padding: widget.padding ??
                      const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 70,
                      ),
                      Text(widget.title,
                          textAlign: TextAlign.center,
                          style: AppThemeTextStyles.onboardingHeadline),
                      const SizedBox(height: 100),
                      widget.child,
                    ],
                  ),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    children: [
                      for (Widget button in widget.additionalButtons)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: button,
                        ),
                      if (widget.buttonTitle != null)
                        Button(
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
                    ],
                  )),
            ],
          )),
    )));
  }
}

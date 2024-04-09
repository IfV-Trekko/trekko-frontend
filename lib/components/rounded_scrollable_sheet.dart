import 'package:flutter/cupertino.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/pull_tab.dart';

class RoundedScrollableSheet extends StatelessWidget {
  final Widget child;
  final String title;
  final double initialChildSize;

  const RoundedScrollableSheet({required this.child, required this.title, required this.initialChildSize, super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        snap: true,
        minChildSize: 0.03,
        snapSizes: [0.03, initialChildSize, 0.5, 0.9],
        initialChildSize: initialChildSize,
        builder: (context, scrollController) {
          return Container(
              decoration: const BoxDecoration(
                color: AppThemeColors.contrast100,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  padding: const EdgeInsets.only(top: 8),
                  clipBehavior: Clip.none,
                  child: Column(children: <Widget>[
                    const PullTab(),
                    const SizedBox(height: 8),
                    Container(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        child: Text(title,
                            style: AppThemeTextStyles.largeTitle
                                .copyWith(fontWeight: FontWeight.w700))),
                    const SizedBox(height: 16),
                    child
                  ])));
        });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/profile/onboarding_question.dart';
import 'package:trekko_frontend/app_theme.dart';

class BoolQuestionTile extends StatelessWidget {
  final OnboardingQuestion question;
  final bool? answer;
  final Function(dynamic) onSaved;
  final EdgeInsetsGeometry padding;

  const BoolQuestionTile(
      {super.key,
      required this.question,
      required this.answer,
      required this.onSaved,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      padding: padding,
      title: Text(question.title, style: AppThemeTextStyles.normal),
      trailing: CupertinoSwitch(
        value: answer == null ? false : answer as bool,
        activeColor: AppThemeColors.green,
        onChanged: onSaved,
      ),
    );
  }
}

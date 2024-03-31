import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/profile/onboarding_question.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/picker/setting_picker.dart';

class SelectQuestionTile extends StatelessWidget {
  final OnboardingQuestion question;
  final String? answer;
  final Function(String?) onSaved;
  final EdgeInsetsGeometry padding;

  const SelectQuestionTile(
      {super.key,
      required this.question,
      this.answer,
      required this.onSaved,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    String? selectedOptionTitle;
    if (answer != null) {
      selectedOptionTitle =
          question.options!.firstWhere((option) => option.key == answer).answer;
    }

    return CupertinoListTile.notched(
      padding: padding,
      title: Text(question.title, style: AppThemeTextStyles.normal),
      additionalInfo:
          Text(selectedOptionTitle ?? "Nicht beantwortet"),
      trailing: const CupertinoListTileChevron(),
      onTap: () async {
        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) {
            return SettingsPicker(
              onSettingSelected: (i) => onSaved(question.options![i].key),
              children: question.options!
                  .map((option) => Center(child: Text(option.answer)))
                  .toList(),
            );
          },
        );
      },
    );
  }
}

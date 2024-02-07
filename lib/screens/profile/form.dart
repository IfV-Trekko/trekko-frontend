import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/screens/profile/setting_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_backend/model/profile/profile.dart';
import 'package:app_backend/model/profile/onboarding_question.dart';
import 'package:app_backend/model/profile/question_type.dart';
import 'package:app_frontend/app_theme.dart';
import 'input_text_screen.dart';

class QuestionTilesBuilder {
  static List<CupertinoListTile> buildQuestionTiles({
    required BuildContext context,
    required Profile profile,
    required Trekko trekko,
    required EdgeInsetsGeometry padding,
  }) {
    Future<void> showSelectPicker({
      required BuildContext context,
      required Profile profile,
      required Trekko trekko,
      required OnboardingQuestion question,
    }) async {
      List<Widget> optionsWidgets = question.options!
          .map((option) => Center(
                child: Text(option.answer),
              ))
          .toList();

      void onSettingSelected(int selectedIndex) {
        String selectedOptionKey = question.options![selectedIndex].key;
        profile.preferences.setQuestionAnswer(question.key, selectedOptionKey);
        trekko.savePreferences(profile.preferences);
      }

      await showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return SettingsPicker(
            onSettingSelected: onSettingSelected,
            children: optionsWidgets,
          );
        },
      );
    }

    Future<void> navigateAndEditText(Profile profile,
        OnboardingQuestion question, Function(String) onChange) async {
      final result = await Navigator.of(context).push(
        CupertinoPageRoute<String>(
          builder: (BuildContext context) => TextInputPage(
              question: question, trekko: trekko, profile: profile),
        ),
      );
      if (result != null) {
        onChange.call(result);
        trekko.savePreferences(profile.preferences);
      }
    }

    List<CupertinoListTile> questionTiles = [];
    for (OnboardingQuestion question
        in profile.preferences.onboardingQuestions) {
      dynamic answer = profile.preferences.getQuestionAnswer(question.key);

      CupertinoListTile questionTile;
      if (question.type == QuestionType.boolean) {
        questionTile = CupertinoListTile.notched(
          padding: padding,
          title: Text(question.title, style: AppThemeTextStyles.normal),
          trailing: CupertinoSwitch(
            value: answer == null ? false : answer as bool,
            activeColor: AppThemeColors.green,
            onChanged: (bool? newValue) {
              if (newValue != null) {
                profile.preferences.setQuestionAnswer(question.key, newValue);
                trekko.savePreferences(profile.preferences);
              }
            },
          ),
        );
      } else if (question.type == QuestionType.select) {
        questionTile = CupertinoListTile.notched(
          padding: padding,
          title: Text(question.title, style: AppThemeTextStyles.normal),
          additionalInfo: Text(answer != null
              ? question.options!.where((e) => e.key == answer).first.answer
              : "Nicht beantwortet"),
          trailing: const CupertinoListTileChevron(),
          onTap: () async {
            await showSelectPicker(
              context: context,
              profile: profile,
              trekko: trekko,
              question: question,
            );
          },
        );
      } else {
        questionTile = CupertinoListTile.notched(
          padding: padding,
          title: Text(question.title, style: AppThemeTextStyles.normal),
          additionalInfo: Text(answer == null
              ? "Nicht beantwortet"
              : question.type == QuestionType.number
                  ? answer.toInt().toString()
                  : answer.toString()),
          trailing: const CupertinoListTileChevron(),
          onTap: () =>
              navigateAndEditText(profile, question, (String newValue) {
            profile.preferences.setQuestionAnswer(question.key, newValue);
          }),
        );
      }
      questionTiles.add(questionTile);
    }
    return questionTiles;
  }
}

import 'package:app_backend/controller/trekko.dart';
import 'package:app_frontend/components/constants/text_response_keyboard_type.dart';
import 'package:app_frontend/components/picker/setting_picker.dart';
import 'package:app_frontend/components/responses/text_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_backend/model/profile/profile.dart';
import 'package:app_backend/model/profile/onboarding_question.dart';
import 'package:app_backend/model/profile/question_type.dart';
import 'package:app_frontend/app_theme.dart';

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
        dynamic selectedOptionTitle;
        for (var option in question.options!) {
          if (option.key == answer) {
            selectedOptionTitle = option.answer;
          }
        }

        bool isAnswered = answer != null && selectedOptionTitle != null;

        questionTile = CupertinoListTile.notched(
          padding: padding,
          title: Text(question.title, style: AppThemeTextStyles.normal),
          additionalInfo:
              Text(isAnswered ? selectedOptionTitle : "Nicht beantwortet"),
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
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => TextResponse(
                        acceptEmptyResponse: true,
                        maxLength: 256,
                        maxLines: 1,
                        onSaved: (String newValue) {
                          if (question.type == QuestionType.number) {
                            profile.preferences.setQuestionAnswer(
                                question.key, double.parse(newValue));
                          } else {
                            profile.preferences
                                .setQuestionAnswer(question.key, newValue);
                          }
                          trekko.savePreferences(profile.preferences);
                        },
                        title: question.title,
                        placeholder: question.title,
                        keyboardType: question.type == QuestionType.number
                            ? TextResponseKeyboardType.number
                            : TextResponseKeyboardType.text,
                        initialValue: answer == null
                            ? ''
                            : question.type == QuestionType.number
                                ? answer.round().toString()
                                : answer,
                      )));
            });
      }
      questionTiles.add(questionTile);
    }
    return questionTiles;
  }
}

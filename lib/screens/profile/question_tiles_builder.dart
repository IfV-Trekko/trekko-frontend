import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_frontend/components/constants/text_response_keyboard_type.dart';
import 'package:trekko_frontend/components/picker/setting_picker.dart';
import 'package:trekko_frontend/components/responses/text_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/profile/profile.dart';
import 'package:trekko_backend/model/profile/onboarding_question.dart';
import 'package:trekko_backend/model/profile/question_type.dart';
import 'package:trekko_frontend/app_theme.dart';

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
            onChanged: (bool? newValue) async {
              if (newValue == null) return;

              try {
                profile.preferences.setQuestionAnswer(question.key, newValue);
                await trekko.savePreferences(profile.preferences);
              } catch (e) {
                // ignore: use_build_context_synchronously
                _showErrorDialog(context, e);
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
            additionalInfo: SizedBox(
                width: 250,
                child: Text(
                    answer == null ? "Nicht beantwortet" : answer.toString(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end)),
            trailing: const CupertinoListTileChevron(),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => TextResponse(
                        suffix: '',
                        maxLength: 256,
                        maxLines: 1,
                        onSaved: (String? newValue) async {
                          try {
                            profile.preferences
                                .setQuestionAnswer(question.key, newValue);
                            await trekko.savePreferences(profile.preferences);
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            _showErrorDialog(context, e);
                          }
                        },
                        title: question.title,
                        placeholder: question.title,
                        keyboardType: question.type == QuestionType.number
                            ? TextResponseKeyboardType.number
                            : TextResponseKeyboardType.text,
                        initialValue: answer == null ? '' : answer.toString(),
                      )));
            });
      }
      questionTiles.add(questionTile);
    }
    return questionTiles;
  }

  static void _showErrorDialog(BuildContext context, Object e) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Fehlerhafte Eingabe'),
          content: const Text(
              'Die Eingabe konnte nicht verarbeitet werden. Bitte versuchen Sie es erneut.'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

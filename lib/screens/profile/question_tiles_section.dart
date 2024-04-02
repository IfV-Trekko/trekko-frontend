import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/controller/trekko.dart';
import 'package:trekko_backend/model/profile/onboarding_question.dart';
import 'package:trekko_backend/model/profile/preferences.dart';
import 'package:trekko_backend/model/profile/question_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/screens/profile/bool_question_tile.dart';
import 'package:trekko_frontend/screens/profile/select_question_tile.dart';
import 'package:trekko_frontend/screens/profile/text_question_tile.dart';

class QuestionTilesSection extends StatelessWidget {
  final double defaultDividerMargin = 2;
  final EdgeInsetsGeometry listTilePadding =
      const EdgeInsets.only(left: 16, right: 16);
  final EdgeInsetsGeometry firstListSectionMargin =
      const EdgeInsets.fromLTRB(16, 16, 16, 16);
  final EdgeInsetsGeometry listSectionMargin =
      const EdgeInsets.fromLTRB(16, 0, 16, 16);

  final Trekko trekko;
  final EdgeInsetsGeometry padding;

  const QuestionTilesSection(
      {super.key,
      required this.trekko,
      this.padding = const EdgeInsets.only(left: 16, right: 16)});

  void _showErrorDialog(BuildContext context, Object e) {
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

  void _onSave(BuildContext context, Preferences preferences,
      OnboardingQuestion question, dynamic answer) async {
    try {
      preferences.setQuestionAnswer(question.key, answer);
      await trekko.savePreferences(preferences);
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showErrorDialog(context, e);
    }
  }

  List<Widget> _buildQuestionTiles(
      BuildContext context, Preferences preferences) {
    List<Widget> questionTiles = [];
    for (OnboardingQuestion question in preferences.onboardingQuestions) {
      dynamic answer = preferences.getQuestionAnswer(question.key);
      Widget questionTile;
      if (question.type == QuestionType.boolean) {
        questionTile = BoolQuestionTile(
            answer: answer,
            question: question,
            padding: padding,
            onSaved: (newAnswer) =>
                _onSave(context, preferences, question, newAnswer));
      } else if (question.type == QuestionType.select) {
        questionTile = SelectQuestionTile(
            answer: answer,
            question: question,
            padding: padding,
            onSaved: (newAnswer) =>
                _onSave(context, preferences, question, newAnswer));
      } else {
        questionTile = TextQuestionTile(
            answer: answer != null ? answer.toString() : answer,
            question: question,
            padding: padding,
            onSaved: (newAnswer) =>
                _onSave(context, preferences, question, newAnswer));
      }
      questionTiles.add(questionTile);
    }

    if (questionTiles.isEmpty) {
      questionTiles.add(CupertinoListTile.notched(
        padding: listTilePadding,
        title:
            Text('Keine Fragen beantwortet', style: AppThemeTextStyles.normal),
      ));
    }

    return questionTiles;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: trekko.getProfile().map((event) => event.preferences),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("An error has occurred");
          } else if (snapshot.hasData) {
            return CupertinoListSection.insetGrouped(
              margin: listSectionMargin,
              additionalDividerMargin: defaultDividerMargin,
              children: _buildQuestionTiles(context, snapshot.data!),
            );
          }
          return const CupertinoActivityIndicator();
        });
  }
}

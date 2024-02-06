import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/profile/onboarding_question.dart';
import 'package:app_backend/model/profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_backend/model/profile/question_type.dart';

import '../../app_theme.dart';

class TextInputPage extends StatefulWidget {
  final OnboardingQuestion question;
  final Trekko trekko;
  final Profile profile;

  const TextInputPage({super.key,
    required this.question, required this.trekko, required this.profile
  });

  @override
  _TextInputPageState createState() => _TextInputPageState();
}

class _TextInputPageState extends State<TextInputPage> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppThemeColors.contrast100,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.question.title),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildContentBasedOnQuestionType(),
        ),
      ),
    );
  }

  Widget _buildContentBasedOnQuestionType() {
    switch (widget.question.type) {

      case QuestionType.number:
        return CupertinoTextField(
          placeholder: widget.question.title,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onSubmitted: (String value) {
            Navigator.of(context).pop(value);
          },
        );

      case QuestionType.text:
        return CupertinoTextField(
          placeholder: widget.question.title,
          autofocus: true,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onSubmitted: (String value) {
            Navigator.of(context).pop(value);
          },
        );

      default:
        return const Text('Unbekannter Fragentyp');
    }
  }
}

import 'package:app_backend/model/profile/onboarding_question.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_backend/model/profile/question_type.dart';
import '../../app_theme.dart';

class TextInputPage extends StatefulWidget {
  final OnboardingQuestion question;

  TextInputPage({
    required this.question,
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
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildContentBasedOnQuestionType(),
        ),
      ),
    );
  }

  Widget _buildContentBasedOnQuestionType() {
    switch (widget.question.type) {
      case QuestionType.select:
      // Logik für Auswahlfragen
        break;

      case QuestionType.number:
      // Logik für Zahlenfragen
        break;

      case QuestionType.text:
        return CupertinoTextField(
          placeholder: widget.question.title,
          autofocus: true,
          controller: TextEditingController(text: widget.question.key),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onSubmitted: (String value) {
            Navigator.of(context).pop(value);
          },
        );

      default:
        return Text('Unbekannter Fragentyp');
    }
    return Container(); // Fallback für nicht behandelte Fälle
  }
}

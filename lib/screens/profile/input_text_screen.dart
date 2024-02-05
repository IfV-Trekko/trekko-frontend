import 'package:app_backend/controller/trekko.dart';
import 'package:app_backend/model/profile/onboarding_question.dart';
import 'package:app_backend/model/profile/profile.dart';
import 'package:app_frontend/screens/profile/setting_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_backend/model/profile/question_type.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';

class TextInputPage extends StatefulWidget {
  final OnboardingQuestion question;
  final Trekko trekko;
  final Profile profile;

  TextInputPage({
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
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildContentBasedOnQuestionType(),
        ),
      ),
    );
  }

  Widget _buildContentBasedOnQuestionType() {
    switch (widget.question.type) {
      case QuestionType.select:
        return SettingsPicker(
          children: widget.question.options!.map((option) => Center(
            child: Text(option.answer),
          )).toList(),
          onSettingSelected: (int selectedIndex) {
            widget.profile.preferences.setQuestionAnswer(
            widget.question.key, widget.question.options![selectedIndex].key);
            widget.trekko.savePreferences(widget.profile.preferences);
          },
        );

      case QuestionType.number:
      // Logik für Zahlenfragen
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
        return Text('Unbekannter Fragentyp');
    }
    return Container(); // Fallback für nicht behandelte Fälle
  }
}

import 'package:flutter/cupertino.dart';
import 'package:trekko_backend/model/profile/onboarding_question.dart';
import 'package:trekko_backend/model/profile/question_type.dart';
import 'package:trekko_frontend/app_theme.dart';
import 'package:trekko_frontend/components/constants/text_response_keyboard_type.dart';
import 'package:trekko_frontend/components/responses/text_response.dart';

class TextQuestionTile extends StatelessWidget {
  final OnboardingQuestion question;
  final String? answer;
  final EdgeInsetsGeometry padding;
  final Function(String?) onSaved;

  const TextQuestionTile(
      {super.key,
      required this.padding,
      required this.answer,
      required this.question,
      required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
        padding: padding,
        title: Text(question.title, style: AppThemeTextStyles.normal, overflow: TextOverflow.ellipsis),
        additionalInfo:Text(
                answer == null ? "Nicht beantwortet" : answer.toString(),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end),
        trailing: const CupertinoListTileChevron(),
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => TextResponse(
                    suffix: '',
                    maxLength: 256,
                    maxLines: 1,
                    onSaved: onSaved,
                    title: question.title,
                    placeholder: question.title,
                    keyboardType: question.type == QuestionType.number
                        ? TextResponseKeyboardType.number
                        : TextResponseKeyboardType.text,
                    initialValue: answer == null ? '' : answer.toString(),
                  )));
        });
  }
}

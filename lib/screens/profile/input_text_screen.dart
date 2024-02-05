import 'package:app_backend/model/profile/onboarding_question.dart';
import 'package:app_backend/model/profile/question_answer.dart';
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
      return CupertinoActionSheet(
        actions: <Widget>[
          SizedBox(
            height: 200, // Höhe des Pickers
            child: CupertinoPicker(
              itemExtent: 32,
              backgroundColor: AppThemeColors.contrast0,
              onSelectedItemChanged: (int index) {
                index;
              },
              children: List<Widget>.generate(
                widget.question.options!.length,
                    (int index) {
                  return Center(
                    child: Text(widget.question.options![index].toString()),
                  );
                },
              ),
            ),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Fertig'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );

        break;

      case QuestionType.number:
      // Logik für Zahlenfragen
        //int selectedIndex = 0;
        return CupertinoActionSheet(
          actions: <Widget>[
            SizedBox(
              height: 200, // Höhe des Pickers
              child: CupertinoPicker(
                itemExtent: 32,
                //useMagnifier: true,
                backgroundColor: AppThemeColors.contrast0,
                onSelectedItemChanged: (int index) {
                  //selectedIndex = index;
                  Navigator.of(context).pop(index);
                },
                children: List<Widget>.generate(101, (int index) {
                  return Center(child: Text('$index'));
                }),
              ),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Fertig'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
        break;

      case QuestionType.text:
        return CupertinoTextField(
          placeholder: widget.question.title,
          autofocus: true,
          //controller: TextEditingController(text: widget.question.title), //TODO: Textfeld mit Frage vorbelegen nötig???
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

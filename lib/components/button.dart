import 'package:app_frontend/components/constants/buttonSize.dart';
import 'package:app_frontend/components/constants/buttonStyle.dart';
import 'package:flutter/cupertino.dart';

class Button extends StatelessWidget {
  final String title;
  final Icon icon;
  final bool loading;
  final bool stretch;
  final ButtonStyle style;
  final ButtonSize size;
  final Function onPressed;

  Button(this.title, this.icon, this.loading, this.stretch, this.style,
      this.size, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        onPressed();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: stretch ? constraints.maxWidth : constraints.minWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon != null ? icon : Container(),
                icon != null ? SizedBox(width: 10) : Container(),
                loading
                    ? CupertinoActivityIndicator()
                    : Text(
                        title,
                        style: TextStyle(
                          fontSize: size == ButtonSize.small ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

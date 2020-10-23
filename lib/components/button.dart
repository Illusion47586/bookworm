import 'package:flutter/material.dart';
import 'package:bookworm/utilities/constants.dart';
import 'package:bookworm/utilities/variables.dart';

class Button extends StatelessWidget {
  Button({this.context, this.title, this.icon, this.function});

  final BuildContext context;
  final String title;
  final IconData icon;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: function,
      child: Container(
        height: 56,
        width: 292,
        decoration: BoxDecoration(
          gradient: kGradient,
          borderRadius: BorderRadius.all(Radius.circular(14)),
          boxShadow: [
            BoxShadow(
              color: Color(0xff1466CC).withAlpha(30),
              offset: Offset(0, 15),
              blurRadius: 30,
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              size: 21,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class SubButton extends StatelessWidget {
  SubButton({this.context, this.title, this.icon, this.function});

  final BuildContext context;
  final String title;
  final IconData icon;
  final Function function;

  Color color = Color(0xff797979);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return RawMaterialButton(
      onPressed: function,
      child: Container(
        height: 56,
        width: 292,
        decoration: BoxDecoration(
          color: themeData.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(14)),
          border: Border.all(
            color: Colors.black.withAlpha(14),
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontFamily: "poppins",
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: color,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              size: 21,
              color: color,
            )
          ],
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  OptionButton({this.icon, this.function});
  final IconData icon;
  final Function function;

  Color color = Color(0xff797979);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: function,
      icon: Container(
        height: 50,
        width: 50,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: color.withAlpha(20),
                    offset: Offset(0, 10),
                    blurRadius: 20,
                  )
                ],
        ),
        child: Center(
          child: Icon(
            icon,
            size: 27,
            color: color,
          ),
        ),
      ),
    );
  }
}

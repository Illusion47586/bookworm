import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bookworm/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:bookworm/utilities/variables.dart';

class TextBox extends StatefulWidget {
  TextBox(
      {this.helperText,
      this.controller,
      this.input = TextInputType.text,
      this.context});

  final TextEditingController controller;
  final String helperText;
  final TextInputType input;
  final BuildContext context;

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  ThemeData themeData;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    debugCheckHasMediaQuery(context);
    themeData = Theme.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 292,
      child: TextField(
        keyboardType: widget.input,
        autofocus: true,
        controller: widget.controller,
        style: TextStyle(
          fontFamily: "poppins",
          fontSize: 14,
          color: themeData.primaryColor,
          textBaseline: TextBaseline.alphabetic,
        ),
        cursorColor: kAccentColor,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          filled: true,
          hintText: widget.helperText,
          hintStyle: TextStyle(
            fontFamily: "poppins",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isDark
                ? themeData.primaryColor.withAlpha(60)
                : themeData.primaryColor.withAlpha(40),
            textBaseline: TextBaseline.alphabetic,
          ),
          fillColor: isDark
              ? themeData.primaryColor.withAlpha(14)
              : themeData.primaryColor.withAlpha(7),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
    );
  }
}

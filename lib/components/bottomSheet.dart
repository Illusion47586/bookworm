import 'package:bookworm/models/books.dart';
import 'package:bookworm/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../components/button.dart';
import '../components/textBox.dart';
import 'package:bookworm/utilities/variables.dart';

Future<void> showAddNewBookBottomSheet(BuildContext context, Function f) {
  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();

  return showModalBottomSheet<void>(
    useRootNavigator: true,
    isScrollControlled: true,
    barrierColor: Colors.black.withAlpha(60),
    isDismissible: true,
    clipBehavior: Clip.none,
    backgroundColor: Theme.of(context).backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.width - 292) / 2,
              40,
              (MediaQuery.of(context).size.width - 292) / 2,
              buttonHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter new book",
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontSize: 22,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: kMasterPadding,
                ),
                TextBox(
                  helperText: "Book name",
                  controller: bookNameController,
                  context: context,
                ),
                SizedBox(
                  height: kMasterPadding - 5,
                ),
                TextBox(
                  helperText: "Author name",
                  controller: authorNameController,
                  context: context,
                ),
                SizedBox(
                  height: kMasterPadding - 5,
                ),
                returnCompulsoryAlert(context),
                SizedBox(
                  height: kMasterPadding,
                ),
                Button(
                  title: "Next",
                  icon: EvaIcons.arrowheadRight,
                  function: () {
                    if ((bookNameController.text.length > 0) &&
                        (authorNameController.text.length > 0))
                      showBookStatusBottomSheet(
                        context,
                        bookNameController.text,
                        authorNameController.text,
                        f,
                      );
                    //todo: do form validation
                  },
                  context: context,
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showBookStatusBottomSheet(
    BuildContext context, bookName, String authorName, Function f,
    {String url = null,
    bool justUpdating = false,
    Function justUpdatingFunction = null}) {
  TextEditingController chapterNameController = TextEditingController();
  TextEditingController chapterNumberController = TextEditingController();
  TextEditingController pageNumberController = TextEditingController();

  return showModalBottomSheet<void>(
    useRootNavigator: true,
    isScrollControlled: true,
    barrierColor: Colors.black.withAlpha(60),
    isDismissible: true,
    clipBehavior: Clip.none,
    backgroundColor: Theme.of(context).backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              (MediaQuery.of(context).size.width - 292) / 2,
              40,
              (MediaQuery.of(context).size.width - 292) / 2,
              buttonHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Where are you now?",
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  height: kMasterPadding,
                ),
                TextBox(
                  helperText: "Chapter name",
                  controller: chapterNameController,
                  context: context,
                ),
                SizedBox(
                  height: kMasterPadding - 5,
                ),
                TextBox(
                  helperText: "Chapter number",
                  controller: chapterNumberController,
                  input: TextInputType.number,
                  context: context,
                ),
                SizedBox(
                  height: kMasterPadding - 5,
                ),
                TextBox(
                  helperText: "Page number",
                  controller: pageNumberController,
                  input: TextInputType.number,
                  context: context,
                ),
                SizedBox(
                  height: kMasterPadding - 5,
                ),
                returnCompulsoryAlert(context),
                SizedBox(
                  height: kMasterPadding,
                ),
                Button(
                  title: "Done",
                  icon: EvaIcons.doneAll,
                  function: () async {
                    if (!justUpdating) {
                      await f(
                        Book(
                          title: bookName,
                          authorName: authorName,
                          bookCoverURL: url,
                          chapterName: chapterNameController.text,
                          chapterNumber:
                              int.parse(chapterNumberController.text),
                          pageNumber: int.parse(pageNumberController.text),
                          hours: null,
                          minutes: null,
                          AMorPM: null,
                        ),
                      );
                    } else {
                      justUpdatingFunction(
                        chapterNameController.text,
                        int.parse(chapterNumberController.text),
                        int.parse(pageNumberController.text),
                      );
                    }
                    //todo: update value of that book page number chapter etc if "justUpdating".

                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('/'),
                    );
                  },
                  context: context,
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

Container returnCompulsoryAlert(BuildContext context) {
  return Container(
    height: 56,
    width: 292,
    decoration: BoxDecoration(
      color: Theme.of(context).backgroundColor,
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
          "All fields are compulsory",
          style: TextStyle(
            fontFamily: "poppins",
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xff797979),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          EvaIcons.alertTriangle,
          size: 21,
          color: Color(0xff797979),
        )
      ],
    ),
  );
}

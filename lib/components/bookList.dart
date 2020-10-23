import 'package:bookworm/components/bookItem.dart';
import 'package:bookworm/models/books.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bookworm/utilities/constants.dart';
import 'package:flutter/painting.dart';
import 'package:auto_animated/auto_animated.dart' as aa;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MakeBookList extends StatefulWidget {
  final Function addNotif;
  final Function removeNotif;
  final BuildContext context;

  const MakeBookList({this.addNotif, this.removeNotif, this.context});

  @override
  _MakeBookListState createState() => _MakeBookListState();
}

class _MakeBookListState extends State<MakeBookList> {
  @override
  void initState() {
    super.initState();
  }

  ThemeData themeData;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    themeData = Theme.of(context);
  }

  @override
  void dispose() {
    Hive.box('books').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: ValueListenableBuilder(
        valueListenable: Hive.box('books').listenable(),
        builder: (context, box, _) {
          if (box.values.length == 0)
            return Center(
              child: Text(
                "⭐ IMPORTANT ⭐\n\n👉🏼 Go to \" ? \" in the upper-right corner first.\n\n👉🏼 Reading books is a good habit, ngl.",
                style: TextStyle(
                  fontFamily: "poppins",
                  color: themeData.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            );
          return aa.LiveList.options(
            primary: true,
            padding: EdgeInsets.only(bottom: 95),
            options: options,
            itemCount: box.length,
            itemBuilder: (context, int index, animation) {
              final book = box.getAt(index) as Book;
              return FadeTransition(
                opacity: Tween<double>(
                  begin: 0,
                  end: 1,
                ).animate(animation),
                // And slide transition
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, -0.1),
                    end: Offset.zero,
                  ).animate(animation),

                  // Paste you Widget
                  child: Dismissible(
                    key: UniqueKey(),
                    movementDuration: Duration(
                      seconds: 1,
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        //get last index
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            title: Text(
                              "Are you sure?",
                            ),
                            content: Text(
                              "You are going to delete \n\"${book.title}\"",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  box.deleteAt(index);
                                  widget.removeNotif(index);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Yes, I'm done."),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Nope, my bad."),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                    background: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          "Bye bye book.",
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: themeData.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    child: BookItem(
                      book: book,
                      index: index,
                      addNotif: widget.addNotif,
                      removeNotif: widget.removeNotif,
                    ),
                    resizeDuration: Duration(
                      milliseconds: 500,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: kMasterPadding,
              );
            },
          );
        },
      ),
    );
  }
}

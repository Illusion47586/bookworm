import 'package:bookworm/models/books.dart';
import 'package:bookworm/utilities/TextCompress.dart';
import 'package:bookworm/utilities/findBook.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bookworm/utilities/constants.dart';
import 'package:bookworm/components/bottomSheet.dart';
import 'package:flutter/painting.dart';
import 'package:bookworm/utilities/variables.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:marquee/marquee.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class BookItem extends StatefulWidget {
  BookItem({
    this.book,
    this.index,
    this.addNotif,
    this.removeNotif,
  });

  final Book book;
  final int index;
  final Function addNotif;
  final Function removeNotif;
  var time;

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  var result;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.book.bookCoverURL == null) findBookUrl(widget.book.title);
    result = DataConnectionChecker().hasConnection;
  }

  ThemeData themeData;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    themeData = Theme.of(context);
  }

  Future<void> updateLink(String link) {
    Book book = Book(
      title: widget.book.title,
      authorName: widget.book.authorName,
      bookCoverURL: link,
      chapterName: widget.book.chapterName,
      chapterNumber: widget.book.chapterNumber,
      pageNumber: widget.book.pageNumber,
      hours: widget.book.hours,
      minutes: widget.book.minutes,
      AMorPM: widget.book.AMorPM,
    );
    return Hive.box('books').putAt(widget.index, book);
    // setState(() {});
  }

  void updateTime(hours, minutes, AM_PM) {
    Book book = Book(
      title: widget.book.title,
      authorName: widget.book.authorName,
      bookCoverURL: widget.book.bookCoverURL,
      chapterName: widget.book.chapterName,
      chapterNumber: widget.book.chapterNumber,
      pageNumber: widget.book.pageNumber,
      hours: hours,
      minutes: minutes,
      AMorPM: AM_PM,
    );
    // print(book.hours);
    Hive.box('books').putAt(widget.index, book);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          showBookStatusBottomSheet(
            context,
            widget.book.title,
            widget.book.authorName,
            null,
            justUpdating: true,
            justUpdatingFunction: (
              String chapterName,
              int chapterNumber,
              int pageNumber,
            ) {
              Book book = Book(
                title: widget.book.title,
                authorName: widget.book.authorName,
                bookCoverURL: widget.book.bookCoverURL,
                chapterName: chapterName,
                chapterNumber: chapterNumber,
                pageNumber: pageNumber,
                hours: widget.book.hours,
                minutes: widget.book.minutes,
                AMorPM: widget.book.AMorPM,
              );
              Hive.box('books').putAt(widget.index, book);
            },
          );
        },
        onDoubleTap: () async {
          await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            helpText: "Select time for alarm",
          ).then(
            (time) {
              if (time.hour != null || time.hourOfPeriod != null) {
                Time finalTime = Time(
                  time.hour,
                  time.minute,
                  0,
                );
                // print("Final time:" + "${finalTime.hour}");
                widget.addNotif(
                  finalTime,
                  widget.book.title,
                  widget.book.pageNumber,
                  widget.index,
                );

                updateTime(
                  time.hourOfPeriod == 00 && time.period == DayPeriod.pm
                      ? 12
                      : time.hourOfPeriod,
                  time.minute,
                  "${time.period == DayPeriod.am ? "AM" : "PM"}",
                );
              }
            },
          );
        },
        onLongPress: () {
          widget.removeNotif(widget.index);
          updateTime(
            null,
            null,
            null,
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 60,
          height: 190,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Positioned(
                right: 0,
                child: AnimatedContainer(
                  duration: Duration(
                    milliseconds: 700,
                  ),
                  height: 190,
                  width: 287,
                  decoration: BoxDecoration(
                    color: themeData.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Color(0xffA6A6A6).withAlpha(30),
                              offset: Offset(0, 10),
                              blurRadius: 20,
                            ),
                          ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: Row(
                  children: <Widget>[
                    widget.book.bookCoverURL == null
                        ? FutureBuilder(
                            future: result,
                            builder: (context, snapshot) {
                              if (snapshot.data == true)
                                return FutureBuilder(
                                  future: findBookUrl(widget.book.title),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData ||
                                        snapshot.connectionState ==
                                            ConnectionState.done) {
                                      // print(snapshot.connectionState);
                                      // print(snapshot.data);
                                      // if (widget.book.bookCoverURL == null)
                                      // updateLink(snapshot.data);
                                      return FutureBuilder(
                                        future: updateLink(snapshot.data),
                                        builder: (context, snapshot) {
                                          // print(
                                          //     "Link updating in book: ${snapshot.connectionState}");
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Container(
                                              height: 150,
                                              width: 99,
                                              child: CachedNetworkImage(
                                                height: 150,
                                                width: 99,
                                                fit: BoxFit.fitHeight,
                                                imageUrl:
                                                    widget.book.bookCoverURL,
                                                progressIndicatorBuilder:
                                                    (context, _, progress) {
                                                  print('here!');
                                                  return Center(
                                                    child:
                                                        CircularStepProgressIndicator(
                                                      totalSteps: 100,
                                                      currentStep:
                                                          progress.downloaded,
                                                      selectedColor:
                                                          Colors.greenAccent,
                                                      unselectedColor:
                                                          Colors.grey[200],
                                                      padding: 0,
                                                      width: 40,
                                                      height: 50,
                                                      selectedStepSize: 15,
                                                      roundedCap: (_, __) =>
                                                          true,
                                                    ),
                                                  );
                                                },
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                boxShadow: isDark
                                                    ? []
                                                    : [
                                                        BoxShadow(
                                                          color: Color(
                                                                  0xffA6A6A6)
                                                              .withAlpha(40),
                                                          offset: Offset(3, 10),
                                                          blurRadius: 10,
                                                        ),
                                                      ],
                                              ),
                                            );
                                          }
                                          return AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 250,
                                            ),
                                            padding: EdgeInsets.all(15),
                                            height: 150,
                                            width: 99,
                                            child: Center(
                                              child: SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: themeData
                                                  .dialogBackgroundColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              boxShadow: isDark
                                                  ? []
                                                  : [
                                                      BoxShadow(
                                                        color: Color(0xffA6A6A6)
                                                            .withAlpha(40),
                                                        offset: Offset(3, 10),
                                                        blurRadius: 10,
                                                      ),
                                                    ],
                                            ),
                                          );
                                        },
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      print(snapshot.error);
                                      return AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 250,
                                        ),
                                        padding: EdgeInsets.all(8),
                                        height: 150,
                                        width: 99,
                                        child: Center(
                                          child: Text(
                                            "Unknown title or connection timed out",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: themeData.errorColor
                                                  .withAlpha(60),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: themeData.backgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: isDark
                                              ? []
                                              : [
                                                  BoxShadow(
                                                    color: Color(0xffA6A6A6)
                                                        .withAlpha(40),
                                                    offset: Offset(3, 10),
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                        ),
                                      );
                                    }

                                    return AnimatedContainer(
                                      duration: Duration(
                                        milliseconds: 250,
                                      ),
                                      padding: EdgeInsets.all(15),
                                      height: 150,
                                      width: 99,
                                      child: Center(
                                        child: SizedBox(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: themeData.dialogBackgroundColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        boxShadow: isDark
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: Color(0xffA6A6A6)
                                                      .withAlpha(40),
                                                  offset: Offset(3, 10),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                      ),
                                    );
                                  },
                                );
                              else
                                return AnimatedContainer(
                                  duration: Duration(
                                    milliseconds: 250,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  height: 150,
                                  width: 99,
                                  child: Center(
                                    child: Text(
                                      "Internet problem",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: themeData.primaryColor
                                            .withAlpha(60),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: themeData.backgroundColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: isDark
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: Color(0xffA6A6A6)
                                                  .withAlpha(40),
                                              offset: Offset(3, 10),
                                              blurRadius: 10,
                                            ),
                                          ],
                                  ),
                                );
                            })
                        : Container(
                            height: 150,
                            width: 99,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  widget.book.bookCoverURL,
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: isDark
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Color(0xffA6A6A6).withAlpha(40),
                                        offset: Offset(3, 10),
                                        blurRadius: 10,
                                      ),
                                    ],
                            ),
                          ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 12,
                        ),
                        getMarqueeOrNormalText(
                          title: widget.book.title,
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: themeData.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLength: 22,
                          maxWidth: MediaQuery.of(context).size.width - 200,
                          maxHeight: 21.5,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.book.authorName,
                          style: TextStyle(
                            fontFamily: "poppins",
                            color: Color(0xff797979),
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          child: RichText(
                            text: TextSpan(
                              text: "Chapter ${widget.book.chapterNumber}\n",
                              style: TextStyle(
                                fontFamily: "poppins",
                                fontWeight: FontWeight.w600,
                                color: themeData.primaryColor,
                                fontSize: 12,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: widget.book.bookCoverURL == null
                                      ? "Long press \"Hello, Reader\" \nonce internet is back"
                                      : compressTextTitle(
                                          widget.book.chapterName,
                                          maxLen: 30,
                                        ),
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    fontWeight: FontWeight.w400,
                                    color: widget.book.bookCoverURL == null
                                        ? themeData.errorColor
                                        : Color(0xff797979),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: widget.book.bookCoverURL == null ? 5 : 20,
                        ),
                        Container(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (widget.book.hours != null) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      EvaIcons.clock,
                                      color: themeData.accentColor,
                                      size: 22,
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      "${widget.book.hours < 10 ? widget.book.hours.toString().padLeft(2, '0') : widget.book.hours}:${widget.book.minutes < 10 ? widget.book.minutes.toString().padLeft(2, '0') : widget.book.minutes} ${widget.book.AMorPM}",
                                      style: TextStyle(
                                        fontFamily: "poppins",
                                        fontSize: 12,
                                        color: Color(0xff797979),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    EvaIcons.clock,
                                    color: Color(0xff909090),
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    "Double Tap to set \ndaily alarm⏰",
                                    style: TextStyle(
                                      fontFamily: "poppins",
                                      fontSize: 10,
                                      height: 1.2,
                                      color: Color(0xff797979),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: 52,
                  width: 84,
                  decoration: BoxDecoration(
                    gradient: kGradient,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "page",
                        style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withAlpha(70),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.book.pageNumber.toString(),
                        style: TextStyle(
                          fontFamily: "poppins",
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

LayoutBuilder getMarqueeOrNormalText({
  String title,
  int maxLength,
  TextStyle style,
  double maxWidth,
  double maxHeight,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (title.length > maxLength) {
        return LimitedBox(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          child: Marquee(
            text: title,
            style: style,
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 100.0,
            pauseAfterRound: Duration(seconds: 2),
            accelerationDuration: Duration(seconds: 2),
            accelerationCurve: Curves.easeIn,
            decelerationDuration: Duration(milliseconds: 900),
            decelerationCurve: Curves.easeOut,
            showFadingOnlyWhenScrolling: false,
            fadingEdgeEndFraction: .1,
          ),
        );
      }
      return Text(
        title,
        style: style,
      );
    },
  );
}

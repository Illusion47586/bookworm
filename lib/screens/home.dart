import 'package:bookworm/screens/HelpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_themes/stacked_themes.dart';
import '../models/books.dart';
import '../utilities/findBook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import '../components/button.dart';
import '../components/bookList.dart';
import '../utilities/variables.dart';
import '../components/bottomSheet.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  ThemeData themeData;
  var fltrNotification;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var androidInitialize = AndroidInitializationSettings('@drawable/app_icon');
    var iOSinitialize = IOSInitializationSettings();
    var initializationsSettings =
        InitializationSettings(androidInitialize, iOSinitialize);
    fltrNotification = FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initializationsSettings,
        onSelectNotification: notificationSelected);
    checkForIsDark();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMediaQuery(context));
    themeData = Theme.of(context);
  }

  void checkForIsDark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    if (isDark && !getThemeManager(context).isDarkMode)
      getThemeManager(context).toggleDarkLightTheme();
    // print(isDark);
  }

  Future _showNotification(
    Time time,
    String book_name,
    int page_number,
    int index,
  ) async {
    var androidDetails = AndroidNotificationDetails(
      "bookworm",
      "illusion",
      "Bookworm channel",
      importance: Importance.Max,
    );
    var iSODetails = IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(androidDetails, iSODetails);

    await fltrNotification.showDailyAtTime(
      index,
      "Time to read📚: $book_name",
      "Reading time👀, read from page: $page_number",
      time,
      generalNotificationDetails,
      payload: book_name,
    );

    // FOR DEBUG PURPOSES ONLY

    // await fltrNotification.show(
    //   index,
    //   "Time to read📚: $book_name",
    //   "Reading time👀",
    //   generalNotificationDetails,
    //   payload: book_name,
    // );
  }

  Future _removeNotification(int index) async {
    await fltrNotification.cancel(index);
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeData.backgroundColor,
        elevation: .05,
        title: Text(
          "Time to read: \n$payload",
          style: TextStyle(
            fontFamily: "poppins",
            color: themeData.primaryColor,
          ),
        ),
        content: Text(
          "Remember to update the book in app after reading",
          style: TextStyle(
            fontFamily: "poppins",
            color: Color(0xff999999),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Hive.box("books").compact();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.dialogBackgroundColor,
      body: AnimatedContainer(
        color: themeData.dialogBackgroundColor,
        duration: Duration(
          milliseconds: 250,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 60,
                    left: 30,
                    right: 30,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          "Hello, Reader",
                          style: TextStyle(
                            fontFamily: "poppins",
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: themeData.primaryColor,
                            height: 1.45,
                          ),
                        ),
                        onLongPress: () {
                          setState(() {});
                        },
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      OptionButton(
                        icon: vDayNightIcon,
                        function: () async {
                          getThemeManager(context).toggleDarkLightTheme();
                          // dayNight(context);
                          isDark = getThemeManager(context).isDarkMode;
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('isDark', isDark);
                          vDayNightIcon = isDark ? EvaIcons.sun : EvaIcons.moon;
                          print("isDark changed to ${prefs.getBool('isDark')}");
                          setState(() {});
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(HelpScreen.routename);
                        },
                        padding: EdgeInsets.zero,
                        iconSize: 27,
                        icon: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: themeData.backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Color(0xff999999),
                              width: 1.25,
                            ),
                          ),
                          child: Icon(
                            EvaIcons.questionMark,
                            color: Color(0xff999999),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: MakeBookList(
                    addNotif: _showNotification,
                    removeNotif: _removeNotification,
                    context: context,
                  ),
                ),
              ],
            ),
            // ONLY FOR DEBUG PURPOSES
            // buildDebugger(context, 0),
            // buildDebugger(context, 1),
            // buildDebugger(context, 2),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Button(
                  context: context,
                  title: "Add new book",
                  icon: EvaIcons.plusSquare,
                  function: () {
                    showAddNewBookBottomSheet(context, (Book book) {
                      print(book.pageNumber);
                      Hive.box('books').add(book);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildDebugger(BuildContext context, int i) {
    if (i == 0)
      return Positioned(
        bottom: 300,
        left: 40,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: OptionButton(
            icon: Icons.looks_two,
            function: () async {
//                      addForTest();
              await Hive.box("books").deleteAt(
                await Hive.box("books").length - 2,
              );
              await Hive.box('books').compact();
            },
          ),
        ),
      );
    else if (i == 1)
      return Positioned(
        bottom: 450,
        left: 40,
        child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: OptionButton(
              icon: EvaIcons.backspace,
              function: () {
                Hive.box('books').clear();
              },
            )),
      );
    else if (i == 2)
      return Positioned(
        bottom: 360,
        left: 40,
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: OptionButton(
            icon: EvaIcons.plusCircle,
            function: () async {
//                      addForTest();
              await Hive.box("books").add(
                Book(
                  title: "lorem",
                  authorName: "ipsum",
                  chapterName: "lorem ipsum",
                  pageNumber: 66,
                  chapterNumber: 90,
                  bookCoverURL: await findBookUrl("everything"),
                ),
              );
            },
          ),
        ),
      );
  }
}

void dayNight(BuildContext context) async {
  isDark = !isDark;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDark', isDark);

  vDayNightIcon = isDark ? EvaIcons.sun : EvaIcons.moon;
}

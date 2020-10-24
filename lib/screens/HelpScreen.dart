import 'package:app_settings/app_settings.dart';

import '../components/button.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;

// TODO: complete the HelpScreen!!!

class HelpScreen extends StatefulWidget {
  static String routename = 'HelpScreen';

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
    return Scaffold(
      body: Container(
        child: Center(
          child: AnimatedContainer(
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
                          Text(
                            "Help center",
                            style: TextStyle(
                              fontFamily: "poppins",
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: themeData.primaryColor,
                              height: 1.45,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            padding: EdgeInsets.zero,
                            iconSize: 27,
                            icon: Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: themeData.backgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Color(0xff999999),
                                  width: 1.25,
                                ),
                              ),
                              child: Icon(
                                EvaIcons.arrowBack,
                                color: Color(0xff999999),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              Text(
                                "1. Tap the card once to update the chapter and page number.\n\n2. Double tap the card to add or update the daily alarm⏰ time.\n\n3. Longpress to remove the alarm⏰.\n\n4. Swipe right or left to remove the card.\n\n5. Long press \"Hello, Reader\" for a refresh.",
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  fontSize: 16,
                                  color: themeData.primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Text(
                                "DON'T FORGET TO",
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: themeData.errorColor,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "1. Remove any battery🔋 saver settings on the app as it would disallow notifications.\n\n2. Turn autostart on.\n\n3. Also allow the app to send notifications.\n\n4. Rate this app on play store😁.",
                                style: TextStyle(
                                  fontFamily: "poppins",
                                  fontSize: 16,
                                  color: themeData.primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 96,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 76,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Button(
                      context: context,
                      title: "Open app settings",
                      icon: EvaIcons.settings,
                      function: () {
                        AppSettings.openAppSettings();
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Button(
                      context: context,
                      title: "Email me",
                      icon: EvaIcons.email,
                      function: () {
                        url.launch(
                          'mailto:illusion47586@gmail.com?subject=Bookmark%20app%20bug%20and/or%20suggestion',
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

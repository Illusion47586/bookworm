import 'package:bookworm/screens/HelpScreen.dart';
import 'package:bookworm/utilities/constants.dart';
import 'package:bookworm/utilities/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'models/books.dart';
import 'screens/home.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.initialise();

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.init(appDocumentDir.path);
  Hive.registerAdapter(BookAdapter());
  await Hive.openBox('books');

  SharedPreferences prefs = await SharedPreferences.getInstance();
  isDark = prefs.getBool('isDark') ?? false;
  print('initial isDark is $isDark');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      statusBarColorBuilder: (theme) => theme.dialogBackgroundColor,
      defaultThemeMode: ThemeMode.light,
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          primary: kAccentColor,
          primaryVariant: kAccentColor,
          secondary: Colors.grey,
          secondaryVariant: Colors.grey,
          surface: Colors.black,
          background: Colors.white,
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.grey,
          onBackground: Colors.black,
          onError: Colors.redAccent,
          brightness: Brightness.dark,
        ),
        iconTheme: IconThemeData(
          color: Color(0xff999999),
        ),
        backgroundColor: Colors.black,
        primaryColor: Colors.white,
        errorColor: Colors.redAccent,
        fontFamily: "poppins",
        brightness: Brightness.dark,
        accentColor: kAccentColor, //selection color
        dialogBackgroundColor: Color(0xff171717), //Background color
        timePickerTheme: TimePickerThemeData(
          backgroundColor: Color(0xff171717),
          dialBackgroundColor: Colors.black,
          dialTextColor: Colors.white,
          dialHandColor: kAccentColor,
          entryModeIconColor: Color(0xff797979).withAlpha(70),
        ),
      ),
      lightTheme: ThemeData(
        colorScheme: ColorScheme(
          primary: kAccentColor,
          primaryVariant: Color(0xffbe02e8),
          secondary: Colors.black,
          secondaryVariant: Colors.black,
          surface: Colors.black,
          background: Colors.white,
          error: Colors.redAccent,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.redAccent,
          brightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
          color: Color(0xff999999),
        ),
        backgroundColor: Colors.white,
        primaryColor: Colors.black,
        fontFamily: "poppins",
        errorColor: Colors.redAccent,
        brightness: Brightness.light,
        accentColor: kAccentColor, //selection color
        dialogBackgroundColor: Color(0xfffdfdfd), //Background color
        timePickerTheme: TimePickerThemeData(
          backgroundColor: Color(0xfffdfdfd),
          dialBackgroundColor: Colors.white,
          entryModeIconColor: Color(0xff797979).withAlpha(70),
          dayPeriodBorderSide: BorderSide(
            color: Color(0xff797979).withAlpha(70),
          ),
        ),
      ),
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
        theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        home: Main(),
        routes: {
          HelpScreen.routename: (context) => HelpScreen(),
        },
      ),
    );
  }
}

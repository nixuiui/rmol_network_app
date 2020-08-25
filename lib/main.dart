import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rmol_network_app/helper/simple_bloc_delegate.dart';
import 'package:rmol_network_app/ui/page/home/home_page.dart';
import 'package:rmol_network_app/ui/page/splash_screen.dart';
import 'package:timeago/timeago.dart' as Timeago;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocDelegate();
  Timeago.setLocaleMessages("id", Timeago.IdMessages());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RMOL LAMPUNG',
      routes: {
        '/home': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        accentColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          color: Colors.white,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w700
            )
          ),
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
          elevation: 0
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.black87,
            fontSize: 16
          ),
          subtitle1: TextStyle(
            color: Colors.black87,
            fontSize: 16
          ),
          button: TextStyle(
            color: Colors.white,
            fontSize: 16
          )
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
        ),
        dividerTheme: DividerThemeData(
          color: Colors.grey[200],
          thickness: 1,
          space: 0,
          indent: 0
        )
      ),
      home: SplashScreen(),
    );
  }
}
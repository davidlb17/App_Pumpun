import 'package:app/controllers/common/myhomepage_controller.dart';
import 'package:app/controllers/common/shared_preferences_controller.dart';
import 'package:app/controllers/database/sqlite_service.dart';
import 'package:app/data/dummy/dummy_bryan.dart';
import 'package:app/widgets/themes/dark_theme.dart';
import 'package:app/widgets/themes/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/common/configuration.dart';

void main() {
  DummyBryan();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // void changeTheme() {
  //   bool error = false;
  //   setState(() {
  //     error = widget.settingsController.changeSettings(context);
  //     if (!error) {
  //       SharedPreferencesController().saveUser();
  //     }
  //     ThemeConstants.changeToAqua();
  //   });
  //   if (!error) {
  //     Navigator.pop(context);
  //   }
  // }

  void changeTheme() {
    setState(() {
      Configuration.theme.value();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      SharedPreferencesController().loadUser().then((value) => changeTheme());
    });
  }

  //use the future builder to ensure the ddbb and initial data are creted before using the data on the pages
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      themeMode: ThemeMode.system,
      theme: LightTheme().materialTheme,
      darkTheme: DarkTheme().materialTheme,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: SQLiteService.initializeDB(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MyHomePageController(
              onChangeTheme: changeTheme,
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

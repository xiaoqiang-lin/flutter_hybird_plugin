/*
 * @Description:
 * @Author: iamsmiling
 * @Date: 2021-10-08 19:29:38
 * @LastEditTime: 2021-10-11 14:58:12
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_module_using_plugin/app_theme.dart';
import 'package:flutter_module_using_plugin/blocs/habit/habit_bloc.dart';
import 'package:flutter_module_using_plugin/blocs/habit/habit_event.dart';
import 'package:flutter_module_using_plugin/blocs/theme/theme_bloc.dart';
import 'package:flutter_module_using_plugin/blocs/theme/theme_event.dart';
import 'package:flutter_module_using_plugin/blocs/theme/theme_state.dart';
import 'package:flutter_module_using_plugin/home_screen.dart';
import 'package:flutter_module_using_plugin/notification/notification_plugin.dart';
import 'package:flutter_module_using_plugin/utils/date_util.dart';

import 'blocs/bloc_observer.dart';
import 'cell.dart';
import 'models/user.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  NotificationPlugin.ensureInitialized();
  // runApp(MyApp());
  await SessionUtils.sharedInstance().init();
  runApp(MyApp());
  // await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]).then((_) => runApp(MyApp()));
}

/// This is on alternate entrypoint for this module to display Flutter UI in
/// a (multi-)view integration scenario.
// This is unfortunately in this file due to
// https://github.com/flutter/flutter/issues/72630.
void showCell() {
  // Bloc.observer = SimpleBlocObserver();
  // WidgetsFlutterBinding.ensureInitialized();
  // NotificationPlugin.ensureInitialized();
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc()..add(ThemeLoadEvnet()),
      child: BlocProvider<HabitsBloc>(
        create: (context) => HabitsBloc()..add(HabitsLoad()),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            Future.delayed(
                Duration(milliseconds: DateUtil.millisecondsUntilTomorrow()),
                () {
              BlocProvider.of<HabitsBloc>(context).add(HabitsLoad());
            });
            SessionUtils.sharedInstance()
                .setBloc(BlocProvider.of<HabitsBloc>(context));
            return MaterialApp(
              title: 'Checkio',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.appTheme
                  .themeData()
                  .copyWith(platform: TargetPlatform.iOS),
              home: HomeScreen(),
            );
          },
        ),
      ),
    );
  }
}

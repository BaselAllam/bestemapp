import 'package:bestemapp/app_settings_app/logic/app_settings_cubit.dart';
import 'package:bestemapp/app_settings_app/logic/app_settings_states.dart';
import 'package:bestemapp/app_settings_app/screens/splash_screen.dart';
import 'package:bestemapp/car_app/logic/car_cubit.dart';
import 'package:bestemapp/notification_app/logic/notification_cubit.dart';
import 'package:bestemapp/user_app/logic/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppSettingsCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(),
        ),
        BlocProvider(
          create: (context) => CarCubit(),
        ),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsStates>(
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: BlocProvider.of<AppSettingsCubit>(context).selectedLocale,
          supportedLocales: [Locale('ar'), Locale('en')],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          home: SplashScreen(),
        ),
      ),
    );
  }
}
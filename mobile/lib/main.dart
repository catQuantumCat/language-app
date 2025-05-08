// ignore_for_file: unused_import

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:language_app/common/constants/storage_keys.dart';
import 'package:language_app/common/enums/auth_state_enum.dart';
import 'package:language_app/configs/di/dependency_injection.dart';
import 'package:language_app/configs/inteceptors/dio_inteceptor.dart';
import 'package:language_app/configs/router/app_router.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/modules/auth/bloc/auth_bloc.dart';
import 'package:language_app/modules/home/home_view.dart';
import 'package:language_app/modules/navigation/navigation_view.dart';
import 'package:language_app/theme/app_theme.dart';
import 'package:language_app/theme/button_theme.dart';
import 'package:language_app/theme/color_theme.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  await init();
  runApp(const MyApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await DependencyInjection.setup(getIt);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //must add a base context to provide auth
    return BlocProvider(
      create: (context) => AuthBloc(userRepo: getIt.get<UserRepo>()),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AppStateEnum.initial) {
            MaterialApp(
              home: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme(
                    colorTheme: ColorTheme.light,
                    buttonTheme: CustomButtonTheme.palette(ColorTheme.light))
                .themeData,
            routerConfig: AppRouter(authBloc: context.read<AuthBloc>()).router,
          );
        },
      ),
    );
  }
}

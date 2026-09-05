import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/core/fcm/fcm_service.dart';
import 'package:capster_barbertech/core/fcm/firebase_options.dart';
import 'package:capster_barbertech/features/auth/data/session/auth_session_repository_impl.dart';
import 'package:capster_barbertech/features/auth/domain/login_usecase.dart';
import 'package:capster_barbertech/features/auth/domain/session/auth_session_repository.dart';
import 'package:capster_barbertech/features/auth/login/login_page.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'features/onboarding/onboarding_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setupLocator();

  final sessionRepo = locator<AuthSessionRepository>();

  if (sessionRepo is AuthSessionRepositoryImpl) {
    await sessionRepo.loadSession();
  }

  final fcmService = FcmService();
  await fcmService.requestPermission();
  await fcmService.getToken();
  fcmService.listenForegroundMessages();
  fcmService.listenTokenRefresh();

  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const FullScreenCastApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Capster Barbertech",
      debugShowCheckedModeBanner: false,

      initialRoute: "/onboarding",

      onGenerateRoute: (settings) {
        switch (settings.name) {

          case "/onboarding":
            return MaterialPageRoute(
              builder: (_) => OnboardingPage(),
            );

          case "/login":
            return MaterialPageRoute(
              builder: (_) => LoginPage(
                loginUseCase: locator<LoginUseCase>(),
                takeAndAnalyzePhotoUseCase:
                    locator<TakeAndAnalyzePhotoUseCase>(),
              ),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => OnboardingPage(),
            );
        }
      },
    );
  }
}


class FullScreenCastApp extends StatelessWidget {
  const FullScreenCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Builder(
            builder: (context) {
              final size = MediaQuery.of(context).size;

              return RotatedBox(
                quarterTurns: 1, 
                child: Container(
                  width: size.height,
                  height: size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const MyApp(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

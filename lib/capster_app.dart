import 'package:capster_barbertech/features/auth/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/features/onboarding/onboarding_page.dart';

class CapsterApp extends StatelessWidget {
  const CapsterApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: "/onboarding",

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/onboarding":
            return MaterialPageRoute(builder: (_) => OnboardingPage());
        }
        return null;
      },
    );
  }
}

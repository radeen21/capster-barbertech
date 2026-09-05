import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/features/auth/domain/login_usecase.dart';
import 'package:capster_barbertech/features/auth/domain/logout_usecase.dart';
import 'package:capster_barbertech/features/capster_root_page.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/features/auth/domain/login_usecase.dart';
import 'package:capster_barbertech/features/auth/domain/logout_usecase.dart';
import 'package:capster_barbertech/features/capster_root_page.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final LoginUseCase loginUseCase;
  final TakeAndAnalyzePhotoUseCase takeAndAnalyzePhotoUseCase;

  const LoginPage({
    super.key,
    required this.loginUseCase,
    required this.takeAndAnalyzePhotoUseCase,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _CapsterAccount {
  final String name;
  final String email;
  final String password;
  final String branch;

  const _CapsterAccount({
    required this.name,
    required this.email,
    required this.password,
    required this.branch,
  });
}

class _LoginPageState extends State<LoginPage> {
  _CapsterAccount? _selectedCapster;

  final List<_CapsterAccount> _capsters = const [
    _CapsterAccount(
      name: "Sahrul",
      email: "sahrul@mail.com",
      password: "Capster.Sahrul.123!",
      branch: "Buaran",
    ),
    _CapsterAccount(
      name: "Fandi",
      email: "fandi@mail.com",
      password: "Capster.Fandi.123!",
      branch: "Buaran",
    ),
    _CapsterAccount(
      name: "Hendar",
      email: "hendar@mail.com",
      password: "Capster.Hendar.123!",
      branch: "Buaran",
    ),
    _CapsterAccount(
      name: "Miftah",
      email: "miftah@mail.com",
      password: "Capster.Miftah.123!",
      branch: "Buaran",
    ),
    _CapsterAccount(
      name: "Pirlo",
      email: "pirlo@mail.com",
      password: "Capster.Pirlo.123!",
      branch: "Buaran",
    ),

    _CapsterAccount(
      name: "Danny",
      email: "danny@mail.com",
      password: "Capster.Danny.123!",
      branch: "Pondok Bambu",
    ),
    _CapsterAccount(
      name: "Abdul",
      email: "abdul@mail.com",
      password: "Capster.Abdul.123!",
      branch: "Pondok Bambu",
    ),
    _CapsterAccount(
      name: "Ragis",
      email: "ragis@mail.com",
      password: "Capster.Ragis.123!",
      branch: "Pondok Bambu",
    ),
  ];

  String? _errorMessage;
  bool _hasError = false;

  bool get _isFormValid => _selectedCapster != null;

  @override
  void initState() {
    super.initState();
    debugPrint("📱 LoginPage OPENED");
  }

  Future<void> _handleLogin() async {
    if (_selectedCapster == null) return;

    final email = _selectedCapster!.email;
    final password = _selectedCapster!.password;

    _showLoading(context);

    try {
      final userEntity = await widget.loginUseCase(email, password);

      if (userEntity == null) {
        throw Exception("User entity null");
      }

      _hideLoading(context);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => CapsterRootPage(
            userEntity: userEntity,
            takePhotoUseCase: locator<TakeAndAnalyzePhotoUseCase>(),
            logoutUseCase: locator<LogoutUseCase>(),
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      _hideLoading(context);

      setState(() {
        _hasError = true;
        _errorMessage = "Login capster gagal";
      });
    }
  }

  @override
  void dispose() {
    debugPrint("📱 LoginPage CLOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Center(
                child: Image.asset("assets/logo_barbertech.png", width: 120),
              ),

              const SizedBox(height: 40),

              DropdownButtonFormField<_CapsterAccount>(
                value: _selectedCapster,
                isExpanded: true,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Pilih Capster",
                  labelStyle: TextStyle(
                    color: _hasError ? Colors.red : Colors.white70,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _hasError ? Colors.red : Colors.white24,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _hasError ? Colors.red : Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _capsters.map((capster) {
                  return DropdownMenuItem(
                    value: capster,
                    child: Text(
                      "${capster.name ?? '-'}",
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCapster = value;
                    _hasError = false;
                    _errorMessage = null;
                  });
                },
              ),

              const SizedBox(height: 20),

              if (_hasError && _errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? const Color(0xFFF6AD03)
                        : const Color(0xFF444444),
                    foregroundColor: const Color(0xFF010101),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isFormValid ? _handleLogin : null,
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (_) => const Center(
      child: CircularProgressIndicator(color: Color(0xFFF6AD03)),
    ),
  );
}

void _hideLoading(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

Future<void> forcePortrait() async {

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);
}

Future<void> forceLandscape() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);
}

import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/features/auth/domain/logout_usecase.dart';
import 'package:capster_barbertech/features/auth/domain/user_entity.dart';
import 'package:capster_barbertech/features/home/capsterHome/home_capster_page.dart';
import 'package:capster_barbertech/features/home/customerRecord/customer_record_page.dart';
import 'package:capster_barbertech/features/home/customerRecord/presentation/capster_history_controller.dart';
import 'package:capster_barbertech/features/home/profile/akun_capster_page.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:flutter/material.dart';

class CapsterRootPage extends StatefulWidget {
  final UserEntity userEntity;
  final TakeAndAnalyzePhotoUseCase takePhotoUseCase;
  final LogoutUseCase logoutUseCase;
  // final CapsterHistoryController capsterHistoryController;

  const CapsterRootPage({
    super.key,
    required this.userEntity,
    required this.takePhotoUseCase,
    required this.logoutUseCase,
    // required this.capsterHistoryController,
  });

  @override
  State<CapsterRootPage> createState() => _CapsterRootPageState();
}

class _CapsterRootPageState extends State<CapsterRootPage> {
  int _currentIndex = 0;

  late final CapsterHistoryController _historyController;

  @override
  void initState() {
    super.initState();
    _historyController = locator<CapsterHistoryController>();
    _historyController.fetch();

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (_currentIndex != 0) {
          // kalau lagi bukan di tab home → balik ke home dulu
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: IndexedStack(
          index: _currentIndex,
          children: [
           
            HomeCapsterPage(
              user: widget.userEntity,
              takePhotoUseCase: widget.takePhotoUseCase,
            ),

            CustomerRecordPage(
              histories: _historyController.histories,
              onRefresh: () async {
                await _historyController.fetch();
              },
            ),

            AkunCapsterPage(
              capsterName: widget.userEntity.fullName,
              logoutUseCase: widget.logoutUseCase,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: const Color(0xFFF6AD03),
          unselectedItemColor: Colors.white38,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Customer Record",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
          ],
        ),
      ),
    );
  }
}

import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/core/dio_client.dart';
import 'package:capster_barbertech/features/auth/domain/user_entity.dart';
import 'package:capster_barbertech/features/home/customerRecord/customer_record_page.dart';
import 'package:capster_barbertech/features/home/customerRecord/domain/capster_history_entity.dart';
import 'package:capster_barbertech/features/home/customerRecord/presentation/capster_history_controller.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/data/gromming_service_remote_data_source.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/data/gromming_service_repository_impl.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_usecase.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/gromming_service_page.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/presentation/gromming_service_controller.dart';
import 'package:flutter/material.dart';

class HomeCapsterPage extends StatefulWidget {
  final UserEntity user;
  final TakeAndAnalyzePhotoUseCase takePhotoUseCase;

  const HomeCapsterPage({
    super.key,
    required this.user,
    required this.takePhotoUseCase,
  });

  @override
  State<HomeCapsterPage> createState() => _HomeCapsterPageState();
}

class _HomeCapsterPageState extends State<HomeCapsterPage> {
  late final CapsterHistoryController _historyController;

  @override
  void initState() {
    super.initState();
    _historyController = locator<CapsterHistoryController>();
    _historyController.fetch();
  }

  @override
  Widget build(BuildContext context) {
    const int maxTarget = 12000000;
    final int targetApi = widget.user.target;

    final int percent = maxTarget == 0
        ? 0
        : ((targetApi / maxTarget) * 100).toInt();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.orange,
          onRefresh: () async {
            await _historyController.fetch();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 10),

              /// LOGO + NOTIF
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/logo_barbertech.png", width: 50),
                  const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// GREETING
              Text(
                "Halo Capster, ${widget.user.fullName}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// TARGET SECTION
              _targetSection(percent),

              const SizedBox(height: 25),

              /// SERVICE SECTION
              _serviceSection(),

              const SizedBox(height: 30),

              /// LATEST ACTIVITY
              _latestActivitySection(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ============================
  // TARGET SECTION
  // ============================
  Widget _targetSection(int percent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Target Achievement",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Target pendapatan (12 Juta)",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: percent >= 100 ? Colors.blue : Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        percent >= 100 ? "Achieved" : "On Track",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "100% / ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF6AD03),
                      ),
                    ),
                    Text(
                      "$percent%",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================
  // SERVICE SECTION
  // ============================
  Widget _serviceSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GrommingServicesPage(
              controller: GrommingServicesController(
                GetGroomingServicesUseCase(
                  GrommingServiceRepositoryImpl(
                    GrommingServiceRemoteDataSource(DioClient.create()),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(14),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Image.asset(
                  "assets/banner_service.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  color: const Color(0xFF141414),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Services",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
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

  // ============================
  // LATEST ACTIVITY
  // ============================
  Widget _latestActivitySection() {
    return AnimatedBuilder(
      animation: _historyController,
      builder: (_, __) {
        if (_historyController.isLoading) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }

        final items = _historyController.histories;

        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Belum ada aktivitas",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final top3 = items.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Latest Activity",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...top3.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.memberName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        _statusBadge(item),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item.lastServiceType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const Divider(height: 20, color: Colors.white12),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statusBadge(CapsterHistoryEntity item) {
    final isDone = item.isDone;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDone
            ? Colors.green.withOpacity(0.2)
            : Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isDone ? "Done" : "On Going",
        style: TextStyle(
          color: isDone ? Colors.green : Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

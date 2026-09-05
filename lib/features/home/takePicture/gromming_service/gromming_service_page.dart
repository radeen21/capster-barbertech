import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/features/auth/domain/session/auth_session_repository.dart';
import 'package:capster_barbertech/features/home/takePicture/add-on/take_add_on_picture_page.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/presentation/gromming_service_controller.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/service_bridging_page.dart';
import 'package:capster_barbertech/features/home/starService/service_start_page.dart';
import 'package:capster_barbertech/features/home/takePicture/presentation/take_photo_controller.dart';
import 'package:capster_barbertech/features/home/takePicture/take_photo_page.dart';
import 'package:flutter/material.dart';

class GrommingServicesPage extends StatefulWidget {
  final GrommingServicesController controller;

  const GrommingServicesPage({super.key, required this.controller});

  @override
  State<GrommingServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<GrommingServicesPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.fetchServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Services",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (_, __) {
          if (widget.controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.controller.services.length,
            itemBuilder: (_, index) {
              final service = widget.controller.services[index];

              return GestureDetector(
                onTap: () {
                  final session = locator<AuthSessionRepository>();
                  final role = session.getRole(); 

                  if (role != "capster") {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Fitur ini hanya untuk capster"),
                      ),
                    );
                    return;
                  }
                  
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceStartPage(service: service),
                      ),
                    );
                    return;
                  
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service.description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          "assets/banner_grooming.png",
                          width: 70,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool _needBridging(String serviceName) {
    final name = serviceName.toLowerCase();

    return name.contains("color") ||
        name.contains("perming") ||
        name.contains("smoothing");
  }
}

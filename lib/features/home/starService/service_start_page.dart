import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/features/auth/domain/session/auth_session_repository.dart';
import 'package:capster_barbertech/features/capster_root_page.dart';
import 'package:capster_barbertech/features/home/starService/presentation/start_service_controller.dart';
import 'package:capster_barbertech/features/home/takePicture/add-on/take_add_on_picture_page.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/take_and_analyze_photo_usecase.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/dialog/start_service_dialog.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/service_bridging_page.dart';
import 'package:capster_barbertech/features/home/takePicture/presentation/take_photo_controller.dart';
import 'package:capster_barbertech/features/home/takePicture/take_photo_page.dart';
import 'package:flutter/material.dart';

class ServiceStartPage extends StatelessWidget {
  final GrommingServiceEntity service;

  const ServiceStartPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Service Detail",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// NAMA SERVICE
            Text(
              service.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// DESKRIPSI
            Text(
              service.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 24),

            /// INFO
            _infoRow("Harga", "Rp ${service.price}"),

            const Spacer(),

            /// =================================
            /// BUTTON LANJUT HAIRGUIDE / FOTO
            /// =================================
            if (service.isAllowPhoto) ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_needBridging(service.name)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ServiceBridgingPage(
                            service: service,
                            onContinue: (extraData) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TakeAddOnPicturePage(
                                    service: service,
                                    addOnPayload: extraData,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TakePhotoPage(
                          controller: locator<TakePhotoController>(),
                          service: service,
                        ),
                      ),
                    );
                  },
                  child: const Text("Lanjut Hairguide"),
                ),
              ),
              const SizedBox(height: 12),
            ],

            /// =================================
            /// BUTTON MULAI SERVICE (TETAP ADA)
            /// =================================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF6AD03),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final controller = locator<StartServiceController>();

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      barrierColor: Colors.black54,
                      pageBuilder: (_, __, ___) => StartServiceDialogPage(
                        onSubmit: (phone) async {
                          final success = await controller.startService(
                            phoneNumber: phone,
                            serviceId: service.id,
                            haircutName: service.name,
                            addOns: const [],
                          );

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Service berhasil dimulai"),
                              ),
                            );

                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  controller.error ?? "Terjadi kesalahan",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Mulai Service",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// BUTTON MULAI
            // SizedBox(
            //   width: double.infinity,
            //   height: 52,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xFFF6AD03),
            //       foregroundColor: Colors.black,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     onPressed: () {
            //       final controller = locator<StartServiceController>();

            //       StartServiceDialog.show(
            //         context,
            //         onSubmit: (phone) async {
            //           final success = await controller.startService(
            //             phoneNumber: phone,
            //             serviceId: service.id,
            //             haircutName: service.name,
            //             addOns: const [], // isi dari selection kalau ada
            //           );

            //           if (success) {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               const SnackBar(
            //                 content: Text("Service berhasil dimulai"),
            //               ),
            //             );

            //             Navigator.pop(context);
            //           } else {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(
            //                 content: Text(
            //                   controller.error ?? "Terjadi kesalahan",
            //                 ),
            //               ),
            //             );
            //           }
            //         },
            //       );
            //     },

            //     child: const Text(
            //       "Mulai Service",
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LABEL (TOP)
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),

          const SizedBox(height: 6),

          /// VALUE (BOTTOM)
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

bool _needBridging(String serviceName) {
  final name = serviceName.toLowerCase();

  return name.contains("color") ||
      name.contains("perming") ||
      name.contains("smoothing");
}

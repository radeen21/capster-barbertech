import 'dart:typed_data';
import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/features/home/starService/presentation/start_service_controller.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/photo_repository.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/dialog/start_service_dialog.dart';
import 'package:capster_barbertech/features/home/takePicture/hairGuideDetail/addon/add_on_page.dart';
import 'package:flutter/material.dart';

class HairResultPreviewPage extends StatefulWidget {
  final Uint8List imageBytes;
  final String generatedPhotoId;
  final bool hasAddons;
  final String serviceId;
  final String haircutName;
  final PhotoRepository photoRepository;

  const HairResultPreviewPage({
    super.key,
    required this.imageBytes,
    required this.generatedPhotoId,
    required this.hasAddons,
    required this.serviceId,
    required this.haircutName,
    required this.photoRepository,
  });

  @override
  State<HairResultPreviewPage> createState() => _HairResultPreviewPageState();
}

class _HairResultPreviewPageState extends State<HairResultPreviewPage> {
  List<Map<String, dynamic>> _selectedAddOns = [];
  bool _isStartingService = false; // 🔥 loading flag

  @override
void initState() {
  super.initState();

  debugPrint("✂️ HAIRCUT NAME = ${widget.haircutName}");
  debugPrint("🆔 GENERATED PHOTO ID = ${widget.generatedPhotoId}");
  debugPrint("🖼 IMAGE BYTES LENGTH = ${widget.imageBytes.length}");
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Preview Hasil",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // =====================
          // MAIN CONTENT
          // =====================
          Column(
            children: [
              // IMAGE
              Expanded(
                child: Center(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        widget.imageBytes,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              // BUTTON AREA
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Column(
                  children: [
                    // ADD ON
                    if (widget.hasAddons)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_isStartingService) return;

                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddOnPage(
                                  photoRepository: widget.photoRepository,
                                  photoId: widget.generatedPhotoId,
                                  serviceId: widget.serviceId,
                                  baseImage: widget.imageBytes,
                                ),
                              ),
                            );

                            if (result != null && mounted) {
                              setState(() {
                                _selectedAddOns = result["addons"];
                              });
                            }
                          },
                          child: const Text("Add On"),
                        ),
                      ),

                    const SizedBox(height: 10),

                    // MULAI CUKUR
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
                          if (_isStartingService) return;

                          final controller = locator<StartServiceController>();

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              barrierColor: Colors.black54,
                              pageBuilder: (_, __, ___) =>
                                  StartServiceDialogPage(
                                    onSubmit: (phone) async {
                                      final success = await controller
                                          .startService(
                                            phoneNumber: phone,
                                            serviceId: widget.serviceId,
                                            haircutName: widget.haircutName,
                                            addOns: _selectedAddOns,
                                          );

                                      if (!mounted) return;

                                      if (success) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Service berhasil dimulai",
                                            ),
                                          ),
                                        );

                                        Navigator.pop(context); // tutup dialog
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              controller.error ??
                                                  "Terjadi kesalahan",
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
                          "Mulai Cukur",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // =====================
          // LOADING OVERLAY
          // =====================
          if (_isStartingService)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true, // 🔒 block semua klik
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFFF6AD03)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

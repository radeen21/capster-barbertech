import 'dart:io';
import 'package:camera/camera.dart';
import 'package:capster_barbertech/core/di/service_locator.dart';
import 'package:capster_barbertech/features/home/customerRecord/finishService/domain/upload_photo_usecase.dart';
import 'package:capster_barbertech/features/home/customerRecord/finishService/presentation/finish_service_controller.dart';
import 'package:flutter/material.dart';

class CapsterFinishServicePage extends StatefulWidget {
  final String historyId;
  final String customerName;

  const CapsterFinishServicePage({
    super.key,
    required this.historyId,
    required this.customerName,
  });

  @override
  State<CapsterFinishServicePage> createState() =>
      _CapsterFinishServicePageState();
}

class _CapsterFinishServicePageState extends State<CapsterFinishServicePage> {
  CameraController? cameraController;
  File? _capturedPhoto;

  bool isCapturing = false;
  bool isUploading = false;
  late final FinishServiceController _finishController;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _finishController = locator<FinishServiceController>();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
      );

      cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint("❌ Camera init error: $e");
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  // =====================
  // 📸 CAPTURE PHOTO
  // =====================
  Future<void> _capturePhoto() async {
    if (cameraController == null || !cameraController!.value.isInitialized)
      return;

    setState(() => isCapturing = true);

    try {
      final picture = await cameraController!.takePicture();
      setState(() => _capturedPhoto = File(picture.path));
    } catch (e) {
      debugPrint("❌ Capture error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mengambil foto")));
    } finally {
      if (mounted) setState(() => isCapturing = false);
    }
  }

  // =====================
  // ☁️ SUBMIT FINISH SERVICE
  // =====================
  Future<void> _submit() async {
    if (_capturedPhoto == null) return;

    setState(() => isUploading = true);

    try {
      // 1️⃣ upload foto
      final uploadUseCase = locator<UploadPhotoUseCase>();

      final photoUrl = await uploadUseCase.execute(_capturedPhoto!);

      debugPrint("📸 uploaded photo url = $photoUrl");

      // 2️⃣ finish service
      await _finishController.finish(
        historyId: widget.historyId,
        photoUrl: photoUrl,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
      // 3️⃣ balik ke home capster
      // Navigator.of(context).popUntil((route) => route.isFirst);
      const SnackBar(content: Text("sukses menyelesaikan service"));
    } catch (e, s) {
      debugPrint("❌ Finish service error: $e");
      debugPrintStack(stackTrace: s);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyelesaikan service")),
      );
    } finally {
      if (mounted) setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPreview = _capturedPhoto != null;

    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isCapturing || isUploading,
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text(
                "Upload Foto",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    widget.customerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// 📷 CAMERA FRAME
                          Container(
                            width: 353,
                            height: 353,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: isPreview
                                      ? Image.file(
                                          _capturedPhoto!,
                                          fit: BoxFit.cover,
                                        )
                                      : (cameraController
                                                ?.value
                                                .isInitialized ??
                                            false)
                                      ? CameraPreview(cameraController!)
                                      : const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                  // CustomPaint(
                                  //   painter: CameraFramePainter(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Ambil foto customer setelah selesai service",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: isPreview
                        ? Row(
                            children: [
                              Expanded(
                                child: _buttonGrey("Ulangi", () {
                                  setState(() => _capturedPhoto = null);
                                  cameraController?.resumePreview();
                                }),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: _button("Selesai", _submit)),
                            ],
                          )
                        : _button("Ambil Foto", _capturePhoto),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (isCapturing) _loadingOverlay("Mengambil foto..."),
        if (isUploading) _loadingOverlay("Menyelesaikan service..."),
      ],
    );
  }

  // =====================
  // UI HELPERS
  // =====================

  Widget _loadingOverlay(String text) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14, // 🔥 atur di sini
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF6AD03),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buttonGrey(String text, VoidCallback onPressed) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

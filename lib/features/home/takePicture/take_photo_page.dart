import 'dart:io';
import 'package:camera/camera.dart';
import 'package:capster_barbertech/features/home/takePicture/camera_frame_painter.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';
import 'package:capster_barbertech/features/home/takePicture/hairGuideDetail/hair_guide_detail_page.dart';
import 'package:capster_barbertech/features/home/takePicture/presentation/take_photo_controller.dart';
import 'package:capster_barbertech/features/home/takePicture/presentation/take_photo_state.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class TakePhotoPage extends StatefulWidget {
  final TakePhotoController controller;
  final GrommingServiceEntity service;

  const TakePhotoPage({
    super.key,
    required this.controller,
    required this.service,
  });

  @override
  State<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  CameraController? cameraController;
  File? _capturedPhoto;

  bool isUploading = false;
  bool isCapturing = false;

  final faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    _initCamera();
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
      debugPrint("Kamera gagal: $e");
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    faceDetector.close();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    setState(() => isCapturing = true);

    try {
      final picture = await cameraController!.takePicture();
      final file = File(picture.path);

      final inputImage = InputImage.fromFile(file);
      await faceDetector.processImage(inputImage);

      setState(() => _capturedPhoto = file);
    } catch (e) {
      debugPrint("Capture error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal mengambil foto")));
    } finally {
      if (mounted) setState(() => isCapturing = false);
    }
  }

  Future<void> _uploadPhoto() async {
  if (_capturedPhoto == null) return;

  setState(() => isUploading = true);

  try {
    await widget.controller.uploadPhoto(
      path: _capturedPhoto!.path,
      serviceId: widget.service.id,
    );

    final state = widget.controller.state;

    if (!mounted) return;

    if (state is TakePhotoSuccess) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HairGuideDetailPage(
            analyzeData: state.analyzeResponse["data"],
            generatedData: state.generateResponse["data"],
            userImage: state.uploadResponse["data"]["url"],
            userId: widget.controller.userId,
            hasAddons: widget.service.hasAddons,
            serviceId: widget.service.id,
          ),
        ),
      );

      setState(() {
        _capturedPhoto = null;
        cameraController?.resumePreview();
      });
    } else if (state is TakePhotoError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: 
        Text(
          e.toString().replaceFirst("Exception: ", ""),
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() => isUploading = false);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final isPreview = _capturedPhoto != null;

    return Stack(
      children: [
        
        AbsorbPointer(
          absorbing: isUploading || isCapturing,
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                "Customer Profiles",
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        
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
                                ),
                                CustomPaint(painter: CameraFramePainter()),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Ambil foto wajah depan customer.",
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
                              Expanded(child: _button("Upload", _uploadPhoto)),
                            ],
                          )
                        : _button("Ambil Foto", _capturePhoto),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// 🔵 LOADING CAPTURE
        if (isCapturing) _loadingOverlay("Mengambil foto..."),

        /// 🟠 LOADING UPLOAD
        if (isUploading) _loadingOverlay("Mengupload & menganalisis foto..."),
      ],
    );
  }

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
              style: const TextStyle(color: Colors.white70, fontSize: 16),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

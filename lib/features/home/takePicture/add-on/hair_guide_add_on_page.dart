import 'package:capster_barbertech/core/env/env_config.dart';
import 'package:capster_barbertech/features/home/starService/service_start_page.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HairGuideAddOnPage extends StatelessWidget {
  final String imageUrl;
  final GrommingServiceEntity service;

  const HairGuideAddOnPage({super.key, required this.imageUrl, required this.service});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("session_token");
  }

  String _resolveImageUrl() {
    if (imageUrl.startsWith("http")) {
      return imageUrl;
    }

    final cleanPath = imageUrl.startsWith("/")
        ? imageUrl.substring(1)
        : imageUrl;

    return "${EnvConfig.baseUrl}/photos/$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = _resolveImageUrl();

    debugPrint("🖼️ IMAGE URL: $resolvedUrl");

    return Scaffold(
      backgroundColor: Colors.black,

      /// ======================
      /// APPBAR
      /// ======================
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,

        /// 🔥 ICON BACK PUTIH
        iconTheme: const IconThemeData(color: Colors.white),

        /// 🔥 TITLE TEXT PUTIH
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),

        /// 🔥 ACTION ICON PUTIH (kalau ada icon kanan)
        actionsIconTheme: const IconThemeData(color: Colors.white),

        title: const Text("Hair Guide Add-On"),
      ),

      /// ======================
      /// BODY
      /// ======================
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: _getToken(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              );
            }

            return Center(
              child: Image.network(
                resolvedUrl,
                headers: {"Authorization": "Bearer ${snapshot.data}"},
                fit: BoxFit.contain,
                loadingBuilder: (_, child, loading) {
                  if (loading == null) return child;
                  return const CircularProgressIndicator(color: Colors.orange);
                },
                errorBuilder: (_, error, __) {
                  debugPrint("❌ IMAGE ERROR: $error");
                  return const Text(
                    "Gagal memuat gambar",
                    style: TextStyle(color: Colors.white70),
                  );
                },
              ),
            );
          },
        ),
      ),

      /// ======================
      /// 🔥 BUTTON PALING BAWAH
      /// ======================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: SizedBox(
            height: 55,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF6AD03),
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                 Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceStartPage(service: service),
                      ),
                    );
              },
              child: const Text(
                "Lanjut",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

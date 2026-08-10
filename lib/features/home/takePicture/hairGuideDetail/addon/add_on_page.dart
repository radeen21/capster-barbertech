import 'dart:typed_data';
import 'package:capster_barbertech/core/dio_client.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/photo_repository.dart';
import 'package:flutter/material.dart';

class AddOnPage extends StatefulWidget {
  final PhotoRepository photoRepository;
  final String photoId;
  final String serviceId;
  final Uint8List baseImage;

  const AddOnPage({
    super.key,
    required this.photoRepository,
    required this.photoId,
    required this.serviceId,
    required this.baseImage,
  });

  @override
  State<AddOnPage> createState() => _AddOnPageState();
}

class _AddOnPageState extends State<AddOnPage> {
  bool _loadingAddOns = true;
  bool _generating = false;

  Map<String, dynamic> addOns = {};
  List<Map<String, dynamic>> _selectedAddOns = [];

  late Uint8List previewImage;

  @override
  void initState() {
    super.initState();
    previewImage = widget.baseImage;
    _fetchAddOns();
  }

  // =====================
  // FETCH ADD ONS (SAMA)
  // =====================
  Future<void> _fetchAddOns() async {
    try {
      final dio = DioClient.create();
      final res = await dio.get("/add-ons/${widget.serviceId}");

      setState(() {
        addOns = res.data["data"] ?? {};
        _loadingAddOns = false;
      });
    } catch (e) {
      _loadingAddOns = false;
    }
  }

  // =====================
  // GENERATE ADD ON (SAMA)
  // =====================
  Future<void> _submitAddOn() async {
    if (_selectedAddOns.isEmpty) return;

    setState(() => _generating = true);

    try {
      final res = await widget.photoRepository.generateImageAddOn(
        photoId: widget.photoId,
        addOn: _mapAddOnsToPayload(),
      );

      final url = res["data"]["url"];
      final bytes = await widget.photoRepository.getPhotoByUrl(url);

      Navigator.pop(context, {"image": bytes, "addons": _selectedAddOns});
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal generate add-on")));
    } finally {
      setState(() => _generating = false);
    }
  }

  // =====================
  // PAYLOAD MAPPER (SAMA)
  // =====================
  Map<String, dynamic> _mapAddOnsToPayload() {
    final Map<String, dynamic> payload = {};

    for (final addon in _selectedAddOns) {
      switch (addon["type"]) {
        case "hair_tattoo":
          payload["hair_tattoo"] = {"tattoo_name": addon["name"]};
          break;
        case "perming":
          payload["perming"] = {"level": addon["level"]};
          break;
        case "smoothing":
          payload["smoothing"] = {"type_smoothing": addon["type_smoothing"]};
          break;
      }
    }
    return payload;
  }

  // =====================
  // UI
  // =====================
  @override
  Widget build(BuildContext context) {
    final bool canGenerate = _selectedAddOns.isNotEmpty && !_generating;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Add On", style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          _loadingAddOns
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                )
              : Column(
                  children: [
                    const SizedBox(height: 12),

                    // IMAGE PREVIEW
                    Image.memory(previewImage, height: 240, fit: BoxFit.cover),

                    const SizedBox(height: 16),

                    Expanded(child: _buildAddOnList()),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: canGenerate ? _submitAddOn : null,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>((
                                  states,
                                ) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors
                                        .grey; // ⛔ abu-abu saat belum pilih
                                  }
                                  return const Color(
                                    0xFFF6AD03,
                                  ); // ✅ kuning aktif
                                }),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.black,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Generate Add-On",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

          if (_generating)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }

  // =====================
  // LIST UI (SAMA)
  // =====================
  Widget _buildAddOnList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section("Perming", addOns["permings"], "perming"),
        _section("Smoothing", addOns["smoothings"], "smoothing"),
        _section("Hair Tattoo", addOns["hair_tattoos"], "hair_tattoo"),
      ],
    );
  }

  Widget _section(String title, List? items, String type) {
    if (items == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),

        ...items.map((item) {
          final bool isSelected = _selectedAddOns.any(
            (e) => e["id"] == item["id"],
          );

          return GestureDetector(
            onTap: () {
              setState(() {
                // 🔥 SINGLE SELECT ONLY
                _selectedAddOns.removeWhere((e) => e["type"] == type);

                _selectedAddOns.add({
                  "id": item["id"],
                  "type": type,
                  "name": item["name"],
                  "level": item["level"],
                  "type_smoothing": item["type"], // 🔥 KUNCI FIX
                });
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white12
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? const Color(0xFFF6AD03) : Colors.white24,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item["name"] ?? item["level"] ?? item["type"] ?? "-",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),

                  // ✅ CHECK ICON
                  AnimatedOpacity(
                    opacity: isSelected ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFFF6AD03),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),

        const SizedBox(height: 16),
      ],
    );
  }
}

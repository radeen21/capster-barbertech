import 'dart:typed_data';
import 'package:capster_barbertech/core/dio_client.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/photo_repository.dart';
import 'package:flutter/material.dart';

class AddOnDialog extends StatefulWidget {
  final PhotoRepository photoRepository;
  final String photoId;
  final String serviceId;
  final Uint8List baseImage;

  final Function(
    Uint8List image,
    List<Map<String, dynamic>> selectedAddOns,
  ) onSuccess;

  const AddOnDialog({
    super.key,
    required this.photoRepository,
    required this.photoId,
    required this.serviceId,
    required this.baseImage,
    required this.onSuccess,
  });

  @override
  State<AddOnDialog> createState() => _AddOnDialogState();
}

class _AddOnDialogState extends State<AddOnDialog> {
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

      widget.onSuccess(bytes, _selectedAddOns);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal generate add-on")),
      );
    } finally {
      setState(() => _generating = false);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 560,
        child: Stack(
          children: [
            _loadingAddOns
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 12),

                      Image.memory(
                        previewImage,
                        height: 220,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(height: 16),
                      Expanded(child: _buildAddOnList()),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: ElevatedButton(
                          onPressed:
                              _selectedAddOns.isEmpty || _generating
                                  ? null
                                  : _submitAddOn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF6AD03),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("Generate Add-On"),
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
      ),
    );
  }

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
        Text(title,
            style: const TextStyle(
                color: Colors.orange, fontWeight: FontWeight.bold)),
        ...items.map((item) {
          return ListTile(
            title: Text(item["nama"] ?? item["level"] ?? "",
                style: const TextStyle(color: Colors.white)),
            onTap: () {
              setState(() {
                _selectedAddOns.removeWhere((e) => e["type"] == type);
                _selectedAddOns.add({
                  "id": item["id"],
                  "type": type,
                  ...item,
                });
              });
            },
          );
        }).toList(),
        const SizedBox(height: 12),
      ],
    );
  }
}

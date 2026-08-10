import 'package:capster_barbertech/core/dio_client.dart';
import 'package:capster_barbertech/features/home/takePicture/gromming_service/domain/gromming_service_entity.dart';
import 'package:flutter/material.dart';

class ServiceBridgingPage extends StatefulWidget {
  final GrommingServiceEntity service;
  final Function(Map<String, dynamic>) onContinue;

  const ServiceBridgingPage({
    super.key,
    required this.service,
    required this.onContinue,
  });

  @override
  State<ServiceBridgingPage> createState() => _ServiceBridgingPageState();
}

class _ServiceBridgingPageState extends State<ServiceBridgingPage> {
  bool isLoading = true;

  /// ==========================
  /// STATE
  /// ==========================
  List<dynamic> colorings = [];
  String? selectedColoringType;
  Color? selectedColor; // 🔥 ubah jadi nullable (lebih aman)

  List<dynamic> permings = [];
  String? selectedPermingLevel;

  List<dynamic> smoothings = [];
  String? selectedSmoothingName;

  @override
  void initState() {
    super.initState();
    _fetchAddOns();
  }

  /// ==========================
  /// 🔥 HELPER FILTER DUPLICATE
  /// ==========================
  List<dynamic> _uniqueById(List<dynamic> list) {
    final map = <String, dynamic>{};

    for (final e in list) {
      final id = e["id"];
      if (id != null) {
        map[id] = e; // overwrite duplicate otomatis
      }
    }

    return map.values.toList();
  }

  /// ==========================
  /// 🔥 FETCH ADDONS (FIXED)
  /// ==========================
  Future<void> _fetchAddOns() async {
    try {
      final dio = DioClient.create();

      debugPrint("📡 GET /add-ons/${widget.service.id}");

      final response = await dio.get("/add-ons/${widget.service.id}");

      debugPrint("📦 FULL RESPONSE: ${response.data}");

      final data = response.data["data"] ?? {};

      /// 🔥 SAFE PARSING + FILTER DUPLICATE
      final rawColorings = data["colorings"] ?? [];
      final rawPermings = data["permings"] ?? [];
      final rawSmoothings = data["smoothings"] ?? [];

      setState(() {
        colorings = _uniqueById(rawColorings);
        permings = _uniqueById(rawPermings);
        smoothings = _uniqueById(rawSmoothings);
        isLoading = false;
      });

      debugPrint("🎨 COLORINGS FINAL: ${colorings.length}");
      debugPrint("💈 PERMINGS FINAL: ${permings.length}");
      debugPrint("💆 SMOOTHINGS FINAL: ${smoothings.length}");
    } catch (e, s) {
      debugPrint("❌ ERROR FETCH ADD-ONS: $e");
      debugPrint("📛 STACKTRACE: $s");
      setState(() => isLoading = false);
    }
  }

  /// ==========================
  /// UI
  /// ==========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.service.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ==========================
                  /// 💈 PERMING
                  /// ==========================
                  if (permings.isNotEmpty) ...[
                    _sectionTitle("Pilih Level Perming"),
                    _choiceWrap(
                      items: permings,
                      getLabel: (e) => e["level"],
                      selectedValue: selectedPermingLevel,
                      onSelected: (v) =>
                          setState(() => selectedPermingLevel = v),
                    ),
                    const SizedBox(height: 24),
                  ],

                  /// ==========================
                  /// 💆 SMOOTHING
                  /// ==========================
                  if (smoothings.isNotEmpty) ...[
                    _sectionTitle("Pilih Type Smoothing"),
                    _choiceWrap(
                      items: smoothings,
                      getLabel: (e) => e["name"],
                      selectedValue: selectedSmoothingName,
                      onSelected: (v) =>
                          setState(() => selectedSmoothingName = v),
                    ),
                    const SizedBox(height: 24),
                  ],

                  /// ==========================
                  /// 🎨 COLORING
                  /// ==========================
                  if (colorings.isNotEmpty) ...[
                    _sectionTitle("Pilih Type Coloring"),
                    _choiceWrap(
                      items: colorings,
                      getLabel: (e) => e["type"],
                      selectedValue: selectedColoringType,
                      onSelected: (v) =>
                          setState(() => selectedColoringType = v),
                    ),
                    const SizedBox(height: 16),
                    _sectionTitle("Pilih Warna"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _colorBox(const Color(0xFF87CEEB)),
                        _colorBox(const Color(0xFF0B3C5D)),
                        _colorBox(const Color(0xFF6B7C85)),
                        _colorBox(const Color(0xFFB2BEB5)),
                        _colorBox(const Color(0xFFD8CFC4)),
                        _colorBox(const Color(0xFFC0C0C0)),
                        _colorBox(const Color(0xFF8A7F73)),
                        _colorBox(const Color(0xFF4B2E2B)),
                        _colorBox(const Color(0xFF7A1F1F)),
                        _colorBox(const Color(0xFFB11226)),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],

                  const Spacer(),

                  /// ==========================
                  /// ▶️ CONTINUE
                  /// ==========================
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey[700];
                          }
                          return const Color(0xFFF6AD03);
                        }),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: _isContinueEnabled
                          ? () {
                              final payload = <String, dynamic>{};

                              if (selectedPermingLevel != null) {
                                payload["perming"] = {
                                  "level": selectedPermingLevel,
                                };
                              }

                              if (selectedSmoothingName != null) {
                                payload["smoothing"] = {
                                  "type_smoothing": selectedSmoothingName,
                                };
                              }

                              if (selectedColoringType != null &&
                                  selectedColor != null) {
                                payload["coloring"] = {
                                  "type": selectedColoringType,
                                  "color_hex": _toHex(selectedColor!),
                                };
                              }

                              widget.onContinue(payload);
                            }
                          : null,
                      child: const Text(
                        "Lanjut ke Foto",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// ==========================
  /// UI HELPERS
  /// ==========================
  Widget _sectionTitle(String text) {
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _choiceWrap({
    required List items,
    required String Function(dynamic) getLabel,
    required String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: items.map((item) {
          final label = getLabel(item);
          final isSelected = selectedValue == label;

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onSelected(label),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFF6AD03)
                      : Colors.white12,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFFF6AD03)
                            : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: isSelected
                        ? const Color(0xFFF6AD03)
                        : Colors.white54,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _colorBox(Color color) {
    final isSelected = selectedColor == color;

    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.white24,
            width: 2,
          ),
        ),
      ),
    );
  }

  String _toHex(Color color) {
    return "#${color.value.toRadixString(16).substring(2).toUpperCase()}";
  }

  bool get _isContinueEnabled {
    if (permings.isNotEmpty && selectedPermingLevel == null) return false;
    if (smoothings.isNotEmpty && selectedSmoothingName == null) return false;
    if (colorings.isNotEmpty) {
      if (selectedColoringType == null) return false;
      if (selectedColor == null) return false;
    }
    return true;
  }
}

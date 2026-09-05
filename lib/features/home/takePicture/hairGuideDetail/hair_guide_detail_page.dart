import 'dart:typed_data';
import 'package:capster_barbertech/core/dio_client.dart';
import 'package:capster_barbertech/core/utils/haircut_utils.dart';
import 'package:capster_barbertech/features/home/takePicture/data/photo_remote_data_source.dart';
import 'package:capster_barbertech/features/home/takePicture/data/photo_repository_impl.dart';
import 'package:capster_barbertech/features/home/takePicture/domain/photo_repository.dart';
import 'package:capster_barbertech/features/home/takePicture/hairGuideDetail/addon/add_on_dialog.dart';
import 'package:capster_barbertech/features/home/takePicture/hairGuideDetail/hair_result_preview_page.dart';
import 'package:capster_barbertech/features/home/takePicture/hairGuideDetail/start_hair_guide_dialog.dart';
import 'package:flutter/material.dart';

class HairGuideDetailPage extends StatefulWidget {
  final String userId; // dari LOGIN
  final Map<String, dynamic> analyzeData;
  final Map<String, dynamic> generatedData; // { request_id, status }
  final String userImage; // photo_id
  final bool hasAddons;
  final String serviceId;

  const HairGuideDetailPage({
    super.key,
    required this.userId,
    required this.analyzeData,
    required this.generatedData,
    required this.userImage,
    required this.hasAddons,
    required this.serviceId,
  });

  @override
  State<HairGuideDetailPage> createState() => _HairGuideDetailPageState();
}

class _HairGuideDetailPageState extends State<HairGuideDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final PhotoRepository photoRepository;
  bool _hasAddons = false;
  String _serviceId = "";
  String? _selectedHaircutName;
  List<Map<String, dynamic>> _selectedAddOns = [];

  Uint8List? _userPhotoBytes;
  bool _isUserPhotoLoading = true;

  bool _isRecommendationLoading = false;
  bool _hasLoadedRecommendation = false;
  List<dynamic> generatedPhotos = [];

  @override
  void initState() {
    super.initState();

    _hasAddons = widget.hasAddons;
    _serviceId = widget.serviceId;

    final remote = PhotoRemoteDataSource(DioClient.create());
    photoRepository = PhotoRepositoryImpl(remote);

    _tabController = TabController(length: 2, vsync: this);

    _loadUserPhoto();

    _tabController.addListener(() {
      if (_tabController.index == 1 &&
          !_tabController.indexIsChanging &&
          !_hasLoadedRecommendation) {
        _loadGeneratedPhotos();
      }
    });
  }

  Future<void> _loadUserPhoto() async {
    try {
      final bytes = await photoRepository.getPhotoById(widget.userImage);
      setState(() {
        _userPhotoBytes = bytes;
        _isUserPhotoLoading = false;
      });
    } catch (_) {
      setState(() => _isUserPhotoLoading = false);
    }
  }

  Future<void> _loadGeneratedPhotos({bool isFromPullRefresh = false}) async {
    final requestId = widget.generatedData["request_id"];
    final status = widget.generatedData["status"];

    if (requestId == null) {
      return;
    }

    try {
      setState(() => _isRecommendationLoading = true);

      final dio = DioClient.create();
      final response = await dio.get("/photos/${widget.userId}/$requestId");

      final List list = response.data["data"] ?? [];

      if (list.isEmpty) {
        if (isFromPullRefresh) {
          _showToast("AI masih memproses gambar...");
        }
        setState(() {
          generatedPhotos = [];
          _isRecommendationLoading = false;
        });
        return;
      }

      _showToast("Rekomendasi rambut siap!");

      setState(() {
        generatedPhotos = list;
        _hasLoadedRecommendation = true;
        _isRecommendationLoading = false;
      });
    } catch (e) {
      debugPrint("ERROR LOAD GENERATED PHOTO: $e");
      _showToast("Gagal memuat rekomendasi");
      setState(() => _isRecommendationLoading = false);
    }
  }

  void _showToast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white, //  icon back putih
        ),
        title: const Text(
          "Hair Guide",
          style: TextStyle(
            color: Colors.white, // text putih
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          // FOTO USER
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white12,
            backgroundImage: _userPhotoBytes != null
                ? MemoryImage(_userPhotoBytes!)
                : null,
            child: _isUserPhotoLoading
                ? const CircularProgressIndicator(color: Colors.orange)
                : null,
          ),

          const SizedBox(height: 12),

          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFF6AD03),
            labelColor: const Color(0xFFF6AD03),
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: "Analisa Haircut"),
              Tab(text: "Rekomendasi"),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildAnalysisTab(), _buildRecommendationTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    final data = widget.analyzeData;
    final hairAnalysis = data["hair_analysis_result"] ?? {};
    final hairType = hairAnalysis["hair_type"] ?? {};

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _accordion(
          title: "Analisa Hasil Wajah",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bullet("Bentuk Wajah", data["face_shape"]?.toString() ?? "-"),
              _bullet(
                "Analisis Bentuk Wajah",
                data["face_analysis_result"]?.toString() ?? "-",
              ),
            ],
          ),
        ),

        _accordion(
          title: "Analisa Garis Rambut",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bullet(
                "Garis Rambut",
                hairAnalysis["hair_line"]?.toString() ?? "-",
              ),
              _bullet("Catatan Tambahan", data["extra"]?.toString() ?? "-"),
            ],
          ),
        ),

        _accordion(
          title: "Analisa Jenis Rambut",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bullet("Kode", hairType["code"]?.toString() ?? "-"),
              _bullet("Tipe", hairType["type"]?.toString() ?? "-"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationTab() {
  return RefreshIndicator(
    color: const Color(0xFFF6AD03),
    onRefresh: () => _loadGeneratedPhotos(isFromPullRefresh: true),
    child: _isRecommendationLoading
        ? const Center(
            child: CircularProgressIndicator(color: Color(0xFFF6AD03)),
          )
        : generatedPhotos.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Text(
                      "AI sedang memproses rekomendasi.\nTarik ke bawah untuk cek ulang.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: generatedPhotos.length,
                itemBuilder: (_, index) {
                  final photo = generatedPhotos[index];
                  final url = photo["url"];

                  final haircutName = extractHaircutNameFromUrl(url);

                  final recommendations =
                      widget.analyzeData["recommendation"]
                          as List<dynamic>? ??
                          [];

                  final rec =
                      index < recommendations.length ? recommendations[index] : null;

                  final rating = rec?["rating"] ?? "0/10";

                  final score =
                      double.tryParse(rating.toString().split("/").first) ?? 0;

                  Color ratingColor = score >= 8
                      ? Colors.green
                      : score >= 5
                          ? Colors.orange
                          : Colors.red;

                  return FutureBuilder<Uint8List>(
                    future: photoRepository.getPhotoByUrl(url),
                    builder: (_, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return _loadingBox();
                      }
                      if (snap.hasError || snap.data == null) {
                        return _imageErrorBox();
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _imageBox(
                                    bytes: _userPhotoBytes,
                                    label: "Gambar",
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _imageBox(
                                    bytes: snap.data!,
                                    label: "Hasil",
                                    labelColor: const Color(0xFFF6AD03),
                                    onTap: () {
                                      final generatedPhotoId = photo["id"];
                                      final baseImage = snap.data!;

                                      debugPrint(
                                          "✂️ SELECTED HAIRCUT = $haircutName");

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => HairResultPreviewPage(
                                            imageBytes: baseImage,
                                            generatedPhotoId: generatedPhotoId,
                                            hasAddons: _hasAddons,
                                            serviceId: _serviceId,
                                            haircutName: haircutName,
                                            photoRepository: photoRepository,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              haircutName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text(
                                  "Value Rating : ",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ratingColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    rating.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
  );
}

  Widget _imageBox({
    required Uint8List? bytes,
    required String label,
    Color labelColor = Colors.black54,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: bytes == null
                ? Container(height: 140, color: Colors.white10)
                : Image.memory(
                    bytes,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: labelColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePopup(
    BuildContext context,
    Uint8List bytes,
    String generatedPhotoId,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close image preview",
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: InteractiveViewer(
                      minScale: 0.8,
                      maxScale: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(bytes, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
                  child: Column(
                    children: [
                      // 🔼 ADD ON
                      if (_hasAddons)
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
                            onPressed: () {
                              Navigator.pop(context);

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => AddOnDialog(
                                  photoRepository: photoRepository,
                                  photoId: generatedPhotoId,
                                  serviceId: _serviceId,
                                  baseImage: bytes,
                                  onSuccess:
                                      (
                                        Uint8List newImage,
                                        List<Map<String, dynamic>> addons,
                                      ) {
                                        // simpan add-ons (penting untuk Mulai Cukur)
                                        setState(() {
                                          _selectedAddOns = addons;
                                        });

                                        _showImagePopup(
                                          context,
                                          newImage,
                                          generatedPhotoId,
                                        );
                                      },
                                ),
                              );
                            },
                            child: const Text("Add On"),
                          ),
                        ),

                      const SizedBox(height: 10),

                     
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
                        

                            if (_selectedHaircutName == null) {
                              _showToast("Pilih model rambut terlebih dahulu");
                              return;
                            }

                            Navigator.pop(context);

                            showDialog(
                              context: context,
                              builder: (_) => StartHaircutDialog(
                                serviceId: _serviceId,
                                haircutName: _selectedHaircutName!,
                                addOns: _selectedAddOns, // boleh []
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
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    );
  }

  Widget _loadingBox() => Container(
    height: 160,
    alignment: Alignment.center,
    color: Colors.white10,
    child: const CircularProgressIndicator(color: Colors.orange),
  );

  Widget _imageErrorBox() => Container(
    height: 160,
    color: Colors.white12,
    child: const Icon(Icons.image, color: Colors.white24),
  );

  Widget _accordion({required String title, required Widget content}) {
    return _LeftAlignedAccordion(title: title, child: content);
  }

  Widget _bullet(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), 
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white70, height: 1.5),
          children: [
            TextSpan(
              text: "• $title:\n",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _LeftAlignedAccordion extends StatefulWidget {
  final String title;
  final Widget child;

  const _LeftAlignedAccordion({required this.title, required this.child});

  @override
  State<_LeftAlignedAccordion> createState() => _LeftAlignedAccordionState();
}

class _LeftAlignedAccordionState extends State<_LeftAlignedAccordion> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white10, 
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut, 
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: widget.child,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

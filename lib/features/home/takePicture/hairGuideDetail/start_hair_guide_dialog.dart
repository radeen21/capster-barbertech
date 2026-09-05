import 'package:capster_barbertech/core/dio_client.dart';
import 'package:capster_barbertech/features/home/history/data/history_remote_data_source.dart';
import 'package:flutter/material.dart';

class StartHaircutDialog extends StatefulWidget {
  final String serviceId;
  final String haircutName;
  final List<Map<String, dynamic>> addOns;

  const StartHaircutDialog({
    super.key,
    required this.serviceId,
    required this.haircutName,
    required this.addOns,
  });

  @override
  State<StartHaircutDialog> createState() => _StartHaircutDialogState();
}

class _StartHaircutDialogState extends State<StartHaircutDialog> {
  final TextEditingController _phoneController = TextEditingController();
  bool _loading = false;
  String _normalizePhone(String phone) {
    phone = phone.trim();

    if (phone.startsWith("0")) {
      return "+62${phone.substring(1)}";
    }
    if (!phone.startsWith("+")) {
      return "+62$phone";
    }
    return phone;
  }


  Future<void> _submit() async {
    final rawPhone = _phoneController.text.trim();

    // VALIDATION
    if (rawPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor telepon wajib diisi")),
      );
      return;
    }

    if (widget.serviceId.isEmpty) {
     
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service tidak valid")),
      );
      return;
    }

    if (widget.haircutName.isEmpty || widget.haircutName == "N/A") {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Model rambut belum dipilih")),
      );
      return;
    }

    final phoneNumber = _normalizePhone(rawPhone);

    setState(() => _loading = true);

    try {
      final remote = HistoryRemoteDataSource(DioClient.create());

      final response = await remote.startHaircut(
        phoneNumber: phoneNumber,
        serviceId: widget.serviceId,
        haircutName: widget.haircutName,
        addOns: widget.addOns,
      );


      if (!mounted) return;

      Navigator.pop(context); // tutup dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"] ?? "Berhasil")),
      );
    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memulai cukur")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Masukkan Nomor Telepon",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "+62",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Mulai Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

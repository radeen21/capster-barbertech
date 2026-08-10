import 'package:capster_barbertech/features/auth/domain/logout_usecase.dart';
import 'package:flutter/material.dart';

class AkunCapsterPage extends StatefulWidget {
  final String capsterName;
  final LogoutUseCase logoutUseCase;

  const AkunCapsterPage({
    super.key,
    required this.capsterName,
    required this.logoutUseCase,
  });

  @override
  State<AkunCapsterPage> createState() => _AkunCapsterPageState();
}

class _AkunCapsterPageState extends State<AkunCapsterPage> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);

    try {
      await widget.logoutUseCase.call();
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/login",
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout gagal: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  /// TITLE
                  const Text(
                    "AKUN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// PROFILE HEADER
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white12,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          widget.capsterName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// MENU
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      children: [
                        _menuItem(
                          icon: Icons.person_outline,
                          title: "Akun",
                          subtitle:
                              "Profil foto, nama, email, dan no. handphone",
                          onTap: () {},
                        ),
                        _divider(),
                        _menuItem(
                          icon: Icons.settings_outlined,
                          title: "Pengaturan",
                          subtitle: "Pengaturan aplikasi Barberpedia",
                          onTap: () {},
                        ),
                        _divider(),
                        _menuItem(
                          icon: Icons.help_outline,
                          title: "FAQ",
                          subtitle:
                              "Pertanyaan umum tentang Barberpedia",
                          onTap: () {},
                        ),
                        _divider(),
                        _menuItem(
                          icon: Icons.verified_user_outlined,
                          title: "Syarat dan Ketentuan",
                          subtitle:
                              "Syarat dan ketentuan aplikasi Barberpedia",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// LOGOUT
                  Center(
                    child: GestureDetector(
                      onTap: _isLoggingOut ? null : _handleLogout,
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),

        /// LOADING OVERLAY
        if (_isLoggingOut)
          AbsorbPointer(
            absorbing: true,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                  strokeWidth: 4,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      color: Colors.white12,
      indent: 16,
      endIndent: 16,
    );
  }
}

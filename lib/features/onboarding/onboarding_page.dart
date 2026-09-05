import 'package:capster_barbertech/common/gradient_button.dart';
import 'package:capster_barbertech/features/onboarding/slide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnboardingPage> {
  int _currentPage = 0;
  List<Slide> _slides = [];
  PageController _pageController = PageController();

  @override
  void initState() {
    _currentPage = 0;
    _slides = [
      Slide(
        "assets/image_onboarding1.png",
        "Discover Your Style",
        "Temukan gaya rambut yang cocok dengan kepribadianmu. Jelajahi berbagai inspirasi haircut dan pilih yang paling sesuai dengan bentuk wajahmu.",
      ),
      Slide(
        "assets/image_onboarding2.png",
        "Find Your Perfect Look with Hair Guide",
        "Bingung mau potong model apa? Hair Guide akan bantu kamu menemukan gaya rambut terbaik sesuai bentuk wajah, tipe rambut, dan kepribadianmu.",
      ),
      Slide(
        "assets/image_onboarding3.png",
        "Earn Points & Rewards",
        "Setiap potong rambut membuatmu lebih dekat dengan hadiah spesial! Kumpulkan poin dari setiap booking dan tukarkan dengan potongan harga atau layanan premium.",
      ),
    ];
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  List<Widget> _buildSlides() {
    return _slides.map(_buildSlide).toList();
  }

  Widget _buildSlide(Slide slide) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          alignment: Alignment.topCenter, // Semua konten ke bagian atas
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // agar tidak memaksakan tinggi penuh
            crossAxisAlignment: CrossAxisAlignment.start, // teks rata kiri
            children: <Widget>[
              const SizedBox(height: 40),
              Center(
                child: Image.asset(
                  slide.image,
                  fit: BoxFit.contain,
                  width: constraints.maxWidth * 0.9,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                slide.heading,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                 color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                slide.description,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handlingOnPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  // building page indicator
  Widget _buildPageIndicator() {
    Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
    for (int i = 0; i < _slides.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides.length - 1) row.children.add(SizedBox(width: 12));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == _currentPage ? 8 : 5,
      height: index == _currentPage ? 8 : 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == _currentPage
            ? Color(0xFFF6AD03)
            : Color.fromRGBO(206, 209, 223, 1),
      ),
    );
  }

  void _handleNextButton() {
    if (_currentPage == _slides.length - 1) {
      
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      
      _pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: _handlingOnPageChanged,
            physics: BouncingScrollPhysics(),
            children: _buildSlides(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: <Widget>[
                _buildPageIndicator(),
                SizedBox(height: 32),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      callback: () {
                        print("Tombol ditekan!");
                      },
                      onPressed: _handleNextButton,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF6AD03), Color(0xFFF6AD03)],
                      ),
                      child: Text(
                        _currentPage == _slides.length - 1
                            ? "Oke"
                            : "Lanjut",
                        style: TextStyle(
                          letterSpacing: 4,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

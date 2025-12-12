import 'package:flutter/material.dart';
import 'dart:math' as math;

class ModuleContentScreen extends StatefulWidget {
  const ModuleContentScreen({
    super.key,
    required this.categoryTitle,
    required this.moduleTitle,
    required this.duration,
    required this.color,
    required this.icon,
    required this.isCompleted,
  });

  final String categoryTitle;
  final String moduleTitle;
  final String duration;
  final Color color;
  final IconData icon;
  final bool isCompleted;

  @override
  State<ModuleContentScreen> createState() => _ModuleContentScreenState();
}

class _ModuleContentScreenState extends State<ModuleContentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;

  int _currentCardIndex = 0;
  bool _completed = false;
  final Map<int, String> _cardStatus = {}; // 'know', 'learning', 'dont-know'

  @override
  void initState() {
    super.initState();
    _completed = widget.isCompleted;
    _pageController = PageController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFlashcards() {
    // Yangın kategorisi
    if (widget.categoryTitle == 'Yangın') {
      if (widget.moduleTitle.contains('Yangın Güvenliği Temelleri')) {
        return [
          {
            'question': 'Yangın Üçgeninin elemanları nelerdir?',
            'answer':
                'Yangın Üçgeni 3 elementten oluşur:\n\n🔸 Yakıt (Yanıcı madde)\n🔸 Oksijen (Hava)\n🔸 Isı (Tutuşma kaynağı)\n\nBu üç elementin herhangi biri ortadan kaldırılırsa yangın söner!',
            'icon': '🔥',
          },
          {
            'question': 'Yangında hangi araç asla kullanılmamalıdır?',
            'answer':
                'ASANSÖR!\n\nYangın sırasında elektrikler kesilir ve asansörde mahsur kalabilirsiniz.\n\nHer zaman merdivenleri kullanın!\n\n🚫 Asansör\n✅ Merdivenler',
            'icon': '🚫',
          },
          {
            'question': 'A Sınıfı yangınlar hangi maddelerde çıkar?',
            'answer':
                'A Sınıfı Yangınlar:\n\nKatı yanıcı maddelerden oluşur:\n📄 Kağıt\n🪵 Ahşap\n👕 Kumaş\n🛋️ Plastik\n\nBu yangınlarda su ve köpüklü söndürücüler kullanılabilir.',
            'icon': '📦',
          },
          {
            'question': 'Yangın dedektörü ne sıklıkla test edilmelidir?',
            'answer':
                'Yangın Dedektörü Bakımı:\n\n📅 Ayda bir test düğmesine basarak kontrol edin\n\n🔋 Yılda bir pillerini değiştirin\n\n✅ Her zaman çalışır durumda olmalı!',
            'icon': '🔔',
          },
          {
            'question': 'Elektrik yangınlarına neden su dökülmez?',
            'answer':
                '⚡ ÇOK TEHLİKELİ!\n\nSu elektriği iletir! Elektrik yangınına su dökerseniz:\n\n⚡ Elektrik çarpılabilirsiniz\n💥 Yangın yayılabilir\n\n✅ Elektrik tipi söndürücü kullanın\n✅ Önce elektriği kesin',
            'icon': '⚡',
          },
          {
            'question': 'Yağ yangınına neden su dökülmez?',
            'answer':
                '🔥 PATLAMA TEHLİKESİ!\n\nSu, yanan yağdan daha ağırdır. Yağ yangınına su dökerseniz:\n\n💥 Su alta gider ve buharlaşır\n🔥 Yanan yağ etrafa fışkırır\n🚨 Yangın kontrolden çıkar\n\n✅ Tencere kapağı ile örtün',
            'icon': '🍳',
          },
        ];
      }
    }

    // Genel içerik (diğer tüm modüller için)
    return [
      {
        'question': '${widget.moduleTitle} konusunda ilk adım nedir?',
        'answer':
            'İlk Adımlar:\n\n1️⃣ Durumu değerlendirin\n2️⃣ Güvenliği sağlayın\n3️⃣ 112\'yi arayın\n4️⃣ Bildiğiniz teknikleri uygulayın\n\n⚠️ Kendi güvenliğiniz önceliklidir!',
        'icon': '🎯',
      },
      {
        'question': 'Acil durumda hangi numara aranmalıdır?',
        'answer':
            '112 - Acil Yardım\n\n📞 Tüm acil durumlar için tek numara\n🚑 Ambulans\n🚒 İtfaiye\n👮 Polis\n\n✅ Sakin konuşun\n✅ Net bilgi verin\n✅ Konumu tarif edin',
        'icon': '📞',
      },
      {
        'question': '${widget.categoryTitle} kategorisinde en önemli kural nedir?',
        'answer':
            'Temel Kurallar:\n\n✅ Sakin kalın\n✅ Panik yapmayın\n✅ Güvenli mesafe\n✅ Profesyonel yardım çağırın\n\n❌ Risk almayın\n❌ Kahraman olmaya çalışmayın',
        'icon': '⚡',
      },
      {
        'question': 'Acil durum planı nasıl yapılır?',
        'answer':
            'Acil Durum Planı:\n\n📋 Kaçış yollarını belirleyin\n📍 Toplanma noktası seçin\n📱 Acil telefon listesi\n🏃 Aile ile tatbikat yapın\n\n✅ Plan yılda bir güncellenmelidir!',
        'icon': '📋',
      },
    ];
  }

  int get _knowCount => _cardStatus.values.where((s) => s == 'know').length;
  int get _learningCount =>
      _cardStatus.values.where((s) => s == 'learning').length;
  int get _dontKnowCount =>
      _cardStatus.values.where((s) => s == 'dont-know').length;

  @override
  Widget build(BuildContext context) {
    final flashcards = _getFlashcards();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _cardStatus.length == flashcards.length) {
          _completed = true;
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color,
                widget.color.withValues(alpha: 0.8),
                widget.color.withValues(alpha: 0.7),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _buildHeader(context, flashcards.length),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildStatsBar(),
                          const SizedBox(height: 16),
                          _buildCardCounter(flashcards.length),
                          Expanded(
                            child: _buildFlashcardView(flashcards),
                          ),
                          _buildActionButtons(flashcards),
                          _buildProgressBar(flashcards.length),
                          const SizedBox(height: 12),
                          _buildNavigationButtons(flashcards.length),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int totalCards) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.pop(context, _completed),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.moduleTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.style, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  '$totalCards Kart',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  widget.duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('$_knowCount', 'Biliyor', Colors.green),
          _buildStatItem('$_learningCount', 'Öğreniyor', Colors.orange),
          _buildStatItem('$_dontKnowCount', 'Bilmiyor', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildCardCounter(int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '${_currentCardIndex + 1} / $total',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildFlashcardView(List<Map<String, dynamic>> flashcards) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentCardIndex = index;
        });
      },
      itemCount: flashcards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: FlashcardWidget(
            question: flashcards[index]['question'],
            answer: flashcards[index]['answer'],
            icon: flashcards[index]['icon'],
            color: widget.color,
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(List<Map<String, dynamic>> flashcards) {
    final isLastCard = _currentCardIndex == flashcards.length - 1;
    final allCardsMarked = _cardStatus.length == flashcards.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              '❌',
              'Bilmiyorum',
              Colors.red,
              () => _markCard('dont-know', isLastCard, allCardsMarked),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              '📖',
              'Öğreniyorum',
              Colors.orange,
              () => _markCard('learning', isLastCard, allCardsMarked),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              '✅',
              'Biliyorum',
              Colors.green,
              () => _markCard('know', isLastCard, allCardsMarked),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String emoji,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int total) {
    final progress = (_currentCardIndex + 1) / total;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: 6,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(int total) {
    final isFirstCard = _currentCardIndex == 0;
    final isLastCard = _currentCardIndex == total - 1;
    final allCardsMarked = _cardStatus.length == total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (!isFirstCard)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousCard,
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Önceki'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.color,
                  side: BorderSide(color: widget.color.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          if (!isFirstCard && !isLastCard) const SizedBox(width: 12),
          if (!isLastCard)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _nextCard,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Sonraki'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          if (isLastCard && allCardsMarked)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _completeModule,
                icon: const Icon(Icons.check_circle, size: 16),
                label: const Text('Tamamla'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _markCard(String status, bool isLastCard, bool allCardsMarked) {
    setState(() {
      _cardStatus[_currentCardIndex] = status;
    });

    // Auto advance to next card if not last
    if (!isLastCard) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _nextCard();
      });
    } else if (allCardsMarked) {
      // Show completion dialog
      _showCompletionDialog();
    }
  }

  void _nextCard() {
    if (_currentCardIndex < _getFlashcards().length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousCard() {
    if (_currentCardIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeModule() {
    _completed = true;
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration,
                color: Colors.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tebrikler!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.moduleTitle} modülünü başarıyla tamamladınız!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Biliyor:', style: TextStyle(fontSize: 14)),
                      Text(
                        '$_knowCount kart',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Öğreniyor:', style: TextStyle(fontSize: 14)),
                      Text(
                        '$_learningCount kart',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bilmiyor:', style: TextStyle(fontSize: 14)),
                      Text(
                        '$_dontKnowCount kart',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(_completed);
            },
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );
  }
}

class FlashcardWidget extends StatefulWidget {
  final String question;
  final String answer;
  final String icon;
  final Color color;

  const FlashcardWidget({
    super.key,
    required this.question,
    required this.answer,
    required this.icon,
    required this.color,
  });

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    if (!_isFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final isShowingFront = _flipAnimation.value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(_flipAnimation.value * math.pi),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: isShowingFront
                  ? _buildFrontCard()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _buildBackCard(),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              widget.icon,
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          widget.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app,
                color: widget.color,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Cevabı görmek için dokunun',
                style: TextStyle(
                  color: widget.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lightbulb,
            color: Colors.green,
            size: 30,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              widget.answer,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF374151),
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app,
                color: Colors.blue,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Soruya dönmek için dokunun',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
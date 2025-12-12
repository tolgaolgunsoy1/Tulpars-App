import 'package:flutter/material.dart';

import 'module_content_screen.dart';

class CategoryModulesScreen extends StatefulWidget {
  const CategoryModulesScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.modules,
    required this.completedModules,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final List<Map<String, dynamic>> modules;
  final Map<String, bool> completedModules;

  @override
  State<CategoryModulesScreen> createState() => _CategoryModulesScreenState();
}

class _CategoryModulesScreenState extends State<CategoryModulesScreen>
    with SingleTickerProviderStateMixin {
  late Map<String, bool> _completed;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _completed = Map.from(widget.completedModules);
    for (final module in widget.modules) {
      _completed.putIfAbsent(module['title'], () => false);
    }

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
    super.dispose();
  }

  int get _completedCount => _completed.values.where((v) => v).length;

  double get _progress =>
      widget.modules.isEmpty ? 0.0 : _completedCount / widget.modules.length;

  void _handleModuleCompletion(String title) {
    setState(() {
      _completed[title] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _completed);
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
                  _buildHeader(context),
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
                          _buildProgressCard(),
                          const SizedBox(height: 16),
                          Expanded(child: _buildModulesList()),
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

  Widget _buildHeader(BuildContext context) {
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
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 24),
          Hero(
            tag: 'category_${widget.title}',
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(widget.icon, size: 50, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.description.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.school, color: widget.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Eğitim İlerlemesi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_completedCount/${widget.modules.length}',
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0, end: _progress),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: widget.color.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  minHeight: 10,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TweenAnimationBuilder<int>(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                tween: IntTween(begin: 0, end: (_progress * 100).toInt()),
                builder: (context, value, child) {
                  return Text(
                    '%$value Tamamlandı',
                    style: TextStyle(
                      fontSize: 13,
                      color: widget.color,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
              if (_progress == 1.0)
                Row(
                  children: [
                    Icon(Icons.celebration, color: widget.color, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Tebrikler!',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModulesList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: widget.modules.length,
      itemBuilder: (context, index) {
        final module = widget.modules[index];
        final title = module['title'] as String;
        final duration = module['duration'] as String;
        final isCompleted = _completed[title] ?? false;
        final isLocked = index > 0 &&
            !(_completed[widget.modules[index - 1]['title']] ?? false);

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOutCubic,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _ModuleCard(
            title: title,
            duration: duration,
            isCompleted: isCompleted,
            isLocked: isLocked,
            color: widget.color,
            icon: widget.icon,
            categoryTitle: widget.title,
            onTap: isLocked
                ? null
                : () => _navigateToModule(title, duration, isCompleted),
          ),
        );
      },
    );
  }

  Future<void> _navigateToModule(
      String title, String duration, bool isCompleted,) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ModuleContentScreen(
          categoryTitle: widget.title,
          moduleTitle: title,
          duration: duration,
          color: widget.color,
          icon: widget.icon,
          isCompleted: isCompleted,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );

    if (result == true) {
      _handleModuleCompletion(title);
    }
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.duration,
    required this.isCompleted,
    required this.isLocked,
    required this.color,
    required this.icon,
    required this.categoryTitle,
    this.onTap,
  });

  final String title;
  final String duration;
  final bool isCompleted;
  final bool isLocked;
  final Color color;
  final IconData icon;
  final String categoryTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: color.withValues(alpha: 0.1),
          highlightColor: color.withValues(alpha: 0.05),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? color
                    : isLocked
                        ? Colors.grey.withValues(alpha: 0.3)
                        : color.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                if (!isLocked)
                  BoxShadow(
                    color: color.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? color
                          : isLocked
                              ? Colors.grey.withValues(alpha: 0.3)
                              : color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isCompleted
                          ? Icons.check_circle
                          : isLocked
                              ? Icons.lock
                              : Icons.play_circle_outline,
                      color: isCompleted
                          ? Colors.white
                          : isLocked
                              ? Colors.grey
                              : color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isLocked
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: isLocked ? Colors.grey : color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              duration,
                              style: TextStyle(
                                fontSize: 12,
                                color: isLocked
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            if (isCompleted) ...[ 
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3,),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Tamamlandı',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: isLocked ? Colors.grey : color,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
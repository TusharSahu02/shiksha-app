import 'package:flutter/material.dart';

class ProfileSkeleton extends StatefulWidget {
  const ProfileSkeleton({super.key});

  @override
  State<ProfileSkeleton> createState() => _ProfileSkeletonState();
}

class _ProfileSkeletonState extends State<ProfileSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _bone({double width = double.infinity, double height = 16, double radius = 8}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, _) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: _animation.value * 0.3),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _card(children: [
            Row(
              children: [
                _bone(width: 64, height: 64, radius: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bone(width: 140, height: 18),
                      const SizedBox(height: 8),
                      _bone(width: 180, height: 14),
                      const SizedBox(height: 8),
                      _bone(width: 80, height: 22, radius: 11),
                    ],
                  ),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 16),

          _card(children: [
            _bone(width: 120, height: 14),
            const SizedBox(height: 14),
            _bone(height: 12),
            const SizedBox(height: 10),
            _bone(height: 12),
            const SizedBox(height: 10),
            _bone(width: 200, height: 12),
          ]),
          const SizedBox(height: 16),

          _card(children: [
            _bone(width: 100, height: 14),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _bone(height: 50, radius: 10)),
                const SizedBox(width: 10),
                Expanded(child: _bone(height: 50, radius: 10)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _bone(height: 50, radius: 10)),
                const SizedBox(width: 10),
                Expanded(child: _bone(height: 50, radius: 10)),
              ],
            ),
          ]),
          const SizedBox(height: 16),

          _card(children: [
            _bone(width: 110, height: 14),
            const SizedBox(height: 14),
            _bone(height: 44, radius: 10),
            const SizedBox(height: 12),
            _bone(height: 44, radius: 10),
          ]),
          const SizedBox(height: 16),

          _card(children: [
            _bone(width: 130, height: 14),
            const SizedBox(height: 14),
            _bone(height: 44, radius: 10),
            const SizedBox(height: 10),
            _bone(height: 44, radius: 10),
            const SizedBox(height: 10),
            _bone(height: 44, radius: 10),
          ]),
        ],
      ),
    );
  }
}

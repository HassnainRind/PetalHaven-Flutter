import 'package:flutter/material.dart';
import 'theme.dart';

/// Press-in scale effect used by buttons in the website (:active -> scale(.9))
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  const Pressable({super.key, required this.child, this.onTap, this.scale = 0.92});
  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool down = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => down = true),
        onTapUp: (_) => setState(() => down = false),
        onTapCancel: () => setState(() => down = false),
        onTap: widget.onTap,
        child: AnimatedScale(
            scale: down ? widget.scale : 1.0, duration: const Duration(milliseconds: 280), curve: springCurve, child: widget.child),
      );
}

/// fade + rise-in (keyframes "rise")
class Rise extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const Rise({super.key, required this.child, this.delay = Duration.zero});
  @override
  State<Rise> createState() => _RiseState();
}

class _RiseState extends State<Rise> with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) c.forward();
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: c,
        builder: (_, child) {
          final t = easeCurve.transform(c.value);
          return Opacity(opacity: t, child: Transform.translate(offset: Offset(0, (1 - t) * 18), child: child));
        },
        child: widget.child,
      );
}

/// Pulsing halo (keyframes "halo") around the main action button
class Halo extends StatefulWidget {
  final Widget child;
  const Halo({super.key, required this.child});
  @override
  State<Halo> createState() => _HaloState();
}

class _HaloState extends State<Halo> with SingleTickerProviderStateMixin {
  late final AnimationController c = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: c,
        builder: (_, child) => DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(color: Color.fromRGBO(224, 85, 127, 0.4 * (1 - c.value)), spreadRadius: 18 * c.value, blurRadius: 0),
          ]),
          child: child,
        ),
        child: widget.child,
      );
}

/// Grayscale filter used for inactive nav icons
const ColorFilter grayscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
]);

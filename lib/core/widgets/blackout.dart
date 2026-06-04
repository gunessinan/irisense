import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:irisense/app/app_viewmodel.dart';
import 'package:provider/provider.dart';

class Blackout extends StatefulWidget {
  final Widget child;
  const Blackout({Key? key, required this.child}) : super(key: key);

  @override
  _BlackoutState createState() => _BlackoutState();
}

class _BlackoutState extends State<Blackout>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late AppViewModel appViewModel;

  bool? _prevNavbarState;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appViewModel = context.read<AppViewModel>();

    final bool isOpen = appViewModel.navbar_isOpen;

    if (_prevNavbarState != isOpen) {
      if (isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      _prevNavbarState = isOpen;
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _fadeAnimation.value == 0,
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (_, __) {
          return Stack(
            children: [
              widget.child,

              // Blur
              if (_fadeAnimation.value > 0)
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 3 * _fadeAnimation.value,
                    sigmaY: 3 * _fadeAnimation.value,
                  ),
                  child: const SizedBox(),
                ),

              // Vignette (kenarlar siyah)
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(
                        0.85 * _fadeAnimation.value,
                      ),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),

              // Overlay
              Container(
                color: Colors.black.withOpacity(
                  0.2 * _fadeAnimation.value,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

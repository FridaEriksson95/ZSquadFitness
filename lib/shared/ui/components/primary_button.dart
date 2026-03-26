import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zsquadfitness/core/constants/gaps_styles.dart';
import 'package:zsquadfitness/shared/ui/theme/app_colors.dart';
import 'package:zsquadfitness/shared/ui/theme/app_textstyles.dart';

/// Main primarybutton for reuse purpose to set same vibe all through the app
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.color,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration120);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.93,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final baseColor = disabled ? AppColors.mediumGrey : widget.color;
    final glowColor = baseColor.withValues(alpha: 0.9);

    return GestureDetector(
      onTapDown: disabled ? null : _handleTapDown,
      onTapUp: disabled ? null : _handleTapUp,
      onTapCancel: disabled ? null : _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ClipRRect(
              borderRadius: borderRadius24,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.15, 0.53, 1.2],
                      colors: [
                        baseColor.withValues(alpha: 1.0),
                        baseColor.withValues(alpha: 0.96),
                        baseColor.withValues(alpha: 0.62),
                        AppColors.dark.withValues(alpha: 0.94),
                      ],
                    ),
                    borderRadius: borderRadius24,
                    border: buttonBorderW,
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withValues(alpha: 0.6),
                        blurRadius: 25,
                        spreadRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                      BoxShadow(
                        color: glowColor.withValues(alpha: 0.4),
                        blurRadius: 40,
                        spreadRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                      shadowGlass2B,
                      shadowGlass3W,
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: borderRadius24,
                      onTap: null,
                      splashColor: Colors.white.withValues(alpha: 0.18),
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: paddingAll8,
                        child: Text(
                          widget.text,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.geist20LB.copyWith(
                            color: AppColors.dark,
                            shadows: [
                              Shadow(
                                color: glowColor.withValues(alpha: 0.7),
                                blurRadius: 10,
                                offset: const Offset(1, 0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

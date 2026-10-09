import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../theme/app_colors.dart';

/// A modern, animated full-screen QR scanner.
///
/// Highlights:
///  • Intro animation – the frame "locks in" from a wider size.
///  • Breathing glow corners while idle.
///  • Sweeping laser with a fading light trail.
///  • Success: frame snaps tight, turns green, check badge pops with a ripple
///    and a haptic tap, then the screen returns the scanned value.
///  • Helpful hint that changes if nothing is detected for a while.
///  • Flash, camera switch and 1x/2x zoom controls.
///
/// Pops with the scanned [String] (trimmed), or `null` if closed.
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with TickerProviderStateMixin {
  late final MobileScannerController _controller;

  late final AnimationController _beamController; // laser sweep (loops)
  late final AnimationController _pulseController; // corner breathing
  late final AnimationController _successController; // success burst
  late final AnimationController _introController; // entrance
  late final Animation<double> _intro;

  Timer? _helpTimer;

  bool _isScanned = false;
  bool _isTorchOn = false;
  bool _isZoomed = false;
  bool _showHelp = false;

  @override
  void initState() {
    super.initState();

    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _beamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _intro = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOutCubic,
    );

    // If nothing is found for a while, gently offer some help.
    _helpTimer = Timer(const Duration(seconds: 7), () {
      if (mounted && !_isScanned) setState(() => _showHelp = true);
    });
  }

  @override
  void dispose() {
    _helpTimer?.cancel();
    _beamController.dispose();
    _pulseController.dispose();
    _successController.dispose();
    _introController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned || capture.barcodes.isEmpty) return;

    final rawValue = capture.barcodes.first.rawValue;
    if (rawValue == null || rawValue.trim().isEmpty) return;

    HapticFeedback.mediumImpact();
    _helpTimer?.cancel();
    setState(() {
      _isScanned = true;
      _showHelp = false;
    });
    _beamController.stop();
    _pulseController.stop();
    _successController.forward();

    // Let the success animation play before leaving.
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Navigator.of(context).pop(rawValue.trim());
    });
  }

  Future<void> _toggleTorch() async {
    try {
      await _controller.toggleTorch();
      HapticFeedback.selectionClick();
      if (mounted) setState(() => _isTorchOn = !_isTorchOn);
    } catch (_) {
      // Torch not supported on this device.
    }
  }

  Future<void> _switchCamera() async {
    try {
      await _controller.switchCamera();
      HapticFeedback.selectionClick();
      if (mounted) setState(() => _isTorchOn = false);
    } catch (_) {
      // Camera switching not supported.
    }
  }

  Future<void> _toggleZoom() async {
    try {
      final next = !_isZoomed;
      await _controller.setZoomScale(next ? 0.35 : 0.0);
      HapticFeedback.selectionClick();
      if (mounted) setState(() => _isZoomed = next);
    } catch (_) {
      // Zoom not supported.
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final boxSize = (size.width * 0.7).clamp(240.0, 300.0);
    // Sit the frame slightly above center so the bottom card never crowds it.
    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.41),
      width: boxSize,
      height: boxSize,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Camera
          MobileScanner(controller: _controller, onDetect: _onDetect),

          // 2. Dark overlay with rounded cutout
          CustomPaint(
            size: size,
            painter: _OverlayPainter(
              rect: scanRect,
              intro: _intro,
              success: _successController,
            ),
          ),

          // 3. Laser sweep (clipped to the frame)
          Positioned.fromRect(
            rect: scanRect,
            child: IgnorePointer(
              child: CustomPaint(
                painter: _BeamPainter(
                  progress: _beamController,
                  intro: _intro,
                  success: _successController,
                ),
              ),
            ),
          ),

          // 4. Glowing corner brackets
          CustomPaint(
            size: size,
            painter: _CornerPainter(
              rect: scanRect,
              pulse: _pulseController,
              intro: _intro,
              success: _successController,
            ),
          ),

          // 5. Success badge
          if (_isScanned)
            Positioned.fromRect(
              rect: scanRect,
              child: _SuccessBadge(animation: _successController),
            ),

          // 6. Top scrim for readable header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 150,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.55),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 7. Header
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: FadeTransition(
                opacity: _intro,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _GlassCircleButton(
                        icon: Icons.close_rounded,
                        tooltip: 'Close',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const _Glass(
                        radius: 20,
                        padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                        child: Text(
                          'Scan QR Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _GlassCircleButton(
                            icon: _isTorchOn
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            tooltip: 'Flash',
                            isActive: _isTorchOn,
                            onTap: _toggleTorch,
                          ),
                          const SizedBox(width: 10),
                          _GlassCircleButton(
                            icon: Icons.flip_camera_ios_rounded,
                            tooltip: 'Switch camera',
                            onTap: _switchCamera,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 8. Zoom chip under the frame
          Positioned(
            top: scanRect.bottom + 22,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _intro,
              child: Center(
                child: _ZoomChip(isZoomed: _isZoomed, onTap: _toggleZoom),
              ),
            ),
          ),

          // 9. Bottom hint card
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(_intro),
                  child: FadeTransition(
                    opacity: _intro,
                    child: _HintCard(
                      isScanned: _isScanned,
                      showHelp: _showHelp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Geometry helper shared by painters so everything stays perfectly aligned.
// ─────────────────────────────────────────────────────────────────────────────

const double _kFrameRadius = 28;

/// Frame starts a little larger (intro) and snaps tighter on success.
Rect _effectiveRect(Rect base, double intro, double success) {
  return base.inflate((1 - intro) * 36 - success * 8);
}

// ─────────────────────────────────────────────────────────────────────────────
// Painters
// ─────────────────────────────────────────────────────────────────────────────

class _OverlayPainter extends CustomPainter {
  _OverlayPainter({
    required this.rect,
    required this.intro,
    required this.success,
  }) : super(repaint: Listenable.merge([intro, success]));

  final Rect rect;
  final Animation<double> intro;
  final Animation<double> success;

  @override
  void paint(Canvas canvas, Size size) {
    final s = Curves.easeOut.transform(success.value);
    final r = _effectiveRect(rect, intro.value, s);
    final rrect = RRect.fromRectAndRadius(r, const Radius.circular(_kFrameRadius));

    final overlay = Paint()
      ..color = Colors.black.withValues(alpha: (0.55 + 0.1 * s) * intro.value);

    final path = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, overlay);

    final border = Paint()
      ..color = Color.lerp(Colors.white.withValues(alpha: 0.18),
          AppColors.successDark.withValues(alpha: 0.9), s)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rrect, border);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter old) => old.rect != rect;
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({
    required this.rect,
    required this.pulse,
    required this.intro,
    required this.success,
  }) : super(repaint: Listenable.merge([pulse, intro, success]));

  final Rect rect;
  final Animation<double> pulse;
  final Animation<double> intro;
  final Animation<double> success;

  static const double _len = 30;
  static const double _stroke = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final s = Curves.easeOut.transform(success.value);
    final breathe = Curves.easeInOut.transform(pulse.value) * (1 - s);

    // Corners breathe outward slightly while idle.
    final r = _effectiveRect(rect, intro.value, s).inflate(breathe * 4);
    final color =
    Color.lerp(AppColors.primaryLight, AppColors.successDark, s)!;

    final corners = _cornerPath(r, _len, _kFrameRadius);

    // Soft glow underneath
    canvas.drawPath(
      corners,
      Paint()
        ..color = color.withValues(alpha: (0.35 + 0.25 * breathe) * intro.value)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke + 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );

    // Crisp corners
    canvas.drawPath(
      corners,
      Paint()
        ..color = color.withValues(alpha: intro.value)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.round,
    );

    // On success the brackets "close" into a full rounded frame.
    if (s > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(_kFrameRadius)),
        Paint()
          ..color = color.withValues(alpha: s)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  Path _cornerPath(Rect r, double l, double rad) {
    final arc = Radius.circular(rad);
    return Path()
    // Top-left
      ..moveTo(r.left, r.top + l)
      ..lineTo(r.left, r.top + rad)
      ..arcToPoint(Offset(r.left + rad, r.top), radius: arc)
      ..lineTo(r.left + l, r.top)
    // Top-right
      ..moveTo(r.right - l, r.top)
      ..lineTo(r.right - rad, r.top)
      ..arcToPoint(Offset(r.right, r.top + rad), radius: arc)
      ..lineTo(r.right, r.top + l)
    // Bottom-right
      ..moveTo(r.right, r.bottom - l)
      ..lineTo(r.right, r.bottom - rad)
      ..arcToPoint(Offset(r.right - rad, r.bottom), radius: arc)
      ..lineTo(r.right - l, r.bottom)
    // Bottom-left
      ..moveTo(r.left + l, r.bottom)
      ..lineTo(r.left + rad, r.bottom)
      ..arcToPoint(Offset(r.left, r.bottom - rad), radius: arc)
      ..lineTo(r.left, r.bottom - l);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter old) => old.rect != rect;
}

/// Laser line with a soft trailing light, sweeping top → bottom and fading
/// at both ends. Clipped to the rounded frame.
class _BeamPainter extends CustomPainter {
  _BeamPainter({
    required this.progress,
    required this.intro,
    required this.success,
  }) : super(repaint: Listenable.merge([progress, intro, success]));

  final Animation<double> progress;
  final Animation<double> intro;
  final Animation<double> success;

  @override
  void paint(Canvas canvas, Size size) {
    final visibility = intro.value * (1 - success.value);
    if (visibility <= 0.01) return;

    final w = size.width;
    final h = size.height;

    canvas.clipRRect(RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(_kFrameRadius),
    ));

    final t = progress.value;
    final y = Curves.easeInOut.transform(t) * h;
    // Fade in at the start, out at the end of every sweep.
    final fade = math.sin(math.pi * t).clamp(0.0, 1.0) * visibility;

    // Trailing glow behind the line
    const trail = 120.0;
    final trailRect = Rect.fromLTWH(0, y - trail, w, trail);
    canvas.drawRect(
      trailRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryLight.withValues(alpha: 0),
            AppColors.primaryLight.withValues(alpha: 0.32 * fade),
          ],
        ).createShader(trailRect),
    );

    // Line (fades toward the edges horizontally)
    final lineShader = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0),
        AppColors.primaryLight.withValues(alpha: fade),
        Colors.white.withValues(alpha: fade),
        AppColors.primaryLight.withValues(alpha: fade),
        Colors.white.withValues(alpha: 0),
      ],
      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
    ).createShader(Rect.fromLTWH(0, y - 2, w, 4));

    // Glow
    canvas.drawLine(
      Offset(10, y),
      Offset(w - 10, y),
      Paint()
        ..shader = lineShader
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );
    // Core
    canvas.drawLine(
      Offset(10, y),
      Offset(w - 10, y),
      Paint()
        ..shader = lineShader
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _BeamPainter old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets
// ─────────────────────────────────────────────────────────────────────────────

/// Check badge that pops in with an elastic bounce and an expanding ripple.
class _SuccessBadge extends StatelessWidget {
  const _SuccessBadge({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final t = animation.value;
        final pop = Curves.elasticOut.transform(t);
        final ripple = Curves.easeOut.transform(t);

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Expanding ripple ring
              Opacity(
                opacity: (1 - ripple).clamp(0.0, 1.0),
                child: Container(
                  width: 76 + ripple * 120,
                  height: 76 + ripple * 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.successDark.withValues(alpha: 0.8),
                      width: 2,
                    ),
                  ),
                ),
              ),
              // Badge
              Transform.scale(
                scale: pop,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.successDark,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.successDark.withValues(alpha: 0.55),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Bottom card whose message adapts to the scanner state.
class _HintCard extends StatelessWidget {
  const _HintCard({required this.isScanned, required this.showHelp});

  final bool isScanned;
  final bool showHelp;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final String title;
    final String subtitle;
    final Color accent;

    if (isScanned) {
      icon = Icons.verified_rounded;
      title = 'Code detected';
      subtitle = 'Just a moment…';
      accent = AppColors.successDark;
    } else if (showHelp) {
      icon = Icons.lightbulb_outline_rounded;
      title = 'Having trouble?';
      subtitle = 'Move closer, hold steady, or turn on the flash';
      accent = AppColors.primaryLight;
    } else {
      icon = Icons.qr_code_scanner_rounded;
      title = 'Align code inside frame';
      subtitle = 'Scanning happens automatically';
      accent = AppColors.primaryLight;
    }

    return _Glass(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.25),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
        child: Row(
          key: ValueKey(title),
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(width: 14),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.whiteText65,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small pill to toggle 1x / 2x zoom.
class _ZoomChip extends StatelessWidget {
  const _ZoomChip({required this.isZoomed, required this.onTap});

  final bool isZoomed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _Glass(
        radius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        tint: isZoomed ? AppColors.primary.withValues(alpha: 0.85) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.zoom_in_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                isZoomed ? '2x' : '1x',
                key: ValueKey(isZoomed),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable frosted-glass container.
class _Glass extends StatelessWidget {
  const _Glass({
    required this.child,
    this.radius = 20,
    this.padding = EdgeInsets.zero,
    this.tint,
  });

  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: padding,
          decoration: BoxDecoration(
            color: tint ?? Colors.black.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Frosted circular button with a subtle press-scale.
class _GlassCircleButton extends StatefulWidget {
  const _GlassCircleButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool isActive;

  @override
  State<_GlassCircleButton> createState() => _GlassCircleButtonState();
}

class _GlassCircleButtonState extends State<_GlassCircleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isActive
                      ? AppColors.primary
                      : Colors.black.withValues(alpha: 0.45),
                  border: Border.all(
                    color: widget.isActive
                        ? AppColors.primaryLight
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                  boxShadow: widget.isActive
                      ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      blurRadius: 14,
                    ),
                  ]
                      : null,
                ),
                child: Icon(widget.icon, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
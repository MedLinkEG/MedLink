import 'package:flutter/material.dart';
import 'package:medlink/core/theme/app_colors.dart';
import 'package:medlink/features/home/domain/hero_banner_slide.dart';

const _bannerHeight = 190.0;
const _bannerRadius = BorderRadius.all(Radius.circular(20));

class HeroBanner extends StatefulWidget {
  const HeroBanner({required this.slides, super.key, this.onCtaTap});

  final List<HeroBannerSlide> slides;

  final ValueChanged<HeroBannerSlide>? onCtaTap;

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  final _controller = PageController();
  var _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = widget.slides;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final height = _bannerHeight * textScale.clamp(1.0, 1.5);

    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (index) => setState(() => _page = index),
            itemBuilder: (context, index) {
              final slide = slides[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _BannerCard(
                  slide: slide,
                  onCtaTap: () => widget.onCtaTap?.call(slide),
                ),
              );
            },
          ),
        ),
        if (slides.length > 1) ...[
          const SizedBox(height: 10),
          _PageDots(count: slides.length, index: _page),
        ],
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.slide, required this.onCtaTap});

  final HeroBannerSlide slide;
  final VoidCallback onCtaTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: _bannerRadius,
      ),
      child: ClipRRect(
        borderRadius: _bannerRadius,
        child: Stack(
          children: [
            const PositionedDirectional(
              end: 0,
              top: 49,
              width: 116,
              height: 40,
              child: ColoredBox(color: AppColors.glassFill),
            ),
            const PositionedDirectional(
              end: 38,
              top: 0,
              width: 40,
              height: 135,
              child: ColoredBox(color: AppColors.glassFill),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BannerText(label: slide.label, title: slide.title),
                    _BannerButton(label: slide.ctaLabel, onTap: onCtaTap),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerText extends StatelessWidget {
  const _BannerText({required this.label, required this.title});

  final String label;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerButton extends StatelessWidget {
  const _BannerButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        minimumSize: const Size(103, 42),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == index ? 22 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == index ? AppColors.dotActive : AppColors.dotInactive,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

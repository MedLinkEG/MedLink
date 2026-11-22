enum HeroBannerAction { scanPrescription, notifyMe, sell }

class HeroBannerSlide {
  const HeroBannerSlide({
    required this.label,
    required this.title,
    required this.ctaLabel,
    required this.action,
  });

  final String label;
  final String title;
  final String ctaLabel;
  final HeroBannerAction action;
}

import 'package:medlink/features/home/domain/hero_banner_slide.dart';

const heroBannerSlides = [
  HeroBannerSlide(
    label: 'MEDLINK AI',
    title: 'Scan your prescription. We find every item nearby.',
    ctaLabel: 'Scan now',
    action: HeroBannerAction.scanPrescription,
  ),

  HeroBannerSlide(
    label: 'MEDLINK ALERTS',
    title: 'Out of stock? We notify you when it is back.',
    ctaLabel: 'Notify me',
    action: HeroBannerAction.notifyMe,
  ),
  HeroBannerSlide(
    label: 'MEDLINK SELL',
    title: 'Have something to sell? List it in minutes.',
    ctaLabel: 'Sell now',
    action: HeroBannerAction.sell,
  ),
];

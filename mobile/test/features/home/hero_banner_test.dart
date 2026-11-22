import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medlink/features/home/data/hero_banner_slides.dart';
import 'package:medlink/features/home/domain/hero_banner_slide.dart';
import 'package:medlink/features/home/presentation/widgets/hero_banner.dart';

void main() {
  Future<void> pumpBanner(
    WidgetTester tester, {
    ValueChanged<HeroBannerSlide>? onCtaTap,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HeroBanner(slides: heroBannerSlides, onCtaTap: onCtaTap),
        ),
      ),
    );
  }

  testWidgets('shows the first slide', (tester) async {
    await pumpBanner(tester);

    final first = heroBannerSlides.first;
    expect(find.text(first.label), findsOneWidget);
    expect(find.text(first.title), findsOneWidget);
    expect(find.text(first.ctaLabel), findsOneWidget);
  });

  testWidgets('reports the slide whose button was tapped', (tester) async {
    final tapped = <HeroBannerSlide>[];
    await pumpBanner(tester, onCtaTap: tapped.add);

    await tester.tap(find.text(heroBannerSlides.first.ctaLabel));

    expect(tapped.single.action, HeroBannerAction.scanPrescription);
  });

  testWidgets('swiping shows the next slide', (tester) async {
    await pumpBanner(tester);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.text(heroBannerSlides[1].title), findsOneWidget);
  });

  testWidgets('fits a small screen', (tester) async {
    tester.view
      ..physicalSize = const Size(640, 1280)
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await pumpBanner(tester);

    expect(tester.takeException(), isNull);
  });
}

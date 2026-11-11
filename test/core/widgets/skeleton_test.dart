import 'package:code_test_madivizion/core/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Skeleton & SkeletonBlock colors', () {
    test('default base and shimmer colors', () {
      expect(SkeletonBlock.base, const Color(0xFFF2F4F7));
      expect(SkeletonBlock.shimmer, const Color(0xFFFFFFFF));
      expect(SkeletonBlock.shimmerEdge, const Color(0xFFF8FAFC));
    });

    testWidgets('renders Skeleton with default dimensions and colors', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Skeleton(height: 50))),
      );

      expect(find.byType(Skeleton), findsOneWidget);
      expect(find.byType(SkeletonShimmer), findsOneWidget);
      expect(find.byType(SkeletonBlock), findsOneWidget);

      final skeletonBlock = tester.widget<SkeletonBlock>(
        find.byType(SkeletonBlock),
      );
      expect(skeletonBlock.height, 50);
      expect(skeletonBlock.color, SkeletonBlock.base);

      final skeletonShimmer = tester.widget<SkeletonShimmer>(
        find.byType(SkeletonShimmer),
      );
      expect(skeletonShimmer.baseColor, SkeletonBlock.base);
      expect(skeletonShimmer.shimmerColor, SkeletonBlock.shimmer);
    });

    testWidgets('supports custom baseColor and shimmerColor', (tester) async {
      const customBase = Color(0xFFEEEEEE);
      const customShimmer = Color(0xFFFFFFFF);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Skeleton(
              height: 40,
              width: 100,
              baseColor: customBase,
              shimmerColor: customShimmer,
            ),
          ),
        ),
      );

      final skeletonShimmer = tester.widget<SkeletonShimmer>(
        find.byType(SkeletonShimmer),
      );
      expect(skeletonShimmer.baseColor, customBase);
      expect(skeletonShimmer.shimmerColor, customShimmer);

      final skeletonBlock = tester.widget<SkeletonBlock>(
        find.byType(SkeletonBlock),
      );
      expect(skeletonBlock.color, customBase);
    });
  });
}

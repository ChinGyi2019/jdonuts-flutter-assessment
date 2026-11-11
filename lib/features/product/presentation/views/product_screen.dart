import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cart/presentation/viewmodels/cart_count.dart';
import '../../di/product_providers.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_artwork.dart';
import '../widgets/product_details.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({required this.id, this.selection, super.key});

  final String id;
  final ProductSelection? selection;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen>
    with SingleTickerProviderStateMixin {
  final _layerKey = GlobalKey();
  final _cartKey = GlobalKey();
  late final _flight = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  Rect? _start;
  Rect? _end;
  Product? _flyingProduct;

  @override
  void dispose() {
    _flight.dispose();
    super.dispose();
  }

  void _addToCart(Product product, int quantity, GlobalKey artworkKey) {
    ref.read(cartCountProvider.notifier).add(quantity);
    if (MediaQuery.disableAnimationsOf(context)) return;
    final layer = _layerKey.currentContext?.findRenderObject();
    final source = artworkKey.currentContext?.findRenderObject();
    final target = _cartKey.currentContext?.findRenderObject();
    if (layer is! RenderBox ||
        source is! RenderBox ||
        target is! RenderBox ||
        !layer.attached ||
        !source.attached ||
        !target.attached ||
        !layer.hasSize ||
        !source.hasSize ||
        !target.hasSize) {
      return;
    }
    final sourceRect =
        layer.globalToLocal(source.localToGlobal(Offset.zero)) & source.size;
    final targetRect =
        layer.globalToLocal(target.localToGlobal(Offset.zero)) & target.size;
    if (!(Offset.zero & layer.size).overlaps(sourceRect)) return;
    setState(() {
      _start = sourceRect;
      _end = Rect.fromCenter(center: targetRect.center, width: 16, height: 16);
      _flyingProduct = product;
    });
    _flight.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) => Stack(
    key: _layerKey,
    fit: StackFit.expand,
    children: [
      _screen(context),
      AnimatedBuilder(
        animation: _flight,
        builder: (context, _) {
          if (_flyingProduct == null || !_flight.isAnimating) {
            return const SizedBox.shrink();
          }
          final progress = Curves.easeInOutCubic.transform(_flight.value);
          final rect = Rect.lerp(_start, _end, progress)!;
          final arc = 50 * 4 * progress * (1 - progress);
          return Positioned.fromRect(
            rect: rect.shift(Offset(0, -arc)),
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: Opacity(
                  opacity: (1 - ((_flight.value - .85) / .15).clamp(0.0, 1.0)),
                  child: ProductArtwork(
                    product: _flyingProduct!,
                    isolated: true,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ],
  );

  Widget _screen(BuildContext context) => Scaffold(
    backgroundColor: AppColors.catalogBackground,
    appBar: AppBar(
      backgroundColor: AppColors.catalogBackground,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _flight,
          builder: (context, child) {
            final pulse = _flight.value > .8
                ? 1 +
                      .2 *
                          (1 -
                              ((_flight.value - .9).abs() / .1).clamp(0.0, 1.0))
                : 1.0;
            return Transform.scale(scale: pulse, child: child);
          },
          child: Padding(
            key: _cartKey,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Semantics(
              label: AppLocalizations.of(
                context,
              )!.cartItemCount(ref.watch(cartCountProvider)),
              liveRegion: true,
              excludeSemantics: true,
              child: Badge.count(
                count: ref.watch(cartCountProvider),
                isLabelVisible: ref.watch(cartCountProvider) > 0,
                child: const Icon(
                  LucideIcons.shoppingCart,
                  color: AppColors.catalogText,
                ),
              ),
            ),
          ),
        ),
      ],
      leading: IconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const Icon(LucideIcons.arrowLeft, color: AppColors.catalogText),
        onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
      ),
    ),
    body: SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: _content(context, ref),
        ),
      ),
    ),
  );

  Widget _content(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final provider = productByIdProvider(widget.id);
    final failure = _ProductStatus(
      strings.productLoadError,
      onRetry: () => ref.invalidate(provider),
    );
    return ref
        .watch(provider)
        .when(
          data: (result) => result.match(
            (_) => failure,
            (product) => product == null
                ? _ProductStatus(strings.productNotFound)
                : ProductDetails(
                    key: ValueKey(widget.id),
                    product: product,
                    onAddToCart: _addToCart,
                    heroTag: widget.selection?.heroTag,
                  ),
          ),
          error: (_, _) => failure,
          loading: () => widget.selection?.product.id == widget.id
              ? ProductDetails(
                  key: ValueKey(widget.id),
                  product: widget.selection!.product,
                  onAddToCart: _addToCart,
                  heroTag: widget.selection!.heroTag,
                )
              : const _ProductLoading(),
        );
  }
}

class _ProductLoading extends StatelessWidget {
  const _ProductLoading();

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    padding: EdgeInsets.all(24),
    child: Column(
      children: [
        Skeleton(height: 355),
        SizedBox(height: 24),
        Skeleton(height: 75),
      ],
    ),
  );
}

class _ProductStatus extends StatelessWidget {
  const _ProductStatus(this.message, {this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(AppLocalizations.of(context)!.retry),
            ),
        ],
      ),
    ),
  );
}

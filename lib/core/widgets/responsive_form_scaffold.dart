// lib/core/widgets/responsive_form_scaffold.dart

import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Klavye açıldığında taşmayı önleyen, tüm form ekranlarında tekrar
/// tekrar yazılmaması için merkezileştirilmiş scaffold şablonu.
/// Auth, Body Measurement, Meal Logging gibi TÜM form ekranlarında
/// düz Scaffold yerine bunu kullanacağız.
class ResponsiveFormScaffold
    extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget child;
  final EdgeInsets padding;

  const ResponsiveFormScaffold({
    super.key,
    this.appBar,
    required this.child,
    this.padding = const EdgeInsets.all(
      AppSpacing.containerMargin,
    ),
  });

  @override
  Widget build(BuildContext context) {
    try {
      final bottomInset = MediaQuery.of(
        context,
      ).viewInsets.bottom;

      return Scaffold(
        appBar: appBar,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,
            padding: padding.add(
              EdgeInsets.only(
                bottom: bottomInset,
              ),
            ),
            child: child,
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[ResponsiveFormScaffold - build]: $error\n$stackTrace',
      );
      // Fallback: en azından kaydırılabilir bir gövde göster, çökme.
      return Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(child: child),
      );
    }
  }
}

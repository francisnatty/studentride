import 'package:flutter/material.dart';

/// Simple and robust page transitions for common navigation patterns
class AppTransitions {
  // ============ SLIDE TRANSITIONS ============

  /// Slide from right to left (iOS default style)
  static Route<T> slideRight<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Slide from left to right
  static Route<T> slideLeft<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Slide from bottom to top (Modal style)
  static Route<T> slideBottom<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Hero-style fade transition (Perfect for post details)
  static Route<T> heroFade<T extends Object?>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.fastOutSlowIn;

        var fadeAnimation = animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve)),
        );

        var scaleAnimation = animation.drive(
          Tween(begin: 0.92, end: 1.0).chain(CurveTween(curve: curve)),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
    );
  }

  // ============ CONVENIENCE METHODS ============

  /// Navigate with slide right transition
  static Future<T?> pushRight<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push<T>(context, slideRight<T>(page));
  }

  /// Navigate with slide left transition
  static Future<T?> pushLeft<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push<T>(context, slideLeft<T>(page));
  }

  /// Navigate with slide bottom transition
  static Future<T?> pushBottom<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push<T>(context, slideBottom<T>(page));
  }

  /// Navigate with hero fade transition
  static Future<T?> pushHeroFade<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push<T>(context, heroFade<T>(page));
  }
}

// ============ EXTENSION FOR EASIER USAGE ============

extension SimpleTransitions on BuildContext {
  /// Navigate with slide right transition
  Future<T?> pushRight<T extends Object?>(Widget page) {
    return AppTransitions.pushRight<T>(this, page);
  }

  /// Navigate with slide left transition
  Future<T?> pushLeft<T extends Object?>(Widget page) {
    return AppTransitions.pushLeft<T>(this, page);
  }

  /// Navigate with slide bottom transition (great for modals)
  Future<T?> pushBottom<T extends Object?>(Widget page) {
    return AppTransitions.pushBottom<T>(this, page);
  }

  /// Navigate with hero fade transition (perfect for post details)
  Future<T?> pushHeroFade<T extends Object?>(Widget page) {
    return AppTransitions.pushHeroFade<T>(this, page);
  }
}

// ============ USAGE EXAMPLES ============

/*
// Example 1: Using AppTransitions class directly
AppTransitions.pushHeroFade(context, PostDetailScreen());

// Example 2: Using the extension (recommended)
context.pushHeroFade(PostDetailScreen());

// Example 3: Different transitions
context.pushRight(ProfileScreen());
context.pushLeft(SettingsScreen());
context.pushBottom(ModalScreen());

// Example 4: Your specific use case
// Instead of:
// Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailScreen()));
// Use:
context.pushHeroFade(PostDetailScreen());
*/

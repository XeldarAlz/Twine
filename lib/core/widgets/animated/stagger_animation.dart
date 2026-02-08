/// Stagger Animation
///
/// Widgets for creating staggered entrance and exit animations.
/// Used throughout Twine for list items, options, and grouped content.
///
/// Usage:
/// ```dart
/// StaggeredList(
///   children: [
///     Text('Item 1'),
///     Text('Item 2'),
///     Text('Item 3'),
///   ],
/// )
/// ```
library;

import 'package:flutter/material.dart';
import '../../theme/motion_tokens.dart';

/// A widget that animates its child with a delayed entrance.
///
/// Use this to create staggered animations where each child
/// appears after a delay.
class StaggeredItem extends StatefulWidget {
  /// The child widget to animate.
  final Widget child;

  /// Index of this item (used to calculate delay).
  final int index;

  /// Delay between each item's animation start.
  final Duration staggerDelay;

  /// Duration of the entrance animation.
  final Duration duration;

  /// The animation curve.
  final Curve curve;

  /// Whether the item should animate in.
  final bool animate;

  /// The type of entrance animation.
  final StaggerAnimation animation;

  /// Creates a StaggeredItem.
  const StaggeredItem({
    super.key,
    required this.child,
    required this.index,
    this.staggerDelay = TwineDurations.listItemStagger,
    this.duration = TwineDurations.normal,
    this.curve = TwineCurves.easeOutQuint,
    this.animate = true,
    this.animation = StaggerAnimation.fadeSlideUp,
  });

  @override
  State<StaggeredItem> createState() => _StaggeredItemState();
}

/// Types of stagger animations available.
enum StaggerAnimation {
  /// Fade in while sliding up.
  fadeSlideUp,

  /// Fade in while sliding down.
  fadeSlideDown,

  /// Fade in while sliding from left.
  fadeSlideLeft,

  /// Fade in while sliding from right.
  fadeSlideRight,

  /// Fade in while scaling up.
  fadeScale,

  /// Simple fade in.
  fade,

  /// Scale up with slight bounce.
  scaleUp,
}

class _StaggeredItemState extends State<StaggeredItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Tween<Offset> _slideTween;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _setupAnimations();

    if (widget.animate) {
      Future.delayed(
        widget.staggerDelay * widget.index,
        () {
          if (mounted) {
            _controller.forward();
          }
        },
      );
    } else {
      _controller.value = 1.0;
    }
  }

  void _setupAnimations() {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curved);

    _scaleAnimation = Tween<double>(
      begin: widget.animation == StaggerAnimation.scaleUp ? 0.8 : 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animation == StaggerAnimation.scaleUp
          ? TwineCurves.playful
          : widget.curve,
    ));

    _slideTween = _getSlideAnimation(curved);
  }

  Tween<Offset> _getSlideAnimation(Animation<double> parent) {
    switch (widget.animation) {
      case StaggerAnimation.fadeSlideUp:
        return Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        );
      case StaggerAnimation.fadeSlideDown:
        return Tween<Offset>(
          begin: const Offset(0, -0.2),
          end: Offset.zero,
        );
      case StaggerAnimation.fadeSlideLeft:
        return Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        );
      case StaggerAnimation.fadeSlideRight:
        return Tween<Offset>(
          begin: const Offset(-0.2, 0),
          end: Offset.zero,
        );
      default:
        return Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        );
    }
  }

  @override
  void didUpdateWidget(StaggeredItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      Future.delayed(
        widget.staggerDelay * widget.index,
        () {
          if (mounted) {
            _controller.forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget result = child!;

        // Apply slide if needed
        if (widget.animation == StaggerAnimation.fadeSlideUp ||
            widget.animation == StaggerAnimation.fadeSlideDown ||
            widget.animation == StaggerAnimation.fadeSlideLeft ||
            widget.animation == StaggerAnimation.fadeSlideRight) {
          result = SlideTransition(
            position: _slideTween.animate(_controller),
            child: result,
          );
        }

        // Apply scale if needed
        if (widget.animation == StaggerAnimation.fadeScale ||
            widget.animation == StaggerAnimation.scaleUp) {
          result = ScaleTransition(
            scale: _scaleAnimation,
            child: result,
          );
        }

        // Always apply fade
        return FadeTransition(
          opacity: _fadeAnimation,
          child: result,
        );
      },
      child: widget.child,
    );
  }
}

/// A column that automatically staggers its children's entrance.
class StaggeredColumn extends StatelessWidget {
  /// The children to display.
  final List<Widget> children;

  /// Delay between each item.
  final Duration staggerDelay;

  /// Duration of each item's animation.
  final Duration duration;

  /// The animation type for all items.
  final StaggerAnimation animation;

  /// Whether to animate.
  final bool animate;

  /// Main axis alignment.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment.
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis size.
  final MainAxisSize mainAxisSize;

  /// Creates a StaggeredColumn.
  const StaggeredColumn({
    super.key,
    required this.children,
    this.staggerDelay = TwineDurations.listItemStagger,
    this.duration = TwineDurations.normal,
    this.animation = StaggerAnimation.fadeSlideUp,
    this.animate = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (int i = 0; i < children.length; i++)
          StaggeredItem(
            index: i,
            staggerDelay: staggerDelay,
            duration: duration,
            animation: animation,
            animate: animate,
            child: children[i],
          ),
      ],
    );
  }
}

/// A row that automatically staggers its children's entrance.
class StaggeredRow extends StatelessWidget {
  /// The children to display.
  final List<Widget> children;

  /// Delay between each item.
  final Duration staggerDelay;

  /// Duration of each item's animation.
  final Duration duration;

  /// The animation type for all items.
  final StaggerAnimation animation;

  /// Whether to animate.
  final bool animate;

  /// Main axis alignment.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment.
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis size.
  final MainAxisSize mainAxisSize;

  /// Creates a StaggeredRow.
  const StaggeredRow({
    super.key,
    required this.children,
    this.staggerDelay = TwineDurations.stagger,
    this.duration = TwineDurations.normal,
    this.animation = StaggerAnimation.fadeSlideLeft,
    this.animate = true,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (int i = 0; i < children.length; i++)
          StaggeredItem(
            index: i,
            staggerDelay: staggerDelay,
            duration: duration,
            animation: animation,
            animate: animate,
            child: children[i],
          ),
      ],
    );
  }
}

/// A ListView builder with staggered entrance animations.
class StaggeredListView extends StatelessWidget {
  /// Number of items.
  final int itemCount;

  /// Builder for each item.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Delay between each item.
  final Duration staggerDelay;

  /// Duration of each item's animation.
  final Duration duration;

  /// The animation type.
  final StaggerAnimation animation;

  /// Scroll controller.
  final ScrollController? controller;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

  /// Physics for the scroll view.
  final ScrollPhysics? physics;

  /// Whether the list should shrink-wrap.
  final bool shrinkWrap;

  /// Creates a StaggeredListView.
  const StaggeredListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.staggerDelay = TwineDurations.listItemStagger,
    this.duration = TwineDurations.normal,
    this.animation = StaggerAnimation.fadeSlideUp,
    this.controller,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return StaggeredItem(
          index: index,
          staggerDelay: staggerDelay,
          duration: duration,
          animation: animation,
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Animated counter that counts up or down to a value.
class AnimatedCounter extends StatefulWidget {
  /// The value to display.
  final int value;

  /// Duration of the count animation.
  final Duration duration;

  /// Text style for the counter.
  final TextStyle? style;

  /// Prefix text before the number.
  final String? prefix;

  /// Suffix text after the number.
  final String? suffix;

  /// Whether to include commas in large numbers.
  final bool includeCommas;

  /// Creates an AnimatedCounter.
  const AnimatedCounter({
    super.key,
    required this.value,
    this.duration = TwineDurations.dramatic,
    this.style,
    this.prefix,
    this.suffix,
    this.includeCommas = true,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: TwineCurves.easeOutQuint,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = (_animation.value).round();
      _animation = Tween<double>(
        begin: _previousValue.toDouble(),
        end: widget.value.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: TwineCurves.easeOutQuint,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    if (!widget.includeCommas) return number.toString();

    final result = StringBuffer();
    final str = number.abs().toString();
    final isNegative = number < 0;

    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(str[i]);
    }

    return isNegative ? '-${result.toString()}' : result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value.round();
        final formatted = _formatNumber(value);
        final text = '${widget.prefix ?? ''}$formatted${widget.suffix ?? ''}';

        return Text(
          text,
          style: widget.style,
        );
      },
    );
  }
}

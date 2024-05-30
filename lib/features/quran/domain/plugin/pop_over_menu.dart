// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum PopoverTransition { scale, other }

enum PopoverDirection {
  top,
  bottom,
  left,
  right,
}

typedef PopoverTransitionBuilder = Widget Function(
  Animation<double> animation,
  Widget child,
);

Future<T?> showPopover<T extends Object?>({
  required BuildContext context,
  required WidgetBuilder bodyBuilder,
  required Offset offset,
  PopoverDirection direction = PopoverDirection.bottom,
  PopoverTransition transition = PopoverTransition.scale,
  Color backgroundColor = const Color(0xffffffff),
  Color barrierColor = const Color(0x80000000),
  Duration transitionDuration = const Duration(milliseconds: 200),
  double radius = 8,
  List<BoxShadow> shadow = const [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 5,
    )
  ],
  double arrowWidth = 24,
  double arrowHeight = 12,
  double arrowDxOffset = 0,
  double arrowDyOffset = 0,
  double contentDyOffset = 0,
  double contentDxOffset = 0,
  bool barrierDismissible = true,
  double? width,
  double? height,
  VoidCallback? onPop,
  @Deprecated(
    'This argument is ignored. Implementation of [PopoverItem] was updated.'
    'This feature was deprecated in v0.2.8',
  )
  bool Function()? isParentAlive,
  BoxConstraints? constraints,
  RouteSettings? routeSettings,
  String? barrierLabel,
  PopoverTransitionBuilder? popoverTransitionBuilder,
  Key? key,
}) {
  constraints = (width != null || height != null)
      ? constraints?.tighten(width: width, height: height) ??
          BoxConstraints.tightFor(width: width, height: height)
      : constraints;

  return Navigator.of(context, rootNavigator: true).push<T>(
    RawDialogRoute<T>(
      pageBuilder: (_, animation, __) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: PopScope(
            onPopInvoked: (_) => onPop?.call(),
            child: PopoverItem(
              offset1: offset,
              transition: transition,
              context: context,
              backgroundColor: backgroundColor,
              direction: direction,
              radius: radius,
              boxShadow: shadow,
              animation: animation,
              arrowWidth: arrowWidth,
              arrowHeight: arrowHeight,
              constraints: constraints,
              arrowDxOffset: arrowDxOffset,
              arrowDyOffset: arrowDyOffset,
              contentDyOffset: contentDyOffset,
              contentDxOffset: contentDxOffset,
              key: key,
              child: Builder(builder: bodyBuilder),
            ),
          ),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel ??
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      settings: routeSettings,
      transitionBuilder: (builderContext, animation, _, child) {
        return popoverTransitionBuilder == null
            ? FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
                child: child,
              )
            : popoverTransitionBuilder(animation, child);
      },
    ),
  );
}

class PopoverItem extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final PopoverDirection? direction;
  final double? radius;
  final List<BoxShadow>? boxShadow;
  final Animation<double> animation;
  final double? arrowWidth;
  final double arrowHeight;
  final BoxConstraints? constraints;
  final BuildContext context;
  final double arrowDxOffset;
  final double arrowDyOffset;
  final double contentDyOffset;
  final double contentDxOffset;
  final Offset offset1;
  final PopoverTransition transition;

  const PopoverItem({
    required this.child,
    required this.offset1,
    required this.context,
    required this.transition,
    required this.animation,
    required this.arrowHeight,
    this.backgroundColor,
    this.direction,
    this.radius,
    this.boxShadow,
    this.arrowWidth,
    this.constraints,
    this.arrowDxOffset = 0,
    this.arrowDyOffset = 0,
    this.contentDyOffset = 0,
    this.contentDxOffset = 0,
    super.key,
  });

  @override
  State<PopoverItem> createState() => _PopoverItemState();
}

class _PopoverItemState extends State<PopoverItem> {
  late Rect _attachRect;
  late BoxConstraints _constraints;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PopoverPositionWidget(
          attachRect: _attachRect,
          constraints: _constraints,
          direction: widget.direction,
          arrowHeight: widget.arrowHeight,
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              return PopoverContext(
                attachRect: _attachRect,
                animation: widget.animation,
                radius: widget.radius,
                backgroundColor: widget.backgroundColor,
                boxShadow: widget.boxShadow,
                direction: widget.direction,
                arrowWidth: widget.arrowWidth,
                arrowHeight: widget.arrowHeight,
                transition: widget.transition,
                child: child,
              );
            },
            child: Material(
              color: widget.backgroundColor,
              child: widget.child,
            ),
          ),
        )
      ],
    );
  }

  @override
  void didChangeDependencies() {
    _configureConstraints();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(_configureRect),
    );

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _configureRect();
    super.initState();
  }

  void _configureConstraints() {
    final size = MediaQuery.of(context).size;
    var constraints = BoxConstraints.loose(size);

    if (widget.constraints != null) {
      constraints = constraints.copyWith(
        minWidth: widget.constraints!.minWidth.isFinite
            ? widget.constraints!.minWidth
            : null,
        minHeight: widget.constraints!.minHeight.isFinite
            ? widget.constraints!.minHeight
            : null,
        maxWidth: widget.constraints!.maxWidth.isFinite
            ? widget.constraints!.maxWidth
            : null,
        maxHeight: widget.constraints!.maxHeight.isFinite
            ? widget.constraints!.maxHeight
            : null,
      );
    }

    if (widget.direction == PopoverDirection.top ||
        widget.direction == PopoverDirection.bottom) {
      final maxHeight = constraints.maxHeight + widget.arrowHeight;
      constraints = constraints.copyWith(maxHeight: maxHeight);
    } else {
      constraints = constraints.copyWith(
        maxHeight: constraints.maxHeight + widget.arrowHeight,
        maxWidth: constraints.maxWidth + widget.arrowWidth!,
      );
    }

    _constraints = constraints;
  }

  void _configureRect() {
    if (!widget.context.mounted) return;
    final offset = BuildContextExtension.getWidgetLocalToGlobal(widget.context);
    final bounds = BuildContextExtension.getWidgetBounds(widget.context);

    if (offset != null && bounds != null) {
      _attachRect = Rect.fromLTWH(
        widget.offset1.dx,
        widget.offset1.dy,
        0,
        0,
      );
    }
  }
}

final class PopoverPositionWidget extends SingleChildRenderObjectWidget {
  final Rect attachRect;
  final double arrowHeight;
  final BoxConstraints? constraints;
  final PopoverDirection? direction;

  const PopoverPositionWidget({
    super.key,
    required this.arrowHeight,
    required this.attachRect,
    this.constraints,
    this.direction,
    Widget? child,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return PopoverPositionRenderObject(
      attachRect: attachRect,
      direction: direction,
      constraints: constraints,
      arrowHeight: arrowHeight,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    PopoverPositionRenderObject renderObject,
  ) {
    renderObject
      ..attachRect = attachRect
      ..direction = direction
      ..additionalConstraints = constraints;
  }
}

final class PopoverPositionRenderObject extends RenderShiftedBox {
  late Rect _attachRect;
  double arrowHeight;
  BoxConstraints? _additionalConstraints;
  PopoverDirection? _direction;

  PopoverPositionRenderObject({
    required this.arrowHeight,
    required Rect attachRect,
    RenderBox? child,
    BoxConstraints? constraints,
    PopoverDirection? direction,
  }) : super(child) {
    _attachRect = attachRect;
    _additionalConstraints = constraints;
    _direction = direction;
  }

  BoxConstraints? get additionalConstraints => _additionalConstraints;
  set additionalConstraints(BoxConstraints? value) {
    if (_additionalConstraints == value) return;
    _additionalConstraints = value;
    markNeedsLayout();
  }

  Rect get attachRect => _attachRect;
  set attachRect(Rect value) {
    if (_attachRect == value) return;
    _attachRect = value;
    markNeedsLayout();
  }

  PopoverDirection? get direction => _direction;
  set direction(PopoverDirection? value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  Offset calculateOffset(Size size) {
    final _direction = PopoverUtils.popoverDirection(
      attachRect,
      size,
      arrowHeight,
      direction,
    );

    if (_direction == PopoverDirection.top ||
        _direction == PopoverDirection.bottom) {
      return _dxOffset(_direction, _horizontalOffset(size), size);
    } else {
      return _dyOffset(_direction, _verticalOffset(size), size);
    }
  }

  @override
  void performLayout() {
    child!.layout(
      _additionalConstraints!.enforce(constraints),
      parentUsesSize: true,
    );
    size = Size(constraints.maxWidth, constraints.maxHeight);
    final childParentData = child!.parentData as BoxParentData;
    childParentData.offset = calculateOffset(child!.size);
  }

  Offset _dxOffset(
    PopoverDirection direction,
    double horizontalOffset,
    Size size,
  ) {
    if (direction == PopoverDirection.bottom) {
      return Offset(horizontalOffset, attachRect.bottom);
    } else {
      return Offset(horizontalOffset, attachRect.top - size.height);
    }
  }

  Offset _dyOffset(
    PopoverDirection _direction,
    double verticalOffset,
    Size size,
  ) {
    if (_direction == PopoverDirection.right) {
      return Offset(attachRect.right, verticalOffset);
    } else {
      return Offset(attachRect.left - size.width, verticalOffset);
    }
  }

  double _horizontalOffset(Size size) {
    var offset = 0.0;

    if (attachRect.left > size.width / 2 &&
        PopoverUtils.physicalSize.width - attachRect.right > size.width / 2) {
      offset = attachRect.left + attachRect.width / 2 - size.width / 2;
    } else if (attachRect.left < size.width / 2) {
      offset = arrowHeight;
    } else {
      offset = PopoverUtils.physicalSize.width - arrowHeight - size.width;
    }
    return offset;
  }

  double _verticalOffset(Size size) {
    var offset = 0.0;

    if (attachRect.top > size.height / 2 &&
        PopoverUtils.physicalSize.height - attachRect.bottom >
            size.height / 2) {
      offset = attachRect.top + attachRect.height / 2 - size.height / 2;
    } else if (attachRect.top < size.height / 2) {
      offset = arrowHeight;
    } else {
      offset = PopoverUtils.physicalSize.height - arrowHeight - size.height;
    }
    return offset;
  }
}

abstract class PopoverUtils {
  static PopoverDirection popoverDirection(
    Rect attachRect,
    Size size,
    double arrowHeight,
    PopoverDirection? direction,
  ) {
    switch (direction) {
      case PopoverDirection.top:
        return (attachRect.top < size.height + arrowHeight)
            ? PopoverDirection.bottom
            : PopoverDirection.top;
      case PopoverDirection.bottom:
        return physicalSize.height >
                attachRect.bottom + size.height + arrowHeight
            ? PopoverDirection.bottom
            : PopoverDirection.top;
      case PopoverDirection.left:
        return (attachRect.left < size.width + arrowHeight)
            ? PopoverDirection.right
            : PopoverDirection.left;
      case PopoverDirection.right:
        return physicalSize.width > attachRect.right + size.width + arrowHeight
            ? PopoverDirection.right
            : PopoverDirection.left;
      default:
        return PopoverDirection.bottom;
    }
  }

  static Size get physicalSize =>
      PlatformDispatcher.instance.views.first.physicalSize /
      PlatformDispatcher.instance.views.first.devicePixelRatio;
}

final class PopoverContext extends SingleChildRenderObjectWidget {
  final PopoverTransition transition;
  final Animation<double> animation;
  final Rect attachRect;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final double? radius;
  final PopoverDirection? direction;
  final double? arrowWidth;
  final double arrowHeight;

  const PopoverContext({
    super.key,
    required this.transition,
    required this.animation,
    required this.attachRect,
    required this.arrowHeight,
    super.child,
    this.backgroundColor,
    this.boxShadow,
    this.radius,
    this.direction,
    this.arrowWidth,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return PopoverRenderShiftedBox(
      attachRect: attachRect,
      color: backgroundColor,
      boxShadow: boxShadow,
      scale: animation.value,
      direction: direction,
      radius: radius,
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    PopoverRenderShiftedBox renderObject,
  ) {
    renderObject
      ..attachRect = attachRect
      ..color = backgroundColor
      ..boxShadow = boxShadow
      ..scale = transition == PopoverTransition.scale ? animation.value : 1.0
      ..direction = direction
      ..radius = radius
      ..arrowWidth = arrowWidth
      ..arrowHeight = arrowHeight;
  }
}

final class PopoverRenderShiftedBox extends RenderShiftedBox {
  late Rect _attachRect;
  double? arrowWidth;
  double arrowHeight;
  PopoverDirection? _direction;
  Color? _color;
  List<BoxShadow>? _boxShadow;
  double? _scale;
  double? _radius;

  PopoverRenderShiftedBox({
    required Rect attachRect,
    required this.arrowHeight,
    this.arrowWidth,
    RenderBox? child,
    Color? color,
    List<BoxShadow>? boxShadow,
    double? scale,
    double? radius,
    PopoverDirection? direction,
  }) : super(child) {
    _attachRect = attachRect;
    _color = color;
    _boxShadow = boxShadow;
    _scale = scale;
    _radius = radius;
    _direction = direction;
  }

  Rect get attachRect => _attachRect;
  set attachRect(Rect value) {
    if (_attachRect == value) return;
    _attachRect = value;
    markNeedsLayout();
  }

  List<BoxShadow>? get boxShadow => _boxShadow;
  set boxShadow(List<BoxShadow>? value) {
    if (_boxShadow == value) return;
    _boxShadow = value;
    markNeedsLayout();
  }

  Color? get color => _color;
  set color(Color? value) {
    if (_color == value) return;
    _color = value;
    markNeedsLayout();
  }

  PopoverDirection? get direction => _direction;
  set direction(PopoverDirection? value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  double? get radius => _radius;
  set radius(double? value) {
    if (_radius == value) return;
    _radius = value;
    markNeedsLayout();
  }

  double? get scale => _scale;
  set scale(double? value) {
    _scale = value;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final transform = Matrix4.identity();
    final childParentData = child!.parentData as BoxParentData;
    final _direction = PopoverUtils.popoverDirection(
      attachRect,
      size,
      arrowHeight,
      direction,
    );
    final bodyRect = childParentData.offset & child!.size;

    final arrowLeft =
        attachRect.left + attachRect.width / 2 - arrowWidth! / 2 - offset.dx;

    final arrowTop =
        attachRect.top + attachRect.height / 2 - arrowWidth! / 2 - offset.dy;

    late Rect arrowRect;
    late Offset translation;

    switch (_direction) {
      case PopoverDirection.top:
        arrowRect = Rect.fromLTWH(
          arrowLeft,
          child!.size.height,
          arrowWidth!,
          arrowHeight,
        );

        translation = Offset(arrowLeft + arrowWidth! / 2, size.height);
        break;
      case PopoverDirection.bottom:
        arrowRect = Rect.fromLTWH(arrowLeft, 0, arrowWidth!, arrowHeight);
        translation = Offset(arrowLeft + arrowWidth! / 2, 0);
        break;
      case PopoverDirection.left:
        arrowRect = Rect.fromLTWH(
          child!.size.width,
          arrowTop,
          arrowHeight,
          arrowWidth!,
        );

        translation = Offset(size.width, arrowTop + arrowWidth! / 2);
        break;
      case PopoverDirection.right:
        arrowRect = Rect.fromLTWH(
          0,
          arrowTop,
          arrowHeight,
          arrowWidth!,
        );
        translation = Offset(0, arrowTop + arrowWidth! / 2);
        break;
    }

    _transform(transform, translation);

    _paintShadows(context, transform, offset, _direction, arrowRect, bodyRect);

    _pushClipPath(
      context,
      offset,
      PopoverPath(radius!).draw(_direction, arrowRect, bodyRect),
      transform,
    );
  }

  @override
  void performLayout() {
    assert(constraints.maxHeight.isFinite);

    _configureChildConstrains();
    _configureChildSize();
    _configureChildOffset();
  }

  void _configureChildConstrains() {
    BoxConstraints childConstraints;

    if (direction == PopoverDirection.top ||
        direction == PopoverDirection.bottom) {
      childConstraints = BoxConstraints(
        maxHeight: constraints.maxHeight - arrowHeight,
      ).enforce(constraints);
    } else {
      childConstraints = BoxConstraints(
        maxWidth: constraints.maxWidth - arrowHeight,
      ).enforce(constraints);
    }

    child!.layout(childConstraints, parentUsesSize: true);
  }

  void _configureChildOffset() {
    final _direction = PopoverUtils.popoverDirection(
      attachRect,
      size,
      arrowHeight,
      direction,
    );

    final childParentData = child!.parentData as BoxParentData?;
    if (_direction == PopoverDirection.bottom) {
      childParentData!.offset = Offset(0, arrowHeight);
    } else if (_direction == PopoverDirection.right) {
      childParentData!.offset = Offset(arrowHeight, 0);
    } else {
      childParentData!.offset = const Offset(0, 0);
    }
  }

  void _configureChildSize() {
    if (direction == PopoverDirection.top ||
        direction == PopoverDirection.bottom) {
      size = Size(child!.size.width, child!.size.height + arrowHeight);
    } else {
      size = Size(child!.size.width + arrowHeight, child!.size.height);
    }
  }

  void _paintShadows(
    PaintingContext context,
    Matrix4 transform,
    Offset offset,
    PopoverDirection direction,
    Rect? arrowRect,
    Rect bodyRect,
  ) {
    if (boxShadow == null) return;
    for (final boxShadow in boxShadow!) {
      final paint = boxShadow.toPaint();

      arrowRect = arrowRect!
          .shift(offset)
          .shift(boxShadow.offset)
          .inflate(boxShadow.spreadRadius);

      bodyRect = bodyRect
          .shift(offset)
          .shift(boxShadow.offset)
          .inflate(boxShadow.spreadRadius);

      final path = PopoverPath(radius!).draw(_direction, arrowRect, bodyRect);

      context.pushTransform(needsCompositing, offset, transform, (
        context,
        offset,
      ) {
        context.canvas.drawPath(path, paint);
      });
    }
  }

  void _pushClipPath(
    PaintingContext context,
    Offset offset,
    Path path,
    Matrix4 transform,
  ) {
    context.pushClipPath(needsCompositing, offset, offset & size, path, (
      context,
      offset,
    ) {
      context.pushTransform(needsCompositing, offset, transform, (
        context,
        offset,
      ) {
        final backgroundPaint = Paint();
        backgroundPaint.color = color!;
        context.canvas.drawRect(offset & size, backgroundPaint);
        super.paint(context, offset);
      });
    });
  }

  void _transform(Matrix4 transform, Offset translation) {
    transform.translate(translation.dx, translation.dy);
    transform.scale(scale, scale, 1);
    transform.translate(-translation.dx, -translation.dy);
  }
}

final class PopoverPath {
  final double radius;

  const PopoverPath(this.radius);

  Path draw(
    PopoverDirection? direction,
    Rect? arrowRect,
    Rect bodyRect,
  ) {
    final path = Path();

    if (arrowRect != null) {
      if (direction == PopoverDirection.top) {
        _drawTopElement(path, arrowRect, bodyRect);
      } else if (direction == PopoverDirection.right) {
        _drawRightElement(path, arrowRect, bodyRect);
      } else if (direction == PopoverDirection.left) {
        _drawLeftElement(path, arrowRect, bodyRect);
      } else {
        _drawBottomElement(path, arrowRect, bodyRect);
      }
      path.close();
      return path;
    } else {
      path.close();
      return path;
    }
  }

  void _drawBottomElement(Path path, Rect arrowRect, Rect bodyRect) {
    path.moveTo(arrowRect.left, arrowRect.bottom);
    path.lineTo(arrowRect.left + arrowRect.width / 2, arrowRect.top);
    path.lineTo(arrowRect.right, arrowRect.bottom);

    path.lineTo(bodyRect.right - radius, bodyRect.top);
    path.conicTo(
      bodyRect.right,
      bodyRect.top,
      bodyRect.right,
      bodyRect.top + radius,
      1,
    );

    path.lineTo(bodyRect.right, bodyRect.bottom - radius);
    path.conicTo(
      bodyRect.right,
      bodyRect.bottom,
      bodyRect.right - radius,
      bodyRect.bottom,
      1,
    );

    path.lineTo(bodyRect.left + radius, bodyRect.bottom);
    path.conicTo(
      bodyRect.left,
      bodyRect.bottom,
      bodyRect.left,
      bodyRect.bottom - radius,
      1,
    );

    path.lineTo(bodyRect.left, bodyRect.top + radius);
    path.conicTo(
      bodyRect.left,
      bodyRect.top,
      bodyRect.left + radius,
      bodyRect.top,
      1,
    );
  }

  void _drawLeftElement(Path path, Rect arrowRect, Rect bodyRect) {
    path.moveTo(arrowRect.left, arrowRect.top);
    path.lineTo(arrowRect.right, arrowRect.top + arrowRect.height / 2);
    path.lineTo(arrowRect.left, arrowRect.bottom);

    path.lineTo(bodyRect.right, bodyRect.bottom - radius);
    path.conicTo(
      bodyRect.right,
      bodyRect.bottom,
      bodyRect.right - radius,
      bodyRect.bottom,
      1,
    );

    path.lineTo(bodyRect.left + radius, bodyRect.bottom);
    path.conicTo(
      bodyRect.left,
      bodyRect.bottom,
      bodyRect.left,
      bodyRect.bottom - radius,
      1,
    );

    path.lineTo(bodyRect.left, bodyRect.top + radius);
    path.conicTo(
      bodyRect.left,
      bodyRect.top,
      bodyRect.left + radius,
      bodyRect.top,
      1,
    );

    path.lineTo(bodyRect.right - radius, bodyRect.top);
    path.conicTo(
      bodyRect.right,
      bodyRect.top,
      bodyRect.right,
      bodyRect.top + radius,
      1,
    );
  }

  void _drawRightElement(Path path, Rect arrowRect, Rect bodyRect) {
    path.moveTo(arrowRect.right, arrowRect.top);
    path.lineTo(arrowRect.left, arrowRect.top + arrowRect.height / 2);
    path.lineTo(arrowRect.right, arrowRect.bottom);

    path.lineTo(bodyRect.left, bodyRect.bottom - radius);
    path.conicTo(
      bodyRect.left,
      bodyRect.bottom,
      bodyRect.left + radius,
      bodyRect.bottom,
      1,
    );

    path.lineTo(bodyRect.right - radius, bodyRect.bottom);
    path.conicTo(
      bodyRect.right,
      bodyRect.bottom,
      bodyRect.right,
      bodyRect.bottom - radius,
      1,
    );

    path.lineTo(bodyRect.right, bodyRect.top + radius);
    path.conicTo(
      bodyRect.right,
      bodyRect.top,
      bodyRect.right - radius,
      bodyRect.top,
      1,
    );

    path.lineTo(bodyRect.left + radius, bodyRect.top);
    path.conicTo(
      bodyRect.left,
      bodyRect.top,
      bodyRect.left,
      bodyRect.top + radius,
      1,
    );
  }

  void _drawTopElement(Path path, Rect arrowRect, Rect bodyRect) {
    path.moveTo(arrowRect.left, arrowRect.top);
    path.lineTo(arrowRect.left + arrowRect.width / 2, arrowRect.bottom);
    path.lineTo(arrowRect.right, arrowRect.top);

    path.lineTo(bodyRect.right - radius, bodyRect.bottom);
    path.conicTo(
      bodyRect.right,
      bodyRect.bottom,
      bodyRect.right,
      bodyRect.bottom - radius,
      1,
    );

    path.lineTo(bodyRect.right, bodyRect.top + radius);
    path.conicTo(
      bodyRect.right,
      bodyRect.top,
      bodyRect.right - radius,
      bodyRect.top,
      1,
    );

    path.lineTo(bodyRect.left + radius, bodyRect.top);
    path.conicTo(
      bodyRect.left,
      bodyRect.top,
      bodyRect.left,
      bodyRect.top + radius,
      1,
    );

    path.lineTo(bodyRect.left, bodyRect.bottom - radius);
    path.conicTo(
      bodyRect.left,
      bodyRect.bottom,
      bodyRect.left + radius,
      bodyRect.bottom,
      1,
    );
  }
}

extension BuildContextExtension on BuildContext {
  static Rect? getWidgetBounds(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return (box != null) ? box.semanticBounds : null;
  }

  static Offset? getWidgetLocalToGlobal(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return (box != null) ? box.localToGlobal(Offset.zero) : null;
  }
}

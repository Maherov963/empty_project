import 'package:flutter/material.dart';

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final List<Widget> expandedChild;
  final bool expand;
  final EdgeInsets padding;
  final Duration duration;
  final Color? color;
  final Function()? onTap;

  const ExpandedSection({
    super.key,
    this.expand = false,
    this.onTap,
    this.color,
    this.padding = const EdgeInsets.all(5),
    this.duration = const Duration(milliseconds: 300),
    required this.child,
    required this.expandedChild,
  });

  @override
  State<ExpandedSection> createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.duration,
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.linear,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      decoration: BoxDecoration(
        color: widget.expand
            ? Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.5)
            : widget.color ?? Colors.transparent,
        borderRadius: widget.expand
            ? BorderRadius.circular(15)
            : BorderRadius.circular(15),
      ),
      margin: widget.expand ? widget.padding : const EdgeInsets.all(0),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.expand ? 15 : 15),
              topRight: Radius.circular(widget.expand ? 15 : 15),
              bottomLeft: Radius.circular(widget.expand ? 0 : 15),
              bottomRight: Radius.circular(widget.expand ? 0 : 15),
            ),
            onTap: widget.onTap,
            child: widget.child,
          ),
          // if (widget.expand) const Divider(height: 1, thickness: 1),
          if (widget.expand || expandController.value == 1)
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: widget.expandedChild),
              ),
            ),
        ],
      ),
    );
  }
}

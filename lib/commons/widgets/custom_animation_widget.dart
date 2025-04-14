import 'package:flutter/material.dart';

class CustomAnimationWidget extends StatefulWidget {
  const CustomAnimationWidget({
    super.key,
    required this.child,
    this.timeAnimated,
    this.onAnimation = true,
    this.minScale = 0.96,
  });

  final Widget child;
  final int? timeAnimated;
  final bool onAnimation;
  final double minScale;
  @override
  State<CustomAnimationWidget> createState() => _CustomAnimationWidgetState();
}

class _CustomAnimationWidgetState extends State<CustomAnimationWidget> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        if (mounted && widget.onAnimation) {
          setState(() {
            _scale = widget.minScale;
          });
        }
      },
      onPointerUp: (event) {
        if (mounted && widget.onAnimation) {
          setState(() {
            _scale = 1.0;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.timeAnimated ?? 100),
        transform: Matrix4.identity()..scale(_scale, _scale),
        child: widget.child,
      ),
    );
  }
}

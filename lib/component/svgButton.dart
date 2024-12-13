import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HoverableSvgButton extends StatefulWidget {
  final String svgPath;
  final Color color;
  final Color hoverColor;
  final Color activeColor; 
  final VoidCallback onClick;
  final double size;
  final bool isActive;

  const HoverableSvgButton({
    Key? key,
    required this.svgPath,
    required this.color,
    required this.hoverColor,
    required this.activeColor, 
    required this.onClick,
    required this.size,
    required this.isActive, 
  }) : super(key: key);

  @override
  State<HoverableSvgButton> createState() => _HoverableSvgButtonState();
}

class _HoverableSvgButtonState extends State<HoverableSvgButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Priorité : actif > hover > normal
    Color currentColor = widget.isActive
        ? widget.activeColor
        : (isHovered ? widget.hoverColor : widget.color);

    return GestureDetector(
      onTap: widget.onClick,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: SvgPicture.asset(
          widget.svgPath,
          color: currentColor,
          height: widget.size,
        ),
      ),
    );
  }
}

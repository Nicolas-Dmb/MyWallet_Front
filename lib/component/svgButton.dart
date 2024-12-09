import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HoverableSvgButton extends StatefulWidget{
    final String svgPath;
    final Color color;
    final Color hoverColor;
    final VoidCallback onClick;
    final double size;

    const HoverableSvgButton({
        Key? key,
        required this.svgPath,
        required this.color,
        required this.hoverColor,
        required this.onClick,
        required this.size,
    }) : super(key: key);

    @override
  State<HoverableSvgButton> createState() => _HoverableSvgButtonState();
}
class _HoverableSvgButtonState extends State<HoverableSvgButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: SvgPicture.asset(
          widget.svgPath,
          color: isHovered ? widget.hoverColor : widget.color, 
          height: widget.size,
        ),
      ),
    );
  }
}
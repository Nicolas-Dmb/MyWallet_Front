import 'package:flutter/material.dart';

class HoverableTextButton extends StatefulWidget{
    final String text;
    final Color color;
    final Color hoverColor;
    final VoidCallback onClick;
    final double fontSize;
    //final double sizeHeight;
    //final double sizeWidth;

    const HoverableTextButton({
        Key? key,
        required this.text,
        required this.color,
        required this.hoverColor,
        required this.onClick,
        //required this.sizeHeight,
        //required this.sizeWidth,
        required this.fontSize,
    }) : super(key: key);

    @override
    State<HoverableTextButton> createState() => _HoverableTextButtonState();
}
class _HoverableTextButtonState extends State<HoverableTextButton> {
    bool isHovered = false;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: widget.onClick,
            child: MouseRegion(
                onEnter: (_) => setState(() => isHovered = true),
                onExit: (_) => setState(() => isHovered = false),
                child: Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontFamily: 'TANNIMBUS',
                    color: isHovered ? widget.hoverColor : widget.color, 
                    fontSize: widget.fontSize,
                    ),
                ),
            ),
        );
    }
}
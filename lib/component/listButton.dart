import 'package:flutter/material.dart';
import 'package:choice/choice.dart';

class InlineScrollableX extends StatefulWidget {
  final List<String>  choices;
  final String defaultValue;
  final Function(String) onClick;
  final bool modif;
  final int color;
  final int textColor;
  final int activeColor;

  const InlineScrollableX({
    required this.choices,
    required this.defaultValue,
    required this.onClick,
    required this.modif,
    required this.textColor,
    required this.color,
    required this.activeColor,
    super.key
    });

  @override
  State<InlineScrollableX> createState() => _InlineScrollableXState();
}

class _InlineScrollableXState extends State<InlineScrollableX> {
  String? selectedValue ;

  @override
  void initState() {
  super.initState();
    if (widget.defaultValue.isEmpty) {
      print("Erreur : defaultValue est vide !");
    } else {
      print("widget.defaultValue : ${widget.defaultValue}");
    }

    selectedValue = widget.defaultValue;
    print("selectedValue : $selectedValue");
  }

  void setSelectedValue(String? value) {
    setState(() {
      selectedValue = value;
    });
    widget.onClick(widget.modif ? value ?? widget.defaultValue : widget.defaultValue ); 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Choice<String>.inline(
          clearable: false,
          value: ChoiceSingle.value(selectedValue),
          onChanged: widget.modif ? ChoiceSingle.onChanged(setSelectedValue):null,
          itemCount: widget.choices.length,
          itemBuilder: (state, i) {
            return ChoiceChip(
              selected: state.selected(widget.choices[i]),
              onSelected: state.onSelected(widget.choices[i]),
              label: Text(widget.choices[i],style: TextStyle(color: Color(widget.textColor),),), 
              selectedColor: Color(widget.activeColor),
              backgroundColor: Color(widget.color),
            );
          },
          listBuilder: ChoiceList.createScrollable(
            spacing: 10,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),
          ),
        ),
        /*InlineChoice<String>.single(
          clearable: true,
          value: selectedValue,
          onChanged: setSelectedValue,
          itemCount: widget.choices.length,
          itemBuilder: (state, i) {
            return ChoiceChip(
              selected: state.selected(widget.choices[i]),
              onSelected: state.onSelected(widget.choices[i]),
              label: Text(widget.choices[i]),
            );
          },
          listBuilder: ChoiceList.createWrapped(
            spacing: 10,
            runSpacing: 10,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),
          ),
        ),*/
      ],
    );
  }
}
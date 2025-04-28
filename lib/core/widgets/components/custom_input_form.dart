import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

class CustomTextForm extends StatefulWidget {
  final ValueChanged<String>? onChangedValue;
  final bool isObscure;
  final TextEditingController? controller;
  final String? labelText;
  const CustomTextForm({
    super.key,
    this.onChangedValue,
    this.isObscure = false,
    this.controller,
    this.labelText,
  });

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  bool _isObscure = false;
  @override
  void initState() {
    super.initState();
    _isObscure = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: AppTextStyles.text,
      onChanged: widget.onChangedValue,
      obscureText: _isObscure,
      controller: widget.controller,
      cursorColor: AppColors.border3,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        labelText: widget.labelText,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.interactive1, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border3, width: 3),
        ),
        fillColor: Colors.transparent,
        focusColor: Colors.transparent,
        suffixIcon:
            widget.isObscure
                ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color:
                        _isObscure ? AppColors.border3 : AppColors.interactive1,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
                : null,
      ),
    );
  }
}

class CustomIntForm extends StatefulWidget {
  final ValueChanged<String>? onChangedValue;
  final TextEditingController? controller;
  final String? labelText;
  const CustomIntForm({
    super.key,
    this.onChangedValue,
    this.controller,
    this.labelText,
  });

  @override
  State<CustomTextForm> createState() => _CustomIntFormState();
}

class _CustomIntFormState extends State<CustomTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        labelText: widget.labelText,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.interactive1, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border3, width: 3),
        ),
        fillColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
      onChanged: widget.onChangedValue,
      cursorColor: AppColors.border3,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mywallet_mobile/core/custom_barrel.dart';

class CustomTextForm extends StatefulWidget {
  final ValueChanged<String>? onChangedValue;
  final bool isObscure;
  final TextEditingController? controller;
  final String? labelText;
  final bool focus;
  const CustomTextForm({
    super.key,
    this.onChangedValue,
    this.isObscure = false,
    this.controller,
    this.labelText,
    this.focus = false,
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
      autofocus: widget.focus,
      style: AppTextStyles.text,
      onChanged: widget.onChangedValue,
      obscureText: _isObscure,
      controller: widget.controller,
      cursorColor: AppColors.border3,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        labelText: widget.labelText,
        labelStyle: AppTextStyles.text,
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
  final bool focus;

  const CustomIntForm({
    super.key,
    this.onChangedValue,
    this.controller,
    this.labelText,
    this.focus = false,
  });

  @override
  State<CustomIntForm> createState() => _CustomIntFormState();
}

class _CustomIntFormState extends State<CustomIntForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void didUpdateWidget(covariant CustomIntForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? TextEditingController();
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: widget.focus,
      controller: _controller,
      style: AppTextStyles.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        labelText: widget.labelText,
        labelStyle: AppTextStyles.text,
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

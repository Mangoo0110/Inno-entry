import 'package:flutter/material.dart';

class CreateAccountPinField extends StatefulWidget {
  const CreateAccountPinField({
    super.key,
    required this.controller,
    required this.enabled,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSubmitted;

  @override
  State<CreateAccountPinField> createState() => CreateAccountPinFieldState();
}

class CreateAccountPinFieldState extends State<CreateAccountPinField> {
  String? _errorText;

  bool validateForSubmit() {
    final errorText = _pinErrorFor(
      widget.controller.text,
      validateLength: true,
    );
    if (errorText != _errorText) {
      setState(() => _errorText = errorText);
    }
    return errorText == null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _errorText == null ? 78 : 94,
      child: TextField(
        controller: widget.controller,
        maxLines: 1,
        enabled: widget.enabled,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        obscureText: true,
        maxLength: 6,
        decoration: InputDecoration(
          labelText: 'PIN (4-6 digits)',
          helperText: 'Use numbers 1 to 6 only',
          errorText: _errorText,
          counterText: '',
        ),
        onChanged: _onChanged,
        onSubmitted: (_) => widget.onSubmitted(),
      ),
    );
  }

  void _onChanged(String value) {
    final errorText = _pinErrorFor(value, validateLength: false);
    if (errorText == _errorText) return;
    setState(() => _errorText = errorText);
  }

  String? _pinErrorFor(String value, {required bool validateLength}) {
    if (value.contains(RegExp(r'[^1-6]'))) {
      return 'Use numbers 1 to 6 only.';
    }

    if (!validateLength) return null;
    if (value.length < 4) return 'PIN must be at least 4 digits.';
    if (value.length > 6) return 'PIN can be up to 6 digits.';
    return null;
  }
}

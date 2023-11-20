import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormFieldWidget extends StatefulWidget {
  final Function(String, dynamic) onChange;
  final String name;
  final String label;
  final String helperText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool isPassword;
  final bool enable;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const FormFieldWidget({
    super.key,
    required this.onChange,
    required this.name,
    required this.label,
    required this.helperText,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.words,
    this.initialValue,
    this.validator,
    this.isPassword = false,
    this.enable = true,
    this.controller,
    this.focusNode,
  });

  @override
  State<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends State<FormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return field;
  }

  Widget get field {
    // For some reason, the keyboardType and textCapitalization is conflicting
    // so, I'm using the keyboardType only for emails addresses
    var keyboardType = widget.keyboardType;
    if (![TextInputType.emailAddress, TextInputType.number]
        .contains(keyboardType)) {
      keyboardType = null;
    }
    return FormBuilderTextField(
      obscureText: widget.isPassword,
      autocorrect: !widget.isPassword,
      name: widget.name,
      textCapitalization: widget.textCapitalization,
      initialValue: initialValue,
      inputFormatters: widget.inputFormatters,
      keyboardType: keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.isPassword ? 1 : null,
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enable,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: widget.helperText,
        helperStyle: Theme.of(context).textTheme.labelMedium,
        floatingLabelStyle: Theme.of(context).textTheme.bodyLarge,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inversePrimary, width: 2),
        ),
        alignLabelWithHint: true,
        // labelStyle: const TextStyle().copyWith(
        //   color: Palette.primaryColor,
        // ),
      ),
      onChanged: (value) {
        widget.onChange(widget.name, value);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
    );
  }

  String? get initialValue {
    String? initialValue = widget.initialValue;
    if (widget.controller != null && initialValue != null) {
      widget.controller!.value = TextEditingValue(text: widget.initialValue!);
      initialValue = null;
    }

    return initialValue;
  }
}

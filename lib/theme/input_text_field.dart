// ignore_for_file: overridden_fields, must_be_immutable, annotate_overrides, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guestbook/theme/colors.dart';
import 'package:guestbook/theme/text_formatters.dart';

/// A custom input form text field widget that supports various configurations
/// such as country picker, date picker, and input formatters.
class InputFormTextField extends StatefulWidget {
  final String hint;
  final bool isOptional;
  final TextInputType keyboardType;
  final String? title;
  final String? subtitle;
  final String? initialValue;
  TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final GlobalKey<InputFormTextFieldState>? key;
  final bool editable;
  final FocusNode? focusNode;
  final double marginBottom;
  final bool addCountryPicker;
  final Function(String)? onChanged;
  final Function? onTap;
  final Widget? prefix;
  final Widget? suffix;
  final bool? isDatepicker;
  final DateTime? selectedDate;
  final Function(DateTime)? onSelectedDate;
  final Function(String)? onPhoneCodeSelected;
  final bool capitalizeFirstLetter;
  final int? minLines;
  final String? selectedPhoneCode;
  final Decoration? decoration;
  final EdgeInsetsGeometry? contentPadding;
  final bool isRequired;
  final int? maxLength;
  final Color? backgroundColor;
  final String? counterText;

  /// Creates an [InputFormTextField] widget.
  ///
  /// The [hint], [isOptional], [editable], [keyboardType], [marginBottom],
  /// [addCountryPicker], and [capitalizeFirstLetter] parameters have default values.
  InputFormTextField(
      {this.key,
      this.hint = "",
      this.isOptional = false,
      this.editable = true,
      this.keyboardType = TextInputType.text,
      this.title,
      this.subtitle,
      this.maxLength,
      this.counterText,
      this.focusNode,
      this.isRequired = false,
      this.controller,
      this.contentPadding,
      this.decoration,
      this.marginBottom = 20,
      this.addCountryPicker = false,
      this.onChanged,
      this.onTap,
      this.prefix,
      this.initialValue,
      this.capitalizeFirstLetter = false,
      this.isDatepicker,
      this.suffix,
      this.selectedDate,
      this.onSelectedDate,
      this.backgroundColor,
      this.selectedPhoneCode,
      this.minLines,
      this.onPhoneCodeSelected,
      this.inputFormatters})
      : super(key: key) {
    controller ??= TextEditingController();
  }

  @override
  State<InputFormTextField> createState() =>
      InputFormTextFieldState(addCountryPicker: addCountryPicker);
}

/// State class for [InputFormTextField].
class InputFormTextFieldState extends State<InputFormTextField> {
  bool showWarning = false;
  String selectedPhoneCode = "";
  String selectedCountryCode = "ID";

  /// Validates the input field.
  ///
  /// Returns `true` if the input is valid, otherwise `false`.
  bool validate() {
    showWarning =
        !(widget.controller?.text.isNotEmpty ?? false) && !widget.isOptional;
    setState(() {});
    if (showWarning) {
      if (widget.focusNode != null) {
        widget.focusNode?.requestFocus();
      }
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  /// Constructor for [InputFormTextFieldState].
  ///
  /// Initializes the [selectedPhoneCode] based on the [addCountryPicker] parameter.
  InputFormTextFieldState({bool addCountryPicker = false}) {
    selectedPhoneCode = addCountryPicker ? "+62" : "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (widget.title == null)
                ? Container()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.title!,
                          style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.black500)),
                      widget.isRequired
                          ? Text("*",
                              style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFFF80E46), fontSize: 12))
                          : Container(),
                      const SizedBox(width: 10),
                      widget.isOptional
                          ? Text("(optional",
                              style: GoogleFonts.plusJakartaSans(
                                  color: Colors.grey, fontSize: 12))
                          : Container()
                    ],
                  ),
            (showWarning)
                ? Text("warning fill",
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.0, color: Colors.red))
                : Container(),
          ],
        ),
        widget.subtitle == null
            ? Container()
            : Text(widget.subtitle!,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    letterSpacing: 0.4,
                    height: 1.9,
                    color: AppColors.black300)),
        const SizedBox(height: 12),
        Container(
          decoration: widget.decoration ??
              BoxDecoration(
                  color: widget.backgroundColor ?? Colors.transparent,
                  border: Border.all(width: 1, color: AppColors.black300),
                  borderRadius: BorderRadius.circular(20)),
          padding: widget.contentPadding ??
              EdgeInsets.symmetric(
                  horizontal: widget.addCountryPicker ? 8 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.prefix ?? Container(),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: TextFormField(
                    maxLength: widget.maxLength,
                    minLines: widget.minLines,
                    maxLines: widget.minLines,
                    initialValue: widget.initialValue,
                    readOnly: (widget.isDatepicker ?? !widget.editable),
                    controller:
                        widget.initialValue == null ? widget.controller : null,
                    focusNode: widget.focusNode,
                    textInputAction: TextInputAction.done,
                    keyboardType: widget.keyboardType,
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface),
                    inputFormatters: widget.inputFormatters ??
                        (widget.capitalizeFirstLetter
                            ? [UpperCaseTextFormatter()]
                            : []),
                    onChanged: (value) {
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                    },
                    onTap: () {
                      if (widget.onTap != null) {
                        widget.onTap!();
                      }
                    },
                    decoration: inputTextFieldDecoration(
                        hint: widget.hint, counterText: widget.counterText),
                  ),
                ),
              ),
              widget.suffix ?? Container()
            ],
          ),
        ),
        // Divider(height: 1, color: AppColors.instance.getTitleColor()),
        SizedBox(height: widget.marginBottom),
      ],
    );
  }
}

/// Creates an [InputDecoration] for the text field.
///
/// The [hint], [icon], [contentPadding], and [counterText] parameters are optional.
InputDecoration inputTextFieldDecoration(
        {String? hint,
        Widget? icon,
        EdgeInsetsGeometry? contentPadding,
        String? counterText}) =>
    InputDecoration(
      hintText: hint,
      counterText: counterText, // Hilangkan default counter text
      hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.black300, fontSize: 16, fontWeight: FontWeight.w400),
      icon: icon,
      fillColor: Colors.transparent,
      filled: true,
      border: InputBorder.none,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
    );

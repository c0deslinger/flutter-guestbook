// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guestbook/theme/colors.dart';

/// A customizable rounded material button with loading state.
class RoundedMaterialButton extends StatefulWidget {
  /// The background color of the button.
  final Color? color;

  /// The color of the loading indicator.
  final Color? loadingColor;

  /// The text style of the button label.
  final TextStyle? textStyle;

  /// The label text of the button.
  final String label;

  /// The width of the button.
  final double width;

  /// The height of the button.
  final double height;

  /// The padding inside the button.
  final EdgeInsetsGeometry? padding;

  /// The border radius of the button.
  final double radius;

  /// Whether the button is disabled.
  final bool disabled;

  /// Whether the button is outlined.
  final bool isOutlined;

  /// Whether the button has a plain background.
  final bool isPlainBackground;

  /// The elevation of the button.
  final double elevation;

  /// The border color of the button.
  final Color? borderColor;

  /// An optional prefix icon for the button.
  final Widget? prefixIcon;

  /// An optional widget to replace the label text.
  final Widget? labelWidget;

  /// The callback function when the button is pressed.
  final Function(LoadingButtonController loadingController)? onPressed;

  /// The callback function when the button is pressed while disabled.
  final Function(LoadingButtonController loadingController)?
      onPressedWhenDisabled;

  /// Creates a rounded material button.
  const RoundedMaterialButton(
      {super.key,
      required this.label,
      this.textStyle,
      this.loadingColor,
      this.padding = const EdgeInsets.all(0),
      this.color,
      this.radius = 50,
      this.labelWidget,
      this.borderColor,
      this.width = double.infinity,
      this.height = 50,
      this.isOutlined = false,
      this.isPlainBackground = true,
      this.prefixIcon,
      this.disabled = false,
      this.elevation = 8,
      this.onPressedWhenDisabled,
      this.onPressed});

  @override
  _RoundedMaterialButtonState createState() => _RoundedMaterialButtonState();
}

class _RoundedMaterialButtonState extends State<RoundedMaterialButton> {
  bool _isLoading = false;
  LoadingButtonController? controller;

  @override
  void initState() {
    super.initState();
    controller =
        LoadingButtonController(startLoading: _start, stopLoading: _stop);
  }

  /// Sets the border color of the button based on its state.
  Color setBorderColor() {
    bool isOutlined = widget.isOutlined;
    bool isDisabled = widget.disabled;

    if (isOutlined) {
      if (isDisabled) {
        return AppColors.black300;
      } else {
        return (widget.borderColor ?? AppColors.black500);
      }
    } else {
      if (isDisabled) {
        return Colors.transparent;
      } else {
        return (widget.borderColor ?? Colors.transparent);
      }
    }
  }

  /// Gets the text color of the button based on its state and theme.
  Color getTextColor(bool isDarkMode) {
    bool isOutlined = widget.isOutlined;
    bool isDisabled = widget.disabled;
    if (isOutlined) {
      if (isDisabled) {
        return AppColors.black300;
      } else {
        return (AppColors.black500);
      }
    } else {
      if (isDisabled) {
        return isDarkMode ? Colors.white.withOpacity(.4) : Colors.white;
      } else {
        return Colors.white;
      }
    }
  }

  /// Gets the background color of the button when it is disabled.
  Color getDisabledBgColor(bool isDarkMode) {
    return AppColors.black200;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.radius),
        onTap: (widget.disabled || widget.onPressed == null)
            ? () {
                if (widget.onPressedWhenDisabled != null) {
                  widget.onPressedWhenDisabled!(controller!);
                }
              }
            : () {
                if (_isLoading == false) {
                  widget.onPressed!(controller!);
                }
              },
        child: Padding(
          padding: widget.padding!,
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(color: setBorderColor()),
              color: widget.disabled && !widget.isOutlined
                  ? getDisabledBgColor(isDarkMode)
                  : widget.isPlainBackground && !widget.isOutlined
                      ? (widget.color ?? (AppColors.secondary500))
                      : null,
            ),
            child: _isLoading
                ? Center(
                    heightFactor: 1,
                    widthFactor: 1,
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            widget.loadingColor ?? AppColors.secondary400),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (widget.prefixIcon != null)
                          ? Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: widget.prefixIcon,
                            )
                          : Container(),
                      widget.labelWidget ??
                          Text(
                            widget.label,
                            style: widget.textStyle ??
                                GoogleFonts.plusJakartaSans(
                                    color: getTextColor(isDarkMode),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                          ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Starts the loading state of the button.
  void _start() {
    setState(() {
      _isLoading = true;
    });
  }

  /// Stops the loading state of the button.
  void _stop() {
    setState(() {
      _isLoading = false;
    });
  }
}

/// Controller for managing the loading state of the button.
class LoadingButtonController {
  VoidCallback? _startLoading;
  VoidCallback? _stopLoading;

  /// Creates a controller with optional start and stop loading callbacks.
  LoadingButtonController(
      {VoidCallback? startLoading, VoidCallback? stopLoading}) {
    _startLoading = startLoading;
    _stopLoading = stopLoading;
  }

  /// Starts the loading state.
  void start() {
    _startLoading!();
  }

  /// Stops the loading state.
  void stop() {
    _stopLoading!();
  }
}

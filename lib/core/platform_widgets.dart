import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformWidgets {
  static PlatformAppBar appBar({
    required BuildContext context,
    required String title,
    List<Widget>? actions,
  }) {
    return PlatformAppBar(
      title: Text(title),
      material: (_, __) => MaterialAppBarData(
        actions: actions,
      ),
      cupertino: (_, __) => CupertinoNavigationBarData(
        trailing: actions != null ? Row(mainAxisSize: MainAxisSize.min, children: actions) : null,
      ),
    );
  }

  static Widget button({
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget child,
    Color? color,
  }) {
    return PlatformElevatedButton(
      onPressed: onPressed,
      material: (_, __) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
      ),
      cupertino: (_, __) => CupertinoElevatedButtonData(
        color: color,
      ),
      child: child,
    );
  }

  static Widget textField({
    required BuildContext context,
    required TextEditingController controller,
    String? placeholder,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return PlatformTextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      material: (_, __) => MaterialTextFieldData(
        decoration: InputDecoration(
          hintText: placeholder,
          border: const OutlineInputBorder(),
          errorText: validator?.call(controller.text),
        ),
      ),
      cupertino: (_, __) => CupertinoTextFieldData(
        placeholder: placeholder,
        decoration: BoxDecoration(
          border: Border.all(color: CupertinoColors.systemGrey4),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static Widget pageScaffold({
    required BuildContext context,
    required Widget body,
    PlatformAppBar? appBar,
    Widget? floatingActionButton,
  }) {
    Widget wrappedBody = SafeArea(child: body);
    if (floatingActionButton != null) {
      wrappedBody = Stack(
        children: [
          wrappedBody,
          Positioned(
            right: 16,
            bottom: 16,
            child: floatingActionButton,
          ),
        ],
      );
    }

    return PlatformScaffold(
      appBar: appBar,
      body: wrappedBody,
      material: (_, __) => MaterialScaffoldData(
        floatingActionButton: floatingActionButton,
      ),
      cupertino: (_, __) => CupertinoPageScaffoldData(),
    );
  }
} 
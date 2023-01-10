import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/ui/theme.dart';

class MyInputField extends ConsumerWidget {
  const MyInputField({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.widget,
    required this.action,
  });
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final TextInputAction action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final bool isDarkTheme = ref.watch(appThemeProvider).getTheme();
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            height: 52,
            padding: const EdgeInsets.only(left: 14),
            margin: const EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textInputAction: action,
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    controller: controller,
                    style: subTitleStyle.copyWith(),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle.copyWith(),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                widget == null
                    ? Container()
                    : Container(
                        child: widget,
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}

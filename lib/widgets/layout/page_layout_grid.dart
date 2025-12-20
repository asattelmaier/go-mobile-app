import 'package:flutter/material.dart';

class PageLayoutGrid extends StatelessWidget {
  final Widget header;
  final Widget? content;
  final Widget footer;
  final int topFlex;
  final int middleFlex;

  const PageLayoutGrid({
    Key? key,
    required this.header,
    this.content,
    required this.footer,
    required this.topFlex,
    required this.middleFlex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (topFlex > 0) Spacer(flex: topFlex),
        header,
        Expanded(
          flex: middleFlex,
          child: content ?? const SizedBox.shrink(),
        ),
        footer,
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
      ],
    );
  }
}

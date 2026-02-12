import 'package:contacts_phone/core/widgets/icon_widget.dart';
import 'package:flutter/material.dart';

class VoicemailPage extends StatefulWidget {
  final String title;
  const VoicemailPage({super.key, required this.title});

  @override
  State<VoicemailPage> createState() => _VoicemailPageState();
}

class _VoicemailPageState extends State<VoicemailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IconWidget(
          type: IconContentType.text,
          selected: false,
          isDark: true,
          onTap: () {},
        ),
      ),
    );
  }
}

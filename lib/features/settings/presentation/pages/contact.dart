import 'package:catchfish/features/settings/presentation/widgets/button_back.dart';
import 'package:catchfish/features/settings/presentation/widgets/contact_form.dart';
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                    ),
                    buttonBack(context),
                  ],
                ),
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(child: contactForm(context))));
  }
}

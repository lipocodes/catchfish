import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;

Widget contactForm() {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final contentController = TextEditingController();
  UI.TextDirection direction = UI.TextDirection.ltr;
  return Directionality(
    textDirection: direction,
    child: Padding(
      padding: const EdgeInsets.only(
        right: 30.0,
        left: 30.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50.0,
            ),
            const Text("contact_us",
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                )).tr(),
            const Text("catch.fish.app1@gmail.com",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w300,
                )),
            const SizedBox(
              height: 50.0,
            ),
            TextFormField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Name',
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Phone',
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'email',
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: contentController,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'content',
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "send",
                  style: TextStyle(fontSize: 28.0),
                ).tr(),
              ),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
              ),
              onPressed: () {
                print(contentController.text);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

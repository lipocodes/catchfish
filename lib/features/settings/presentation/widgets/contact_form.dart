import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'package:dio/dio.dart';

Widget contactForm(BuildContext context) {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final contentController = TextEditingController();
  UI.TextDirection direction = UI.TextDirection.ltr;

  sendMail(BuildContext context) async {
    try {
      String params =
          "name=${nameController.text}&email=${emailController.text}&phone=${phoneController.text}&content=${contentController.text}";
      var response =
          await Dio().get('https://6yamim.xyz/catchfish/mail.php?$params');
      Navigator.pop(context);
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee=" + e.toString());
      Navigator.pop(context);
    }
  }

  return Directionality(
    textDirection: direction,
    child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            //tenor.com
            'assets/images/lobby/dolphins.gif',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          right: 30.0,
          left: 30.0,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 60.0,
            ),
            const Text("contact_us",
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                )).tr(),
            const Text("catch.fish.app1@gmail.com",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                )),
            const SizedBox(
              height: 50.0,
            ),
            TextFormField(
              style: const TextStyle(
                fontSize: 24.0,
              ),
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
              style: const TextStyle(
                fontSize: 24.0,
              ),
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
              style: const TextStyle(
                fontSize: 24.0,
              ),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Email',
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              style: const TextStyle(
                fontSize: 24.0,
              ),
              controller: contentController,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                labelText: 'Content',
              ),
            ),
            const SizedBox(
              height: 20.0,
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
                sendMail(context);
              },
            ),
            const SizedBox(
              height: 200.0,
            )
          ],
        ),
      ),
    ),
  );
}

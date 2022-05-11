import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget buttonGoNavigation(BuildContext context) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    label: Text('go_to_boat'.tr()),
    icon: const Icon(Icons.cloud, size: 24.0, color: Colors.white),
    onPressed: () async {
      Navigator.pushNamed(context, '/navigation');
    },
  );
}

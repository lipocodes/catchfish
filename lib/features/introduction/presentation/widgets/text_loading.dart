import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Widget textLoading(BuildContext context, bool colorLoadingText) {
  return colorLoadingText
      ? SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: const Text(
            "loading",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.brown,
            ),
          ).tr(),
        )
      : SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: const Text(
            "loading",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.yellow,
            ),
          ).tr(),
        );
}

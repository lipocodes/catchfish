import 'package:catchfish/features/fishingShop/presentation/blocs/bloc/fishingshop_bloc.dart';
import 'package:flutter/material.dart';

Widget shopItems(state) {
  if (state is RetreiveShopItemsState) {
    print("xxxxxxxxxxxxxxxxxxxx=" + state.listItems[0].id.toString());
    return Text(
      state.listItems.length.toString(),
      style: const TextStyle(color: Colors.white),
    );
  } else {
    return Container();
  }
}

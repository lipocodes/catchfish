import 'package:catchfish/features/gameBoard/domain/usecases/fishing/fishing_usecase.dart';
import 'package:catchfish/features/gameBoard/presentation/blocs/fishing/bloc/fishing_bloc.dart';
import 'package:catchfish/features/gameBoard/presentation/widgets/personalShop/shop_items.dart';
import 'package:catchfish/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalShop extends StatefulWidget {
  const PersonalShop({Key? key}) : super(key: key);

  @override
  State<PersonalShop> createState() => _PersonalShopState();
}

class _PersonalShopState extends State<PersonalShop> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fishingUsecase = sl.get<FishingUsecase>();
    BlocProvider.of<FishingBloc>(context)
        .add(LoadingPersonalShopEvent(fishingUsecase: fishingUsecase));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            //extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: shopItems(context)));
  }
}

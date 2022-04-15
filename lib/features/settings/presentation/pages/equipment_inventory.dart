import 'package:flutter/material.dart';

class EquipmentInventory extends StatefulWidget {
  const EquipmentInventory({Key? key}) : super(key: key);

  @override
  State<EquipmentInventory> createState() => _EquipmentInventoryState();
}

class _EquipmentInventoryState extends State<EquipmentInventory> {
  //List icons = [Icons.access_alarm_outlined, Icons.access_alarm_outlined];
  List images = [
    "assets/images/lobby/scroll.jpg",
    "assets/images/lobby/scroll.jpg"
  ];
  List<String> items = [
    'Baits',
    'Rods',
  ];
  List<int> quatities = [5, 3];

  getGridViewItems(BuildContext context, String gridItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(gridItem),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (1 / 1),
        children: List.generate(items.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  // Red border with the width is equal to 5
                  border: Border.all(width: 5, color: Colors.red)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 64, height: 64, child: Image.asset(images[index])),
                  Text(items[index],
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontFamily: 'skullsandcrossbones',
                      )),
                  Text(
                    quatities[index].toString(),
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontFamily: 'skullsandcrossbones',
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

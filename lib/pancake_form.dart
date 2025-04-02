import 'package:flutter/material.dart';
import 'package:w8_practice/main.dart';
import 'package:w8_practice/model/pancake.dart';

class PancakeForm extends StatefulWidget {
  final Pancake? pancake;
  final Enum mode;
  const PancakeForm({super.key, required this.mode, this.pancake});

  @override
  State<PancakeForm> createState() => _PancakeFormState();
}

class _PancakeFormState extends State<PancakeForm> {
  String color = '';
  double price = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.mode == Mode.edit) {
      color = widget.pancake!.color;
      price = widget.pancake!.price;
    }
  }

  void addPancake() {
    final Pancake newPancake = Pancake(
      color: color,
      price: price,
    );
    Navigator.of(context).pop(newPancake);
  }

  void editPancake() {
    final updatedPancake = widget.pancake!.copyWith(
      color: color,
      price: price,
    );
    Navigator.of(context).pop(updatedPancake);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: widget.mode == Mode.edit ? '' : "Enter Color",
            ),
            initialValue: widget.mode == Mode.edit ? color : '',
            onChanged: (value) {
              color = value;
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: widget.mode == Mode.edit ? '' : "Enter Price",
            ),
            initialValue: widget.mode == Mode.edit ? price.toString() : '',
            onChanged: (value) {
              price = double.parse(value);
            },
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: widget.mode == Mode.edit ? editPancake : addPancake,
            child: widget.mode == Mode.edit ? Text("Update") : Text("Create"),
          )
        ],
      ),
    );
  }
}

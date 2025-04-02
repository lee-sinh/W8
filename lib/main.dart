import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w8_practice/model/pancake.dart';
import 'package:w8_practice/pancake_form.dart';
import 'package:w8_practice/provider/pancake_provider.dart';
import 'package:w8_practice/repository/firebase_pancake_repository.dart';
import 'package:w8_practice/repository/pancake_repository.dart';

enum Mode { create, edit }

class App extends StatelessWidget {
  const App({super.key});

  void _onAddPressed(BuildContext context) async {
    final Pancakeprovider pancakeProvider = context.read<Pancakeprovider>();

    final newPancake = await Navigator.of(context).push<Pancake>(
      MaterialPageRoute(
          builder: (context) => PancakeForm(
                mode: Mode.create,
              )),
    );

    if (newPancake != null) {
      pancakeProvider.addPancake(newPancake.color, newPancake.price);
    }
  }

  void _onEdit(Pancake pancake, BuildContext context) async {
    final Pancakeprovider pancakeProvider = context.read<Pancakeprovider>();

    final newPancake = await Navigator.of(context).push<Pancake>(
      MaterialPageRoute(
          builder: (context) => PancakeForm(
                mode: Mode.edit,
                pancake: pancake,
              )),
    );

    if (newPancake != null) {
      pancakeProvider.editPancake(newPancake, pancake.id!);
    }
  }

  void _onRemovePressed(String id, BuildContext context) {
    final Pancakeprovider pancakeProvider = context.read<Pancakeprovider>();
    pancakeProvider.removePancake(id);
  }

  @override
  Widget build(BuildContext context) {
    final pancakeProvider = Provider.of<Pancakeprovider>(context);

    Widget content = Text('');
    if (pancakeProvider.isLoading) {
      content = CircularProgressIndicator();
    } else if (pancakeProvider.hasData) {
      List<Pancake> pancakes = pancakeProvider.pancakesState!.data!;

      if (pancakes.isEmpty) {
        content = Text("No data yet");
      } else {
        content = ListView.builder(
          itemCount: pancakes.length,
          itemBuilder: (context, index) => ListTile(
              title: Text(pancakes[index].color),
              subtitle: Text("${pancakes[index].price}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _onRemovePressed(pancakes[index].id!, context),
                  ),
                  IconButton(
                      icon: Icon(Icons.edit, color: Colors.grey),
                      onPressed: () => _onEdit(pancakes[index], context)),
                ],
              )),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () => _onAddPressed(context),
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(child: content),
    );
  }
}

// 5 - MAIN
void main() async {
  // 1 - Create repository
  final PancakeRepository pancakeRepository = FirebasePancakeRepository();

  // 2-  Run app
  runApp(
    ChangeNotifierProvider(
      create: (context) => Pancakeprovider(pancakeRepository),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: const App()),
    ),
  );
}

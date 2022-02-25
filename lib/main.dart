import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<String> todos = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todos.addAll(['buy milk', 'create app', 'eat']);
  }

  void createItem(){
    setState(() {
      todos.add(_textEditingController.text);
      _textEditingController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    print(todos);

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('TODO'),
            centerTitle: true,
            backgroundColor: Colors.orangeAccent,
            titleTextStyle:
                const TextStyle(fontSize: 42, color: Colors.white70),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                padding: const EdgeInsets.all(10),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                   Expanded(flex: 1,
                      child: TextField(
                        controller: _textEditingController,
                        onSubmitted: (String text){
                          createItem();
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.black45,
                          filled: false,
                          helperText: 'Новое дело',
                        ),
                      )
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FloatingActionButton(
                    onPressed: createItem,
                    child: const Icon(
                      Icons.add_outlined,
                      size: 50,
                      color: Colors.white70,
                    ),
                    backgroundColor: Colors.lightBlue[400],
                  )
                ]),
              ),
              Expanded(
                flex: 1,
                child: Builder(builder: (context) {
                  if (todos.isEmpty) {
                    return const Center(
                      child: Text('Нет дел, свобода!!'),
                    );
                  }
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (_, int index) {
                      return Dismissible(
                        key: UniqueKey(),
                        confirmDismiss: (DismissDirection direction) async {
                          return showDialog<bool>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Точно сделал?'),
                                  alignment: Alignment.center,
                                  actionsPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  actionsAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  actions: [
                                    FloatingActionButton(
                                        child: const Text('Да'),
                                        backgroundColor: Colors.green.shade100,
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        }),
                                    FloatingActionButton(
                                        child: const Text('Нет'),
                                        backgroundColor:
                                            Colors.redAccent.shade100,
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        }),
                                  ],
                                );
                              });
                        },
                        direction: DismissDirection.endToStart,
                        background: Card(
                          child: Container(
                            alignment: Alignment.centerRight,
                            color: Colors.redAccent.shade200,
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white70,
                              size: 30,
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            todos.remove(todos[index]);
                          });
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(todos[index]),
                          ),
                        ),
                      );
                    },
                  );
                }),
              )
            ],
          )),
    );
  }
}

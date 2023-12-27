import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  String? _newTaskContent;
  Box? _box;
  @override
  Widget build(BuildContext context) {
    // Get the device height and width
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontSize: 30),
        ),
        toolbarHeight: _deviceHeight * 0.1,
        backgroundColor: const Color.fromARGB(185, 87, 204, 103),
      ),
      body: _taskView(),
      floatingActionButton: _addNewTaskFloatingActionButton(),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
        future: Hive.openBox('tasksData'),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            _box = snapshot.data;
            return _tasksList();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }

  Widget _tasksList() {
    List tasks = _box!.values.toList();
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          var task = Task.fromMap(tasks[index]);
          return ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: Text(
              task.content,
              style: TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(task.timeStamp.toString()),
            trailing: task.completed
                ? const Icon(Icons.check_box)
                : const Icon(Icons.check_box_outline_blank),
            onTap: () {
              task.completed = !task.completed;
              _box!.putAt(
                index,
                task.toMap(),
              );
              setState(() {});
            },
            onLongPress: () {
              _box!.deleteAt(index);
              setState(() {});
            },
          );
        });
  }

  Widget _addNewTaskFloatingActionButton() {
    return FloatingActionButton(
      onPressed: displayAddTaskPopup,
      child: const Icon(Icons.add),
    );
  }

  //
  void displayAddTaskPopup2() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add New Task'),
            actions: [
              TextButton(
                onPressed: () {
                  if (_newTaskContent != null) {
                    var _newTask = Task(
                        content: _newTaskContent!,
                        timeStamp: DateTime.now(),
                        completed: false);
                    _box?.add(_newTask.toMap());
                    //re render and to not display the content again
                    setState(() {
                      _newTaskContent = null;
                      Navigator.pop(context);
                    });
                  } else {}
                },
                child: Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
            content: TextField(
              onChanged: (value) {
                _newTaskContent = value;
              },
              onSubmitted: (value) {
                if (_newTaskContent != null) {
                  var _newTask = Task(
                      content: _newTaskContent!,
                      timeStamp: DateTime.now(),
                      completed: false);
                  _box?.add(_newTask.toMap());
                  //re render and to not display the content again
                  setState(() {
                    _newTaskContent = null;
                    Navigator.pop(context);
                  });
                } else {}
              },
            ),
          );
        });
  }

  void displayAddTaskPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add New Task'),
            content: TextField(
              onChanged: (value) {
                _newTaskContent = value;
              },
              onSubmitted: (value) {
                if (_newTaskContent != null) {
                  var _newTask = Task(
                      content: _newTaskContent!,
                      timeStamp: DateTime.now(),
                      completed: false);
                  _box?.add(_newTask.toMap());
                  //re render and to not display the content again
                  setState(() {
                    _newTaskContent = null;
                    Navigator.pop(context);
                  });
                } else {}
              },
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:todo_retrofit/main.dart';

import '../services/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: FutureBuilder(
        future: client.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          if (snapshot.hasData) {
            final tasks = snapshot.data!;
            return RefreshIndicator(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  // swipe to delete task
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      // TODO : Delete
                      client.deleteTask('${tasks[index].id}').then((value) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Deleted!'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(milliseconds: 300),
                        ));
                      });
                    },
                    child: CheckboxListTile(
                      title: Text(
                        '${tasks[index].title}',
                        style: TextStyle(
                            decoration: (tasks[index].completed!)
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      onChanged: (bool? value) {
                        // TODO : update status
                        client.updateTaskPart(tasks[index].id!,
                            {'completed': value}).then((value) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Updated!'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(milliseconds: 300),
                          ));
                          // refresh
                          setState(() {});
                        });
                      },
                      value: tasks[index].completed,
                    ),
                  );
                },
              ),
              onRefresh: () async {
                setState(() {});
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add task
          final taskTextController = TextEditingController();
          final formKey = GlobalKey<FormState>();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Form(key: formKey, child: const Text('Task')),
              content: TextFormField(
                controller: taskTextController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter task';
                  }

                  return null;
                },
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    // TODO : save task
                    if (formKey.currentState!.validate()) {
                      client
                          .createTask(
                        Task(
                          title: taskTextController.text.trim(),
                          completed: false,
                          createdAt: DateTime.now(),
                        ),
                      )
                          .then((value) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Added!'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(milliseconds: 300),
                        ));
                        setState(() {});
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ).then((value) {
            // refresh page
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

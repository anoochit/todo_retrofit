import 'package:flutter/material.dart';
import 'package:todo_retrofit/main.dart';

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
                    },
                    child: CheckboxListTile(
                      title: Text('${tasks[index].title}'),
                      onChanged: (bool? value) {
                        // TODO : update status
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

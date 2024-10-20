import 'package:enhanzer/models/task_model.dart';
import 'package:enhanzer/screen/task_editing_screen.dart';
import 'package:enhanzer/service/task_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<TaskViewModel>(context, listen: false).fetchTasks();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TaskViewModel>(context);
    final tasks = viewModel.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        backgroundColor: Colors.orange.shade200,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade200, Colors.deepOrange.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Decorative Element 
          Positioned(
            top: -50,
            right: -50,
            child: Icon(
              Icons.task_alt,
              size: 200,
              color: const Color.fromARGB(255, 17, 16, 16).withOpacity(0.2),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            right: MediaQuery.of(context).size.width * 0.5,
            child: Icon(
              Icons.task_outlined,
              size: 200,
              color: const Color.fromARGB(255, 17, 16, 16).withOpacity(0.2),
            ),
          ),
          // Task List
          isLoading
              ? Center(child: CircularProgressIndicator())
              : tasks.isEmpty
                  ? Center(child: Text('No tasks available.'))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Slidable(
                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) =>
                                      _deleteTaskAtIndex(index),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Checkbox(
                                    value: task.isCompleted,
                                    onChanged: (value) {
                                      viewModel.updateTask(
                                        Task(
                                          id: task.id,
                                          title: task.title,
                                          isCompleted: value ?? false,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final updatedTask = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskEditingScreen(task: task),
                                  ),
                                ).then((_) {
                                  _loadTasks();
                                });

                                if (updatedTask != null) {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskEditingScreen(),
            ),
          ).then((_) {
            _loadTasks();
          });

          if (newTask != null) {
            setState(() {});
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _deleteTaskAtIndex(int index) {
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);
    viewModel.deleteTask(viewModel.tasks[index].id!);
  }
}

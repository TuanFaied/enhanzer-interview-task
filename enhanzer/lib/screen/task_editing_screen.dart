import 'package:enhanzer/models/task_model.dart';
import 'package:enhanzer/service/task_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskEditingScreen extends StatefulWidget {
  final Task? task;

  TaskEditingScreen({this.task});

  @override
  _TaskEditingScreenState createState() => _TaskEditingScreenState();
}

class _TaskEditingScreenState extends State<TaskEditingScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  bool _isCompleted = false;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _isCompleted = widget.task?.isCompleted ?? false;
    _description = widget.task?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        
        actions: [
          IconButton(
            onPressed: _saveTask,
            icon: Icon(Icons.save, color: Colors.black),
          ),
          widget.task == null
              ? const SizedBox()
              : IconButton(
                  onPressed: () => _deleteTask(
                    Provider.of<TaskViewModel>(context, listen: false)
                        .tasks
                        .indexOf(widget.task!),
                  ),
                  icon: Icon(Icons.delete),
                ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/parchment_background.jpg'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.1,
          //     child: Image.asset(
          //       'assets/images/lines_overlay.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // Main Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: _title,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Task Title',
                      hintStyle: TextStyle(
                        fontFamily: 'DancingScript', // Handwritten font
                        fontSize: 22,
                        color: Colors.brown.shade700,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontFamily: 'DancingScript', // Handwritten font
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _title = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    initialValue: _description,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Task Description',
                      hintStyle: TextStyle(
                        fontFamily: 'DancingScript', // Handwritten font
                        fontSize: 18,
                        color: Colors.brown.shade700,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontFamily: 'DancingScript', // Handwritten font
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  CheckboxListTile(
                    title: Text(
                      'Completed',
                      style: TextStyle(
                        fontFamily: 'DancingScript', // Handwritten font
                        fontSize: 20,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value!;
                      });
                    },
                    activeColor: Colors.brown,
                    checkColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final viewModel = Provider.of<TaskViewModel>(context, listen: false);
      if (widget.task == null) {
        viewModel.addTask(Task(
          title: _title,
          isCompleted: _isCompleted,
          description: _description,
        ));
      } else {
        viewModel.updateTask(Task(
          id: widget.task!.id,
          title: _title,
          isCompleted: _isCompleted,
          description: _description,
        ));
      }
      Navigator.pop(context);
    }
  }

  void _deleteTask(int index) {
    final viewModel = Provider.of<TaskViewModel>(context, listen: false);
    viewModel.deleteTask(viewModel.tasks[index].id!);
    Navigator.pop(context);
  }
}

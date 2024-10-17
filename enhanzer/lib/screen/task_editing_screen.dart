// task_editing_screen.dart
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
        actions: [IconButton(onPressed: _saveTask, icon: Icon(Icons.save)),
        widget.task == null ? const SizedBox() : IconButton( onPressed: () => _deleteTask(Provider.of<TaskViewModel>(context, listen: false).tasks.indexOf(widget.task!)), icon: Icon(Icons.delete))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Task Title'),
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
              TextFormField(
                initialValue: _description,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(hintText: 'Task Description'),
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
              CheckboxListTile(
                title: Text('Completed'),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value!;
                  });
                },
              ),
              
              
              
            ],
          ),
        ),
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
          description: _description,));
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

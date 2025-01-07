import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_firebase/core/utils/constants.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_firebase/features/manage_task/presentation/bloc/task_event.dart';
import 'package:task_manager_firebase/features/manage_task/domain/entities/task_entity.dart';

extension DateTimeExtensions on DateTime {
  DateTime startOfDay() {
    return DateTime(this.year, this.month, this.day);
  }
}

class TaskForm extends StatefulWidget {
  final String userId;
  final TaskEntity? task;

  const TaskForm({Key? key, required this.userId, this.task}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String _priority = Constants.priorityMediumText;

  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isShaking = false;

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _triggerShakeAnimation() {
    setState(() {
      _isShaking = true;
    });
    _animationController.forward().then((_) {
      _animationController.reverse().then((_) {
        setState(() {
          _isShaking = false;
        });
      });
    });
  }

  void _submitTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_dueDate == null ||
          _dueDate!.isBefore(DateTime.now().toLocal().startOfDay())) {
        _triggerShakeAnimation();
        return;
      }

      final task = TaskEntity(
        id: widget.task?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate!,
        priority: _priority,
        userId: widget.userId,
      );

      if (widget.task == null) {
        // Dispatch AddTaskEvent if it's a new task
        BlocProvider.of<TaskBloc>(context)
            .add(AddTaskEvent(task, widget.userId));
      } else {
        // Dispatch UpdateTaskEvent if it's an update
        BlocProvider.of<TaskBloc>(context)
            .add(UpdateTaskEvent(task, widget.userId));
      }

      Navigator.pop(context,true);
    } else {
      _triggerShakeAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? Constants.taskAddButton : Constants.taskEditButton),
        key: const Key(Constants.appBarTitleKey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SlideTransition(
            position: _isShaking
                ? _animation
                : const AlwaysStoppedAnimation(Offset.zero),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  key: const Key(Constants.titleFieldKey),
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: Constants.taskTitleLabel),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Constants.taskValidationTitleEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: Constants.taskDescription),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(Constants.taskDueDateLabel),
                    TextButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _dueDate = selectedDate;
                          });
                        }
                      },
                      child: Text(
                        _dueDate == null
                            ? Constants.selectDateLabel
                            : _dueDate!.toLocal().toString().split(' ')[0],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _priority,
                  items: ['High', 'Medium', 'Low']
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _priority = value ?? Constants.priorityMediumText;
                    });
                  },
                  decoration: const InputDecoration(labelText: Constants.taskPriority),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  key: const Key(Constants.addUpdateTaskButton),
                  onPressed: () => _submitTask(context),
                  child: Text(widget.task == null ? Constants.taskAddButton : Constants.taskUpdateButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
